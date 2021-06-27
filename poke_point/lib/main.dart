import 'package:flutter/material.dart';
import './utils/theme.dart';
import './views/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'poke-point',
      theme: MyTheme.myCustom,
      home: new Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
