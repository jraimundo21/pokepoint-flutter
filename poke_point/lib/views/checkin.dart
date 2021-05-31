import 'package:flutter/material.dart';
import './checkin/geofencing.dart';
import './checkin/nfc.dart';
import './checkin/qrcode.dart';
import './checkin/manual.dart';

class CheckIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0xFF11443c), //Colors.amber[600],
              height: 150,
            ),
            Container(
                //

                )
          ],
        ),
      ),
    );
  }
}
