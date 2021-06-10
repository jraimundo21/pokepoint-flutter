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
              height: 150,
            ),
            Container(
              child: new Text(
                'Timetable',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),
            )
          ],
        ),
      ),
    );
  }
}
