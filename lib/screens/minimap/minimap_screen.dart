import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/auth_controller.dart';
import 'package:vnrdn_tai/controllers/global_controller.dart';
import 'package:vnrdn_tai/controllers/maps_controller.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';
import 'package:vnrdn_tai/screens/auth/login_screen.dart';
import 'package:vnrdn_tai/screens/container_screen.dart';
import 'package:vnrdn_tai/screens/feedbacks/feedbacks_screen.dart';
import 'package:vnrdn_tai/services/GPSSignService.dart';
import 'package:vnrdn_tai/services/NotificationService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/image_util.dart';
import 'package:vnrdn_tai/utils/location_util.dart';

class MinimapScreen extends StatefulWidget {
  const MinimapScreen({Key? key}) : super(key: key);

  @override
  State<MinimapScreen> createState() => _MinimapState();
}

class _MinimapState extends State<MinimapScreen> {
  GlobalController gc = Get.put(GlobalController());
  AuthController ac = Get.put(AuthController());
  final Completer<GoogleMapController> gmapController = Completer();
  final CustomInfoWindowController _infoWindowcontroller =
      CustomInfoWindowController();
  late final NotificationService notificationService;
  MapsController mc = Get.put(MapsController());

  late List<GPSSign> gpsSigns = [];
  final List<Marker> _markers = <Marker>[].obs;
  int count = 0;

  LocationData? currentLocation;
  LocationData? lastFetchLocation;
  LatLng defaultLocation = const LatLng(10.841809162754405, 106.8097469445683);

  void setCustomMarkerIcon(List<GPSSign> list) async {
    _markers.clear();

    for (var s in list) {
      String sFullName = 'Biển ';
      sFullName += (s.signName != null
          ? s.signName!.split(" \"").last.split("\"").first
          : 'không xác định');
      String sName =
          sFullName.length > 30 ? sFullName.substring(1, 30) : sFullName;
      var testImagePath =
          ImageUtil.getLocalImagePathFromUrl(s.imageUrl!, mc.zoom.value);
      var bytes = (await rootBundle.load(testImagePath!)).buffer.asUint8List();
      Uint8List dataBytes = bytes;

      if (mounted) {
        setState(() {
          dataBytes = bytes;
        });
      }

      _markers.add(
        Marker(
          onTap: () {
            _infoWindowcontroller.addInfoWindow!(
              GestureDetector(
                onTap: () {},
                child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: kDefaultPaddingValue / 2,
                      horizontal: kDefaultPaddingValue / 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kDefaultPaddingValue),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFE0E0E0),
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: s.imageUrl as String,
                            imageBuilder: (context, imageProvider) => Container(
                              width: 25.w,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  //image size fill
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              alignment: Alignment.center,
                              child:
                                  const CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
                            ), //show progress  while loading image
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/images/alt_image.png"),
                            //show no iamge availalbe image on error laoding
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              sName,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: FONTSIZES.textLarge,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPaddingValue / 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: gc.userId.value.isNotEmpty
                                    ? () => Get.to(() => LoaderOverlay(
                                          child: FeedbacksScreen(
                                            type: '',
                                            sign: s,
                                          ),
                                        ))
                                    : () => DialogUtil.showAwesomeDialog(
                                        context,
                                        DialogType.warning,
                                        "Cảnh báo",
                                        "Bạn cần đăng nhập để tiếp tục.\nĐến trang đăng nhập?",
                                        () => Get.to(() => const LoginScreen()),
                                        () {}),
                                child: const Text(
                                  "Thông tin chưa đúng?",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
              LatLng(s.latitude, s.longitude),
            );
          },
          icon: BitmapDescriptor.fromBytes(
            dataBytes.buffer.asUint8List(),
            size: const Size(0.005, 0.005),
          ),
          markerId: MarkerId(s.id),
          position: LatLng(s.latitude, s.longitude),
        ),
      );
    }
  }

  Future getCurrentLocation() async {
    mc.location.getLocation().then((location) {
      currentLocation = location;
      getSignsList(location);
      return location;
    });
  }

