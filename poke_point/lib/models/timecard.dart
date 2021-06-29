import '../models/checkin.dart';
import '../models/checkout.dart';
import '../utils/db_helper.dart';
import '../utils/http_helper.dart';

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

  static registerCheckIn() {}

  static registerOffline() {}

  static registerOnline(int idWorkplace) async {
// Registar este check in
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();

    int employeeId = await dbHelper.getCurrentEmployeeId();

    Timecard timecard = Timecard.fromJson(await HttpHelper.post(
        'employees/$employeeId/timecards/', {"employee": employeeId}));

    CheckIn checkIn = CheckIn.fromJson(
        await HttpHelper.post('employees/$employeeId/checkins/', {
      "workplace": idWorkplace,
      "checkInType": 3,
      "timeCard": timecard.id,
      "timestamp": "2021-06-26T22:10:19Z"
    }));

    timecard.setCheckIn(checkIn);
    dbHelper.insertTimecard(timecard);

    var a = 9;

========================================
========================================
========================================
========================================

    continuar AQUI 
    post checkin nao estava a afuncionar. Ver com a edna

  }

  static registerByTapIn(Map colleagueInfo) async {
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
