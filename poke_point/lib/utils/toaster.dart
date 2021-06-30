import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class MyToast {
  /// warningLevel defines the toast color:
  /// 1: Success -> green
  /// 2: Alert   -> yellow
  /// 3: Error   -> red
  static show(int warningLevel, String message) {
    Color color = Colors.grey[300];

    switch (warningLevel) {
      case 1:
        color = Colors.green[200];
        break;
      case 2:
        color = Colors.yellow[300];
        break;
      case 3:
        color = Colors.red[400];
        break;
    }

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 20.0);
  }
}
