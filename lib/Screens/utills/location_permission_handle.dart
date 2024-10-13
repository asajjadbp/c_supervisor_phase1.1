import 'package:geolocator/geolocator.dart';

import '../widgets/toast_message_show.dart';

Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showToastMessageBottom(false,'Location services are disabled. Please enable the services');
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showToastMessageBottom(false,'Location permissions are denied');
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    showToastMessageBottom(false,'Location permissions are permanently denied, we cannot request permissions.');
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}