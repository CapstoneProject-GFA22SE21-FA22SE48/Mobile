import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUtil {
  static double distanceInKM(LatLng loc1, LatLng loc2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((loc2.latitude - loc1.latitude) * p) / 2 +
        cos(loc1.latitude * p) *
            cos(loc2.latitude * p) *
            (1 - cos((loc2.longitude - loc1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  static double distanceInM(LatLng loc1, LatLng loc2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((loc2.latitude - loc1.latitude) * p) / 2 +
        cos(loc1.latitude * p) *
            cos(loc2.latitude * p) *
            (1 - cos((loc2.longitude - loc1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a)) * 1000;
  }
}
