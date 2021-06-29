import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    if (mounted) setState(() {});
  }

  Workplace getWorkplaceFromId(int id) {
    for (var workplace in workplaces) {
      if (workplace.id == id) {
        return workplace;
      }
    }
    return null;
  }

  int getTotalTime() {
    var total = 0;
    for (var timecard in timecards) {
      total += timecard.worktime;
    }
    return total;
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
                      'Empregado: ${this.employee == null ? '' : this.employee.name}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      'Empresa: ${this.company == null ? '' : this.company.name}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )
                  ],
                )),
            Container(
                height: MediaQuery.of(context).size.height * 0.67, //150 ?,
                child: new DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Local',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.black),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Check In',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.black),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Checked Out',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.black),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    if (timecards != null)
                      for (var timecard in timecards)
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text(
                                '${timecard.checkIn != null ? getWorkplaceFromId(timecard.checkIn.idWorkplace).name : ''}',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black))),
                            DataCell(Text(
                                '${timecard.checkIn != null ? DateFormat('dd-MM-yy/HH:mm').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(timecard.checkIn.timestamp, true)) : ''}',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black))),
                            DataCell(Text(
                                '${timecard.checkIn != null ? DateFormat('dd-MM-yy/HH:mm').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(timecard.checkOut.timestamp, true)) : ''}',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black))),
                          ],
                        ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
