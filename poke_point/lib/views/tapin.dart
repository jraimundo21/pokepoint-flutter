import 'package:flutter/material.dart';
import 'package:poke_point/utils/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import '../utils/custom_parser.dart';

class TapIn extends StatefulWidget {
  TapIn();
  @override
  _TapInState createState() => _TapInState();
}

class _TapInState extends State<TapIn> {
  final int refreshRate = 5;
  int currentSecond;
  Timer timer;

  // TODO Replace this values dinamically
  String userId = '123123';
  String userName = 'José Bacalhau';
  String workplaceId = '123123';
  String workplaceName = 'Obra do Zé';
  String credentialDataToSend;

  @override
  void initState() {
    currentSecond = refreshRate;
    renewQRCode();
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => updateCountDownTimer());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void renewQRCode() {
    this.setState(() {
      this.credentialDataToSend = CustomParser.encodeToQueryString({
        "userId": this.userId,
        'userName': this.userName,
        'workplaceId': this.workplaceId,
        'workplaceName': this.workplaceName,
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
      this.setState(() {
        currentSecond = refreshRate;
        renewQRCode();
      });
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
                    'Help your colleague check in with',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  new Text(
                    'QR Code or NFC',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 25),
                  ),
                  new Container(
                    color: PrimaryColorLight,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Text(
                          'Renewing in ',
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
                          ' seconds.',
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
            new Container(
                child: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                QrImage(
                  data: credentialDataToSend,
                  version: QrVersions.auto,
                  // size: 320,
                  gapless: false,
                  embeddedImage: AssetImage('assets/images/poke_point.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(80, 80),
                  ),
                ),
                new Container(
                    color: Colors.white,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text(
                          'Instructions:',
                          style: TextStyle(
                              color: Colors.red[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        new Text(
                          'Let your colleague scan this QR Code.\nOr, alternatively, turn on your NFC and put your mobiles together.',
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
