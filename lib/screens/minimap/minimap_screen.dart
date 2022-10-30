import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';
import 'package:vnrdn_tai/models/dtos/searchSignDTO.dart';
import 'package:vnrdn_tai/screens/search/sign/search_sign_detail.dart';
import 'package:vnrdn_tai/screens/search/sign/search_sign_list.dart';
import 'package:vnrdn_tai/services/GPSSignService.dart';
import 'package:vnrdn_tai/shared/snippets.dart';

class MinimapScreen extends StatefulWidget {
  const MinimapScreen({Key? key}) : super(key: key);

  @override
  State<MinimapScreen> createState() => _MinimapState();
}

class _MinimapState extends State<MinimapScreen> {
  final Completer<GoogleMapController> mc = Completer();
  late Future<List<GPSSign>> gpsSigns;
  final Set<Marker> _markers = new Set();

  LocationData? currentLocation;

  static const LatLng sourceLocation =
      LatLng(10.872357699429106, 106.97348777271252);
  static const LatLng destination =
      LatLng(10.87345346035103, 106.97534388599888);
  BitmapDescriptor soucreIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  void setCustomMarkerIcon() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
              devicePixelRatio: 0.2,
            ),
            "assets/images/443.png")
        .then((icon) => soucreIcon = icon);
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 80.0), "assets/images/112.png")
        .then((icon) => destinationIcon = icon);
  }

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
    });

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;

      if (mounted) {
        setState(() {});
      }
    });
  }

  void GetNearbySigns() async {
    await GPSSignService()
        .getNearbySigns(
            currentLocation!.latitude!, currentLocation!.longitude!, 1.0)
        .then((list) {
      if (list.isNotEmpty) {}
    }, onError: (err) {
      print(err);
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    setCustomMarkerIcon();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              trafficEnabled: true,
              initialCameraPosition: CameraPosition(
                target: sourceLocation,
                zoom: 13.5,
              ),
              markers: {
                Marker(
                    markerId: const MarkerId("source"),
                    position: sourceLocation,
                    icon: soucreIcon,
                    onTap: () {
                      //this is what you're looking for!
                      print("Tapped ne");
                      Get.to(SearchSignListScreen());
                    }),
                Marker(
                    markerId: const MarkerId("destination"),
                    position: destination,
                    icon: destinationIcon,
                    onTap: () {
                      //this is what you're looking for!
                      print("Tapped ne");
                    }),
              },
              onMapCreated: (mapController) {
                mc.complete(mapController);
              },
            ),
    );
  }
}
