import 'package:flutter/material.dart';
import 'package:poke_point/utils/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import '../utils/custom_parser.dart';
import '../utils/db_helper.dart';
import '../models/employee.dart';
import '../models/checkin.dart';
import '../models/workplace.dart';
import 'package:connectivity/connectivity.dart';
import '../utils/connection.dart';

class TapIn extends StatefulWidget {
  TapIn();
  @override
  _TapInState createState() => _TapInState();
}

class _TapInState extends State<TapIn> {
  Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final int refreshRate = 5;
  int currentSecond;
  Timer timer;
  CheckIn lastCheckIn;
  Employee employee;
  Workplace workplace;
  String credentialDataToSend;

  void prepareDataForTapIn() async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();
    // await dbHelper.cacheData();
    employee = await dbHelper.getEmployee();
    lastCheckIn = await dbHelper.getLastCheckIn();
    workplace = await dbHelper.getWorkplace(lastCheckIn?.idWorkplace);

    renewQRCode();
  }

  @override
  void initState() {
    prepareDataForTapIn();
    currentSecond = refreshRate;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => updateCountDownTimer());
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

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    timer?.cancel();
    super.dispose();
  }

  void renewQRCode() {
    if (mounted)
      this.setState(() {
        this.credentialDataToSend = CustomParser.encodeToQueryString({
          "employeeId": this.employee.id,
          'employeeName': this.employee.name,
          'workplaceId': this.workplace.id,
          'workplaceName': this.workplace.name,
          'timestamp': new DateTime.now().millisecondsSinceEpoch
        });
      });
  }

  void updateCountDownTimer() {
    if (currentSecond > 1 && currentSecond <= refreshRate) {
      this.setState(() {
        --currentSecond;
      });
    } else {
      if (mounted) {
        this.setState(() {
          currentSecond = refreshRate;
          renewQRCode();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0xFF11443c), //Colors.amber[600],
              height: MediaQuery.of(context).size.height * 0.15, //150 ?
              width: MediaQuery.of(context).size.width,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Text(
                    'Tap in',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                  new Text(
                    'Ajuda o teu colega a fazer check-in com',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  new Text(
                    'QR Code', // or NFC',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 25),
                  ),
                  credentialDataToSend == null
                      ? new Container()
                      : new Container(
                          color: PrimaryColorLight,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new Text(
                                'O código renova em ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 17),
                              ),
                              new Text(
                                currentSecond.toString(),
                                style: TextStyle(
                                    color: SecondaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                              new Text(
                                ' segundos.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
            credentialDataToSend == null
                ? Image(
                    image: AssetImage('assets/images/loading2.gif'),
                  )
                : new Container(
                    child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QrImage(
                        data: credentialDataToSend,
                        version: QrVersions.auto,
                        // size: 320,
                        gapless: false,
                        embeddedImage:
                            AssetImage('assets/images/poke_point.png'),
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: Size(80, 80),
                        ),
                      ),
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          height: 70,
                          color: Colors.white,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new Text(
                                'Instruções:',
                                style: TextStyle(
                                    color: Colors.red[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              new Text(
                                'Deixa o teu colega fazer scan do código.',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ],
                          ))
                    ],
                  ))
          ],
        ),
      ),
    );
  }
}
