import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key,required this.currentLat,required this.currentLong,required this.storeLat,required this.storeLong}) : super(key: key);

  final String currentLat;
  final String currentLong;

  final String storeLat;
  final String storeLong;

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {

  late CameraPosition initialPosition;
  
  @override
  void initState() {
    // TODO: implement initState
    
    initialPosition = CameraPosition(
        target: LatLng(double.parse(widget.currentLat), double.parse(widget.currentLong)),
      zoom: 14

    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
          initialCameraPosition: initialPosition,
      ),
    );
  }
}
