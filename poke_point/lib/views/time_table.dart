import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import '../utils/db_helper.dart';
import '../models/employee.dart';
import '../models/timecard.dart';
import '../models/company.dart';
import '../models/workplace.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import '../utils/connection.dart';

class TimeTable extends StatefulWidget {
  TimeTable({Key key, this.changeCheckInToCheckOut}) : super(key: key);

  final Function() changeCheckInToCheckOut;

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool hasLoaded = false;
  List<Workplace> workplaces;
  List<Timecard> timecards;
  Company company;
  Employee employee;

  void checkCheckInStatus() async {
    if (await Employee.isCheckedIn()) widget.changeCheckInToCheckOut();
  }

  void loadDataFromDb() async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();

    workplaces = await dbHelper.getWorkplaces();
    timecards = await dbHelper.getTimecards();
    company = await dbHelper.getCompany();
    employee = await dbHelper.getEmployee();

    if (mounted)
      setState(() {
        hasLoaded = true;
      });
  }

  @override
  void initState() {
    super.initState();
    checkCheckInStatus();
    loadDataFromDb();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    setState(() {});
  }

  @override
  void dispose() {
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
                    ),
                    Text(
                      'Horas Registadas: ${getTotalTime()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )
                  ],
                )),
            Container(
                height: MediaQuery.of(context).size.height * 0.67, //150 ?,
                child: !this.hasLoaded
                    ? Image(
                        image: AssetImage('assets/images/loading2.gif'),
                      )
                    : new DataTable2(
                        columnSpacing: 8,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Local',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Check In',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Checked Out',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black),
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
                                  DataCell(Badge(
                                      showBadge: timecard.checkIn.offline,
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(8),
                                      shape: BadgeShape.circle,
                                      position: BadgePosition.topStart(),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      badgeContent: Text(''),
                                      child: Text(
                                          '${timecard.checkIn != null ? DateFormat('dd-MM-yy/HH:mm').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(timecard.checkIn?.timestamp, true)) : ''}',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black)))),
                                  DataCell(Badge(
                                      showBadge: timecard.checkIn.offline,
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(8),
                                      shape: BadgeShape.circle,
                                      position: BadgePosition.topStart(),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      badgeContent: Text(''),
                                      child: Text(
                                          '${timecard.checkOut != null ? DateFormat('dd-MM-yy/HH:mm').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(timecard.checkOut?.timestamp, true)) : ''}',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black)))),
                                ],
                              ),
                        ],
                      ))
          ],
        ),
      ),
    );
  }

  Workplace getWorkplaceFromId(int id) {
    for (var workplace in workplaces) {
      if (workplace.id == id) {
        return workplace;
      }
    }
    return null;
  }

  String getTotalTime() {
    var total = 0;
    if (timecards != null) {
      for (var timecard in timecards) {
        total += timecard.worktime;
      }
    }
    // total is in ms
    var duration = Duration(milliseconds: total);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
