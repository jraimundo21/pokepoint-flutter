import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utils/theme.dart';
import './checkin/geofencing.dart';
import './checkin/nfc.dart';
import './checkin/qrcode.dart';
import './checkin/manual.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

class CheckIn extends StatefulWidget {
  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  int _value = 1;
  List<DropdownMenuItem> onlineOptions = [
    DropdownMenuItem(child: Text("Geofencing"), value: 1),
    DropdownMenuItem(child: Text("QR Code"), value: 2),
  ];
  List<DropdownMenuItem> offineOptions = [
    DropdownMenuItem(child: Text("Manual"), value: 3),
    DropdownMenuItem(child: Text("NFC"), value: 4),
  ];
  String _connectionStatus = 'Unknown'; //connectivity status
  var _online = false; //connectivity online or offline
  Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    onlineOptions.addAll(offineOptions);
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState(() {
          _connectionStatus = 'Online';
          _online = true;
        });
        break;
      case ConnectivityResult.none:
        setState(() {
          _connectionStatus = 'Offline';
          _online = false;
        });
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: new Column(
          children: [
            new Container(
                color: PrimaryColor, //Colors.amber[600],
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      style: TextStyle(color: TextColor),
                      dropdownColor: PrimaryColorLight,
                      value: _value,
                      items: (!_online ? offineOptions : onlineOptions),
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                    new Text(
                      _connectionStatus,
                      style: TextStyle(
                          color: _online ? Colors.white : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    )
                  ],
                )),
            Container(
                // A sub view do método d checkint
                )
          ],
        ),
      ),
    );
  }
}
