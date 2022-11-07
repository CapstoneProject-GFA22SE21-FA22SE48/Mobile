import 'dart:async';
import 'dart:typed_data';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
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

  late Future<List<GPSSign>> gpsSigns;
  final List<Marker> _markers = <Marker>[].obs;

  LocationData? currentLocation;
  LatLng defaultLocation = LatLng(10.841809162754405, 106.8097469445683);
  LatLng? lastLocation;
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

  void setCustomMarkerIcon() async {
    for (var s in listSigns) {
      var request = await http.get(Uri.parse(s.imageUrl!));
      var bytes = request.bodyBytes;
      Uint8List dataBytes = bytes;
      String sTitle =
          s.imageUrl!.split("%2F")[2].split(".png")[0].removeAllWhitespace;

      setState(() {
        dataBytes = bytes;
      });

      // LatLng school = LatLng(10.841809162754405, 106.8097469445683);

      _markers.add(
        Marker(
          onTap: () {
            _infoWindowcontroller.addInfoWindow!(
              Container(
                height: 10.h,
                width: 70.w,
                alignment: Alignment.center,
                child: Text(s.signId),
              ),
              LatLng(s.latitude, s.longitude),
            );
            // DialogUtil.showTextDialog(
            //   context,
            //   "Hey",
            //   "You just made it!",
            //   [TemplatedButtons.ok(context)],
            // );
          },
          icon: BitmapDescriptor.fromBytes(
            dataBytes.buffer.asUint8List(),
            size: const Size(5, 5),
          ),
          markerId: MarkerId(s.id),
          position: LatLng(s.latitude, s.longitude),
          infoWindow: InfoWindow(
            title: 'Sign: $sTitle',
            anchor: const Offset(0.5, 0.5),
          ),
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
    var status = await Permission.location.request();
    if (status.isGranted) {
      await mc.location.getLocation().then((location) {
        currentLocation = location;
        onLocationChanged();
        return location;
      }).catchError((e) => print(e));
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else {
      getCurrentLocation();
    }
  }

  void onLocationChanged() {
    mc.location.onLocationChanged.listen((newLoc) {
      count++;
      if (currentLocation != null) {
        lastLocation =
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      }
      currentLocation = newLoc;
      print(count);
    });
  }

  void getSignsList() {
    gpsSigns = GPSSignService().GetNearbySigns(
      currentLocation!.latitude!,
      currentLocation!.longitude!,
      10,
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((value) {
      getSignsList();
      setCustomMarkerIcon();
      print(gpsSigns);
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
                  minMaxZoomPreference: MinMaxZoomPreference(10, 25),
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