  void onLocationChanged() {
    mc.location.onLocationChanged.listen((newLoc) {
      var distance = 0.0;
      var distanceToFetch = 0.0;
      if (currentLocation != null && lastFetchLocation != null) {
        distance = LocationUtil.distanceInM(
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            LatLng(newLoc.latitude!, newLoc.longitude!));
        distanceToFetch = LocationUtil.distanceInM(
            LatLng(lastFetchLocation!.latitude!, lastFetchLocation!.longitude!),
            LatLng(newLoc.latitude!, newLoc.longitude!));
        currentLocation = newLoc;

        if (distanceToFetch > 500) {
          count = 0;
          lastFetchLocation = newLoc;
          getSignsList(currentLocation!);
        } else {
          count++;
        }
        print(count);
      } else {
        count++;
        currentLocation = newLoc;
        lastFetchLocation = newLoc;
      }
      if (count > 5) {
        count = 0;
        getSignsList(currentLocation!);
      }
      if (distance.round() > 1) {
        getRangeFromUser(newLoc);
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  getRangeFromUser(LocationData userLocation) async {
    if (mc.listSigns.isNotEmpty) {
      for (var sign in mc.listSigns.value) {
        var distance = LocationUtil.distanceInM(
            LatLng(userLocation.latitude!, userLocation.longitude!),
            LatLng(sign.latitude, sign.longitude));
        if (distance.round() <= 5) {
          await notificationService.showLocalNotification(
              id: 0,
              title: "Cảnh báo!!!",
              image: sign.imageUrl!,
              body:
                  "Bạn đang tới gần biển số ${sign.imageUrl!.split("%2F")[2].split(".png")[0]}",
              payload: "Redirecting...");
        }
      }
    }
  }

  void getSignsList(LocationData curLocation) async {
    if (curLocation.latitude != null && curLocation.longitude != null) {
      await GPSSignService()
          .GetNearbySigns(
        curLocation.latitude!,
        curLocation.longitude!,
        1,
      )
          .then((signs) {
        if (signs.isNotEmpty) {
          gpsSigns = signs;
          mc.updateGpsSigns(signs);
          setCustomMarkerIcon(signs);
        }
      });
    }
  }

  Future<bool> grantPermissionLocation() async {
    if (await Permission.location.isGranted) {
      return true;
    } else {
      var pLocation = await Permission.location.request();

      if (pLocation.isPermanentlyDenied || pLocation.isDenied) {
        openAppSettings();
        return false;
      } else {
        return true;
      }
    }
  }

  void listenToNotificationStream() {
    notificationService.behaviorSubject.listen((payload) {
      print('[MINIMAP] listening notifications');
      // gc.updateTab(3);
      // Get.to(() => const ContainerScreen());
    });
  }

  @override
  void initState() {
    super.initState();
    grantPermissionLocation().then((value) {
      if (value) {
        notificationService = NotificationService();
        listenToNotificationStream();
        notificationService.initializePlatformNotifications();
        getCurrentLocation().then((value) => onLocationChanged());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await true;
      },
      child: currentLocation == null
          ? loadingScreen()
          : Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                SafeArea(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    rotateGesturesEnabled: true,
                    compassEnabled: true,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    trafficEnabled: true,
                    minMaxZoomPreference: const MinMaxZoomPreference(15, 22),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      ),
                      zoom: mc.zoom.value,
                    ),
                    markers: _markers.toSet(),
                    onTap: (position) {
                      _infoWindowcontroller.hideInfoWindow!();
                    },
                    onCameraMove: (position) {
                      _infoWindowcontroller.onCameraMove!();
                      // gmapController.future.then((controller) =>
                      //     controller.animateCamera(CameraUpdate.zoomTo(18.0)));
                      _infoWindowcontroller.googleMapController!
                          .getZoomLevel()
                          .then((value) {
                        if (value != mc.zoom.value) {
                          setCustomMarkerIcon(gpsSigns);
                          mc.updateZoom(value);
                        }
                      });
                    },
                    onMapCreated: (controller) {
                      gmapController.complete(controller);
                      _infoWindowcontroller.googleMapController = controller;
                    },
                  ),
                ),
                CustomInfoWindow(
                  controller: _infoWindowcontroller,
                  height: 24.h,
                  width: 70.w,
                  offset: 0,
                ),
              ],
            ),
    );
  }
}
