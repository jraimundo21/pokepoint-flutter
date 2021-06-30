import '../models/checkin.dart';
import '../models/checkout.dart';
import '../utils/db_helper.dart';
import '../utils/http_helper.dart';
import '../utils/connection.dart';

class Timecard {
  int id;
  int idEmployee;
  int worktime;
  CheckIn checkIn;
  CheckOut checkOut;
  bool offline;

  Timecard(int id, int idEmployee, int worktime, [int offline = 0]) {
    this.id = id;
    this.idEmployee = idEmployee;
    this.worktime = worktime;
    this.offline = offline == 0 ? false : true;
  }

  factory Timecard.fromJson(Map<String, dynamic> json) {
    return json == null
        ? json
        : Timecard(json['id'], json['employee'], json['time_work']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idEmployee': idEmployee,
      'worktime': worktime,
      'offline': offline ? 1 : 0
    };
  }

  void setCheckIn(CheckIn checkIn) {
    this.checkIn = checkIn;
  }

  void setCheckOut(CheckOut checkOut) {
    this.checkOut = checkOut;
  }

  static registerCheckOut() async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();

    int employeeId = await dbHelper.getCurrentEmployeeId();
    CheckIn checkIn = await dbHelper.getLastCheckIn();

    if (await Connection.isOnline()) {
      var checkout = await HttpHelper.post('employees/$employeeId/checkouts/', {
        "workplace": checkIn.idWorkplace,
        "timestamp": new DateTime.now().toIso8601String()
      });

      await dbHelper.cacheData();
      return checkout != null;
    } else {
      Timecard timecard = await dbHelper.getTimecard(checkIn.idTimecard);
      int smallestCheckOutId = await dbHelper.getSmallestCheckOutId();

      CheckOut checkOut = new CheckOut(
          smallestCheckOutId > 0 ? -1 : smallestCheckOutId - 1,
          checkIn.idWorkplace,
          timecard.id,
          ('${new DateTime.now().toIso8601String()}Z'),
          1);

      dbHelper.insertCheckOut(checkOut);
      return checkOut != null;
    }
  }

  static Future<bool> registerCheckInOnline(int idWorkplace) async {
    // Registar este check in
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();

    int employeeId = await dbHelper.getCurrentEmployeeId();

    var checkin = await HttpHelper.post('employees/$employeeId/checkins/', {
      "workplace": idWorkplace,
      "checkInType": 3,
      "timestamp": new DateTime.now().toIso8601String()
    });

    await dbHelper.cacheData();

    return checkin != null;
  }

  static registerCheckInByTapIn(Map colleagueInfo) async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();

    int smallestCheckInId = await dbHelper.getSmallestCheckInId();
    int smallestTimecardId = await dbHelper.getSmallestTimecardId();
    int idEmployee = await dbHelper.getCurrentEmployeeId();

    Timecard timecard = new Timecard(
        smallestTimecardId > 0 ? -1 : smallestTimecardId - 1, idEmployee, 0, 1);

    CheckIn checkIn = new CheckIn(
        smallestCheckInId > 0 ? -1 : smallestCheckInId - 1,
        int.parse(colleagueInfo['workplaceId']),
        2,
        timecard.id,
        ('${new DateTime.now().toIso8601String()}Z'),
        1);

    dbHelper.insertTimecard(timecard);
    dbHelper.insertCheckIn(checkIn);
  }
}
