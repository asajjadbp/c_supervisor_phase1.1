import 'package:c_supervisor/Screens/utills/user_constants.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:shared_preferences/shared_preferences.dart';

Future<double> calculateDistance(String latLongString,Position? currentLocation) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  int geoFence = sharedPreferences.getInt(UserConstants().userGeoFence)!;


  print(geoFence);
  print("GeoFence");
  if(geoFence == 1 || geoFence == 1.0) {

  List<String> latLong = latLongString.split(",");

  double lat1 = currentLocation!.latitude;
  double lat2 = currentLocation.longitude;
  double lon1 = double.parse(latLong[0]);
  double lon2 = double.parse(latLong[1]);

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  } else {
    return 1;
  }

  // double distanceInMeters = Geolocator.distanceBetween(
  //   currentLocation!.latitude,
  //   currentLocation.longitude,
  //   double.parse(latLong[0]),
  //   double.parse(latLong[1]),
  // );
  // double distanceInKm = distanceInMeters / 1000.0;

  // return distanceInKm;
}