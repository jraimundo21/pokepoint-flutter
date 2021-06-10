import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class GeoFencing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Text(
        'Geofencing',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40),
      ),
    );
  }
}
