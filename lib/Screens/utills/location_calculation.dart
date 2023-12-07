import 'package:geolocator/geolocator.dart';

Future<double> calculateDistance(String latLongString,Position? currentLocation) async {

  List<String> latLong = latLongString.split(",");

  double distanceInMeters = Geolocator.distanceBetween(
    currentLocation!.latitude,
    currentLocation.longitude,
    double.parse(latLong[0]),
    double.parse(latLong[1]),
  );
  double distanceInKm = distanceInMeters / 1000.0;

  return distanceInKm;
}