import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart'; //não apagar
import 'package:poke_point/utils/custom_parser.dart';
import 'package:poke_point/models/timecard.dart';
import '../../utils/toaster.dart';

class QRCode extends StatefulWidget {
  QRCode({Key key, this.changeCheckInToCheckOut, this.changeBackToTimeTable})
      : super(key: key);

  final Function() changeCheckInToCheckOut;
  final Function() changeBackToTimeTable;

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  Map qrCodeResult = {};
  Timer timer;
  final int qrCodeLifetimeInSeconds = 20; // 20 seconds
  int currentSecond;

  @override
  void initState() {
    currentSecond = this.qrCodeLifetimeInSeconds;
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        height: MediaQuery.of(context).size.height - 300,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 380,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 3,
                  color: Colors.lightGreen[50],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
              ),
              child: this.qrCodeResult.isNotEmpty
                  ? boxContentForValidQrCode()
                  : boxContentForEmptyQRCode(),
            ),
            this.qrCodeResult.isEmpty
                ? onScanButtonClick()
                : onCheckInButtonClick()
          ],
        ));
  }

  void startTimerCountDownForReset() {
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => checkIsNewQRIsNeeded());
  }

  void checkIsNewQRIsNeeded() {
    if (this.qrCodeResult.isNotEmpty &&
        this.qrCodeResult.containsKey('timestamp')) {
      int scannedTimestamp = int.parse(this.qrCodeResult['timestamp']);
      int now = new DateTime.now().millisecondsSinceEpoch;
      if (now - scannedTimestamp > this.qrCodeLifetimeInSeconds * 1000) {
        timer?.cancel();
        this.setState(() {
          this.qrCodeResult = {};
          currentSecond = this.qrCodeLifetimeInSeconds;
        });
      } else {
        this.setState(() {
          --currentSecond;
        });
      }
    }
  }

//      Usado em modo dev
// Comentar aqui, descomentar a de baixo.
  // Future<void> scanQRCode() async {
  //   setState(() {
  //     this.qrCodeResult = CustomParser.decodeFromQueryString(
  //         'timestamp=${(new DateTime.now().millisecondsSinceEpoch)}&userId=124123&userName=José Bacalhau&workplaceId=1234432&workplaceName=Local De Trabalho 1');
  //     startTimerCountDownForReset();
  //   });
  // }

  ///     Usado em modo Prod
  ///     Substitui a anterior
  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      if (!mounted) return;

      setState(() {
        this.qrCodeResult = CustomParser.decodeFromQueryString(qrCode);
        startTimerCountDownForReset();
      });
    } catch (e) {
      this.qrCodeResult = {};
    }
  }

  Widget onScanButtonClick() {
    return ElevatedButton(
      child: Text(
        'Scan QR code',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        primary: Colors.blue[900],
        onSurface: Colors.grey,
        elevation: 10,
        minimumSize: Size(300, 60),
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      onPressed: scanQRCode,
    );
  }

  Widget onCheckInButtonClick() {
    return ElevatedButton(
      child: Column(
        children: [
          Text(
            'Check-in now',
            style: TextStyle(
                color: Colors.blue, fontSize: 24, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
          Text(
            'Code valid for ${currentSecond.toString()} seconds.',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        primary: Colors.yellow[900],
        onSurface: Colors.grey,
        elevation: 15,
        minimumSize: Size(300, 60),
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
      onPressed: checkIn,
    );
  }

  Widget boxContentForValidQrCode() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        new Container(
            child: new Column(
          children: [
            Image(
              image: AssetImage('assets/images/tapin1.png'),
              // image: AssetImage('assets/images/high5.gif'),
            ),
            new Row(
              children: [
                new Text(
                  'Workplace: ',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                new Text(
                  this.qrCodeResult['workplaceName'],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 20),
                ),
              ],
            ),
            new Row(children: [
              new Text(
                'Tapped in by: ',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              new Text(
                this.qrCodeResult['userName'],
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20),
              ),
            ]),
          ],
        )),
      ],
    );
  }

  Widget boxContentForEmptyQRCode() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(
          image: AssetImage('assets/images/read_qr.gif'),
        ),
        new Container(
            child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Text(
              "Instruções:",
              style: TextStyle(
                color: Colors.red[900],
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
            new Text(
              "Pede a um colega que tenha feito check-in para gerar um QR code no menu TapIn. Depois carrega em Scan QR code e aponta para lá a câmara fotográfica traseira.",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ],
        ))
      ],
    );
  }

  Future checkIn() async {
    // Checked-in succefully

    // Usado em modo Dev
    // this.qrCodeResult = CustomParser.decodeFromQueryString(
    //     "employeeId=7&employeeName=Igor Guedes&workplaceId=2&workplaceName=Obra 2&timestamp=1625013690482");

    bool checkInResult =
        await Timecard.registerCheckInByTapIn(this.qrCodeResult);

    // Callback to change navigation options
    if (checkInResult) widget.changeCheckInToCheckOut();

    MyToast.show(
        checkInResult ? 1 : 3,
        checkInResult
            ? "Check-in com sucesso."
            : "Falha a fazer check-in, tenta novamente mais tarde.");
  }
}
