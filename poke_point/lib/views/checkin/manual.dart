import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class Manual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Text(
        'Manual',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40),
      ),
    );
  }
}
