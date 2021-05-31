import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import './time_table.dart';
import './checkin.dart';

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
