import 'package:flutter/material.dart';
import '../utils/db_helper.dart';
import '../models/employee.dart';
import '../models/timecard.dart';
import '../models/company.dart';
import '../models/workplace.dart';

class TimeTable extends StatefulWidget {
  TimeTable({Key key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  List<Workplace> workplaces;
  List<Timecard> timecards;
  Company company;
  Employee employee;

  void loadDataFromDb() async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();

    workplaces = await dbHelper.getWorkplaces();
    timecards = await dbHelper.getTimecards();
    company = await dbHelper.getCompany();
    employee = await dbHelper.getEmployee();

    setState(() {
      // just waiting for data to load
    });
  }

  @override
  void initState() {
    super.initState();
    loadDataFromDb();
  }

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
                child: new Column(
                  children: [
                    Text(
                      'Timetable',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    Text(
                      'Exemplo usar Employee: ${this.employee == null ? '' : this.employee.name}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      'Exemplo usar Company: ${this.company == null ? '' : this.company.name}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )
                  ],
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
