import 'dart:async';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
import 'package:vnrdn_tai/services/FeedbackService.dart';
import 'package:vnrdn_tai/screens/feedbacks/feedbacks_screen.dart';
import 'package:vnrdn_tai/services/GPSSignService.dart';
import 'package:vnrdn_tai/shared/constants.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:vnrdn_tai/utils/dialog_util.dart';
import 'package:vnrdn_tai/utils/image_util.dart';
import 'package:vnrdn_tai/utils/location_util.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

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
  MapsController mc = Get.put(MapsController());

  late List<GPSSign> gpsSigns;
  final List<Marker> _markers = <Marker>[].obs;

  LocationData? currentLocation;
  LatLng defaultLocation = const LatLng(10.841809162754405, 106.8097469445683);
  int count = 0;

  void setCustomMarkerIcon(List<GPSSign> list) async {
    _markers.clear();

    for (var s in list) {
      // List<String> sParts = s.imageUrl!.split('sign-collection');
      String sName = s.imageUrl!.split("%2F")[2].split(".png")[0];
      // String ext = s.imageUrl!.split('.').last;
      // String folderScale = mc.zoom.value > 20 ? 'x05' : 'x025';
      // String scale = mc.zoom.value > 20 ? '0_50x' : '0_25x';
      // String newUrl =
      //     '${sParts.first}sign-collection%2F$folderScale%2F$sName-standard-scale-$scale.$ext';

      // var request = await http.get(Uri.parse(newUrl));
      // var bytes = request.bodyBytes;
      print("------------------------");
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
                          color: Colors.grey,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Biển số: $sName',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: FONTSIZES.textLarger,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: kDefaultPaddingValue / 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ac.role.value == 2
                                  ? GestureDetector(
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
                                              () => Get.to(
                                                  () => const LoginScreen()),
                                              () {}),
                                      child: const Text(
                                        "Thông tin chưa đúng?",
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  : Container(),
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
          // infoWindow: InfoWindow(

          //   title: 'Sign: $sTitle',
          //   anchor: const Offset(0.5, 0.5),
          // ),
        ),
      );
    }
  }

  Future getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      mc.location.getLocation().then((location) {
        currentLocation = location;
        getSignsList(location);
        return location;
      }).catchError((e) => print(e));
    } else {
      getCurrentLocation();
    }
  }

  void onLocationChanged() {
    Timer(
      Duration(milliseconds: 500),
      () => mc.location.onLocationChanged.listen((newLoc) {
        var distance = 0.0;
        if (currentLocation != null) {
          distance = LocationUtil.distanceInM(
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              LatLng(newLoc.latitude!, newLoc.longitude!));
          print(distance);
          if (distance > 500) {
            currentLocation = newLoc;
            getSignsList(currentLocation!);
          }
        } else {
          currentLocation = newLoc;
        }
        if (mounted) {
          setState(() {});
        }
      }),
    );
  }

  void getSignsList(LocationData curLocation) async {
    if (curLocation.latitude != null && curLocation.longitude != null) {
      await GPSSignService()
          .GetNearbySigns(
        curLocation.latitude!,
        curLocation.longitude!,
        100,
      )
          .then((signs) {
        if (signs.isNotEmpty) {
          gpsSigns = signs;
          setCustomMarkerIcon(signs);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((value) {
      onLocationChanged();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? loadingScreen()
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  rotateGesturesEnabled: true,
                  compassEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  trafficEnabled: true,
                  // zoomGesturesEnabled: false,
                  // zoomControlsEnabled: false,
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
                        print(value);
                      }
                    });
                  },
                  onMapCreated: (controller) {
                    gmapController.complete(controller);
                    _infoWindowcontroller.googleMapController = controller;
                  },
                ),
                CustomInfoWindow(
                  controller: _infoWindowcontroller,
                  height: 12.h,
                  width: 48.w,
                  offset: 9.h,
                )
              ],
            ),
    );
  }
}
