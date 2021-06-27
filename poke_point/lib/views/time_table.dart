import 'package:flutter/material.dart';
import '../utils/theme.dart';

class TimeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
                color: Color(0xFF11443c), //Colors.amber[600],
                height: MediaQuery.of(context).size.height * 0.15, //150 ?,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Timetable',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                )),
            Container(
              height: MediaQuery.of(context).size.height * 0.67, //150 ?,
              child: Text(
                'Timetable',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            )
          ],
        ),
      ),
    );
  }
}
