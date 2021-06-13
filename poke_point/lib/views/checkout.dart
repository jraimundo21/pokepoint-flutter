import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/theme.dart';

class CheckOut extends StatefulWidget {
  CheckOut({Key key, this.changeCheckOutToCheckIn}) : super(key: key);

  final Function() changeCheckOutToCheckIn;

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> with TickerProviderStateMixin {
  void checkOut() {
    // Call method to check-out, api, database, whatever

    widget.changeCheckOutToCheckIn();

    Fluttertoast.showToast(
        msg: "You have checked-out successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 20.0);
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
              height: 150,
              child: new Text(
                'Aqui mostrar info da hora de check-in, lugar, tempo passado desde o check-in',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            Container(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 300,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: Text(
                        'Check Out!',
                        style: TextStyle(color: Colors.white, fontSize: 24),
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