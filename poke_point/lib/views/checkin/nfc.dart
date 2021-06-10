import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class NFC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Text(
        'NFC',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40),
      ),
    );
  }
}
