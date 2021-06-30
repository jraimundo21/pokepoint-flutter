import 'package:flutter/material.dart';
import 'package:poke_point/models/timecard.dart';
import 'package:poke_point/models/employee.dart';
import '../utils/toaster.dart';

class CheckOut extends StatefulWidget {
  CheckOut({Key key, this.changeCheckOutToCheckIn, this.changeBackToTimeTable})
      : super(key: key);

  final Function() changeCheckOutToCheckIn;
  final Function() changeBackToTimeTable;

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> with TickerProviderStateMixin {
  bool isCheckOutPressed = false;

  @override
  void initState() {
    super.initState();
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
              ? "You have checked-out successfully"
              : 'Failed to check-out, try again later');

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
              height: MediaQuery.of(context).size.height * 0.15, //150 ?
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
