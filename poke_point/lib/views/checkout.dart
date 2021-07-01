import 'package:flutter/material.dart';
import 'package:poke_point/models/timecard.dart';
import 'package:poke_point/models/employee.dart';
import '../utils/toaster.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import '../utils/connection.dart';
import '../utils/db_helper.dart';
import '../models/checkin.dart';
import 'package:intl/intl.dart';

class CheckOut extends StatefulWidget {
  CheckOut({Key key, this.changeCheckOutToCheckIn, this.changeBackToTimeTable})
      : super(key: key);

  final Function() changeCheckOutToCheckIn;
  final Function() changeBackToTimeTable;

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> with TickerProviderStateMixin {
  DbHelper dbHelper = new DbHelper();
  Timer timer;
  bool isCheckOutPressed = false;
  Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  int checkInTimestampInMillis;
  String timeToDisplay;

  void updateCheckInTimeInMillis() async {
    DateTime now = new DateTime.now();
    int millisSinceCheckIn =
        now.millisecondsSinceEpoch - checkInTimestampInMillis;

    setState(() {
      timeToDisplay = DateFormat('HH:mm:ss')
          .format(new DateTime.fromMillisecondsSinceEpoch(millisSinceCheckIn));
    });
  }

  void getLastCheckIn() async {
    await dbHelper.openDb();
    CheckIn checkIn = await dbHelper.getLastCheckIn();
    DateTime chekInDt = DateTime.parse(checkIn.timestamp);
    checkInTimestampInMillis = chekInDt.millisecondsSinceEpoch;
  }

  @override
  void initState() {
    getLastCheckIn();
    updateCheckInTimeInMillis();
    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) => {updateCheckInTimeInMillis()},
    );
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    timer?.cancel();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile)
      setState(() {
        Connection.synchronize();
      });
  }

  void checkOut() async {
    setState(() {
      isCheckOutPressed = true;
    });
    if (!(await Employee.isCheckedIn())) {
      MyToast.show(2, 'Already checked-out');
      widget.changeCheckOutToCheckIn();
    } else {
      bool isCheckOutSuccess = await Timecard.registerCheckOut();
      MyToast.show(
          isCheckOutSuccess ? 1 : 3,
          isCheckOutSuccess
              ? "Check-out com sucesso."
              : "Falha a fazer check-out, tenta novamente mais tarde.");

      if (isCheckOutSuccess)
        widget.changeCheckOutToCheckIn();
      else
        widget.changeBackToTimeTable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                color: Color(0xFF11443c), //Colors.amber[600],
                height: MediaQuery.of(context).size.height * 0.15, //150 ?,
                width: MediaQuery.of(context).size.width,
                child: new Column(
                  children: [
                    Text(
                      'Checkout',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    Text(
                      'Tempo checked-in: ${checkInTimestampInMillis == null ? '' : timeToDisplay}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                )),
            Container(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 300,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    isCheckOutPressed
                        ? Image(
                            image: AssetImage('assets/images/loading2.gif'),
                          )
                        : ElevatedButton(
                            child: Text(
                              'Check Out!',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: Colors.red[900],
                              onSurface: Colors.grey,
                              side: BorderSide(color: Colors.black, width: 0.4),
                              elevation: 20,
                              minimumSize: Size(200, 200),
                              shadowColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                            onPressed: checkOut,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
