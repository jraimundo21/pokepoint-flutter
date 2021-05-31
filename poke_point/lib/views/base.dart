import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import './time_table.dart';
import './checkin/geofencing.dart';
import './checkin/nfc.dart';
import './checkin/qrcode.dart';
import './checkin/manual.dart';

class BaseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Header"),
      ),
      bottomNavigationBar: NavBar(),
      body: Text('BaseView'),
    );
  }
}
