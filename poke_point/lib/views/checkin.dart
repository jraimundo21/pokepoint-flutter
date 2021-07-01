import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utils/theme.dart';
import './checkin/geofencing.dart';
import './checkin/qrcode.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'dart:ui';
import '../models/employee.dart';
import '../utils/connection.dart';

class CheckIn extends StatefulWidget {
  CheckIn({Key key, this.changeCheckInToCheckOut, this.changeBackToTimeTable})
      : super(key: key);

  final Function() changeCheckInToCheckOut;
  final Function() changeBackToTimeTable;

  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  int _option = 1;

  String _connectionStatus = 'Unknown'; //connectivity status
  var _online = false; //connectivity online or offline
  Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  void checkCheckInStatus() async {
    if (await Employee.isCheckedIn()) widget.changeCheckInToCheckOut();
  }

  @override
  void initState() {
    super.initState();
    checkCheckInStatus();
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
          Connection.synchronize();
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
    List<DropdownMenuItem> offineOptions = [
      // DropdownMenuItem(child: Text("Manual"), value: 1),
      DropdownMenuItem(child: Text("QR Code"), value: 1), //2
      // DropdownMenuItem(child: Text("NFC"), value: 3),
    ];
    List<DropdownMenuItem> onlineOptions = [
      DropdownMenuItem(child: Text("Geofencing"), value: 2), //4
    ];
    onlineOptions.addAll(offineOptions);
    Map<int, Widget> checkInViews = {
      // 1: Manual(),
      1: QRCode(
          // 2
          changeCheckInToCheckOut: widget.changeCheckInToCheckOut,
          changeBackToTimeTable: widget.changeBackToTimeTable),
      // 3: NFCCheckIn(),
      2: GeoFencing(
          // 4
          changeCheckInToCheckOut: widget.changeCheckInToCheckOut,
          changeBackToTimeTable: widget.changeBackToTimeTable),
    };

    return Scaffold(
      body: Container(
        child: new Column(
          children: [
            new Container(
              color: PrimaryColor, //Colors.amber[600],
              height: MediaQuery.of(context).size.height * 0.15, //150 ?
              width: MediaQuery.of(context).size.width,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    style: TextStyle(
                      color: TextColor,
                      fontSize: 18,
                    ),
                    dropdownColor: PrimaryColorLight,
                    value: _option,
                    items: (!_online ? offineOptions : onlineOptions),
                    onChanged: (value) {
                      setState(() {
                        _option = value;
                      });
                    },
                  ),
                  new Text(
                    _connectionStatus,
                    style: TextStyle(
                        color: _online ? Colors.white : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )
                ],
              ),
            ),
            checkInViews[_option],
          ],
        ),
      ),
    );
  }
}
