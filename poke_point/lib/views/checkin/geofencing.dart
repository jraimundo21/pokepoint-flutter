import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity/connectivity.dart';
import '../../utils/db_helper.dart';
import 'dart:async';

class GeoFencing extends StatefulWidget {
  @override
  _GeoFencingState createState() => _GeoFencingState();
}

class _GeoFencingState extends State<GeoFencing> {
  DbHelper helper;
  Timer timer;
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition position = CameraPosition(
    target: LatLng(41.9028, 12.4964),
    zoom: 12,
  );

  @override
  void initState() {
    helper = DbHelper();
    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) => _getCurrentLocation(),
    );
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future _getCurrentLocation() async {
    bool isGeolocationAvailable = await Geolocator().isLocationServiceEnabled();
    Position _position = Position(
        latitude: this.position.target.latitude,
        longitude: this.position.target.longitude);
    if (isGeolocationAvailable) {
      try {
        _position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      } catch (error) {
        return _position;
      }
    }

    Future updateMapPosition() async {
      this.position = CameraPosition(
          target: LatLng(_position.latitude, _position.longitude), zoom: 12);

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(position));
    }

    setState(() {
      updateMapPosition();
    });
    return _position;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 290,
        child: GoogleMap(
          initialCameraPosition: position,
          // markers: Set<Marker>.of(markers),
        ),
      ),
    );
  }
}
