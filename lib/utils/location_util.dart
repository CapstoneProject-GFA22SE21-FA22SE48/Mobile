import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vnrdn_tai/models/GPSSign.dart';

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
    return 12742 * 1000 * asin(sqrt(a));
    //   double radius = EarthRadiusInMeters;
    //   return radius *
    //       2 *
    //       asin(min(
    //           1,
    //           sqrt((pow(
    //                   sin(DiffRadian(loc1.latitude, loc2.latitude) / 2.0), 2.0) +
    //               cos(ToRadian(loc1.latitude)) *
    //                   cos(ToRadian(loc2.latitude)) *
    //                   pow(sin((DiffRadian(loc1.longitude, loc2.longitude)) / 2.0),
    //                       2.0)))));
  }

  static double EarthRadiusInKilometers = 6371.0;
  static double EarthRadiusInMeters = EarthRadiusInKilometers * 1000;
  static double EarthRadiusInMiliMeters = EarthRadiusInMeters * 1000;

  static double GetRadius(String distanceUnit) {
    switch (distanceUnit.toUpperCase()) {
      case "MM":
        return EarthRadiusInMiliMeters;
      case "M":
        return EarthRadiusInMeters;
      case "KM":
      default:
        return EarthRadiusInKilometers;
    }
  }

  static double ToRadian(double d) {
    return d * (pi / 180);
  }

  static double DiffRadian(double val1, double val2) {
    return ToRadian(val2) - ToRadian(val1);
  }
}
