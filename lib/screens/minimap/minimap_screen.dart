import 'dart:async';
import 'dart:typed_data';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:vnrdn_tai/controllers/maps_controller.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';
import 'package:vnrdn_tai/services/GPSSignService.dart';
import 'package:vnrdn_tai/shared/snippets.dart';
import 'package:vnrdn_tai/utils/dialogUtil.dart';
import 'package:vnrdn_tai/utils/location_util.dart';
import 'package:vnrdn_tai/widgets/templated_buttons.dart';

class MinimapScreen extends StatefulWidget {
  const MinimapScreen({Key? key}) : super(key: key);

  @override
  State<MinimapScreen> createState() => _MinimapState();
}

class _MinimapState extends State<MinimapScreen> {
  final Completer<GoogleMapController> gmapController = Completer();
  final CustomInfoWindowController _infoWindowcontroller =
      CustomInfoWindowController();
  MapsController mc = Get.put(MapsController());

  late List<GPSSign> gpsSigns;
  final List<Marker> _markers = <Marker>[].obs;

  LocationData? currentLocation;
  LatLng defaultLocation = LatLng(10.841809162754405, 106.8097469445683);
  // LatLng? lastLocation;
  int count = 0;

  List<GPSSign> listSigns = [
    GPSSign(
      "D36CC94B-251E-4785-90A9-13AB762AFE83",
      "D36CC94B-251E-4785-90A9-13AB762AFE83",
      "https://firebasestorage.googleapis.com/v0/b/vnrdntai.appspot.com/o/images%2Fsign-collection%2F443.png?alt=media",
      10.872357699429106,
      106.97348777271252,
    ),
    GPSSign(
      "390BE946-3F40-46BA-9859-55C308419A99",
      "390BE946-3F40-46BA-9859-55C308419A99",
      "https://firebasestorage.googleapis.com/v0/b/vnrdntai.appspot.com/o/images%2Fsign-collection%2F112.png?alt=media",
      10.87345346035103,
      106.97534388599888,
    ),
    GPSSign(
      "390BE946-3F40-46BA-9859-55C308419A99",
      "390BE946-3F40-46BA-9859-55C308419A99",
      "https://firebasestorage.googleapis.com/v0/b/vnrdntai.appspot.com/o/images%2Fsign-collection%2F112.png?alt=media",
      10.841809162754405,
      106.8097469445683,
    ),
  ];
  // LatLng school = LatLng(10.841809162754405, 106.8097469445683);

  void setCustomMarkerIcon(List<GPSSign> list) async {
    _markers.clear();

    for (var s in list) {
      var request = await http.get(Uri.parse(s.imageUrl!));
      var bytes = request.bodyBytes;
      Uint8List dataBytes = bytes;
      String sTitle =
          s.imageUrl!.split("%2F")[2].split("?")[0].removeAllWhitespace;
      // print(sTitle);

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
                onTap: (() {
                  // print(s.signId);
                }),
                child: Container(
                  height: 5.h,
                  width: 30.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline_rounded),
                      Text("Xem thêm"),
                    ],
                  ),
                ),
              ),
              LatLng(s.latitude, s.longitude),
            );
          },
          icon: BitmapDescriptor.fromBytes(
            dataBytes.buffer.asUint8List(),
            size: const Size(5, 5),
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

  CustomInfoWindow customInfoWindow(GPSSign signInfo) {
    return CustomInfoWindow(
      controller: _infoWindowcontroller,
      width: 300,
      height: 300,
      offset: 35,
    );
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
        } else {
          currentLocation = newLoc;
        }
        if (currentLocation != null && distance > 5) {
          currentLocation = newLoc;
          getSignsList(currentLocation!);
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
        10,
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
                  minMaxZoomPreference: const MinMaxZoomPreference(10, 25),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentLocation!.latitude!,
                      currentLocation!.longitude!,
                    ),
                    zoom: mc.zoom.value,
                  ),
                  markers: _markers.toSet(),
                  onTap: (position) {},
                  onMapCreated: (controller) {
                    gmapController.complete(controller);
                    _infoWindowcontroller.googleMapController = controller;
                  },
                ),
                CustomInfoWindow(
                  controller: _infoWindowcontroller,
                  height: 200,
                  width: 300,
                  offset: 35,
                )
              ],
            ),
    );
  }
}
