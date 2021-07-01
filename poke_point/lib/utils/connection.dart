import 'package:connectivity/connectivity.dart';
import 'package:poke_point/models/timecard.dart';
import '../utils/db_helper.dart';
import '../utils/http_helper.dart';

class Connection {
  static Future<bool> isOnline() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult != ConnectivityResult.none);
  }

  static Future<void> synchronize() async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();

    List<Timecard> timecards = await dbHelper.getTimecards();
    // Filter timecards leaving only the ones with timecard, checkin or checkout offline == true
    timecards.forEach((timecard) async {
      // Sync check ins
      if (timecard.checkIn != null && timecard.checkIn.offline) {
        var checkin = await HttpHelper.post(
            'employees/${timecard.idEmployee}/checkins/', {
          "workplace": timecard.checkIn.idWorkplace,
          "checkInType": timecard.checkIn.idCheckInType,
          "timestamp": timecard.checkIn.timestamp
        });
        if (checkin != null) {
          await dbHelper.updateTableWhereId('checkin', timecard.checkIn.id, {
            'id': checkin['id'],
            'idTimecard': checkin['timeCard'],
            'offline': 0
          });
          await dbHelper.updateTableWhereId('timecard', timecard.id,
              {'id': checkin['timeCard'], 'offline': 0});
          timecard.checkIn.id = checkin['id'];
          timecard.checkIn.idTimecard = checkin['timeCard'];
          timecard.id = checkin['timeCard'];
        }
      }
      // Sync check outs
      if (timecard.checkOut != null && timecard.checkOut.offline) {
        var checkout = await HttpHelper.post(
            'employees/${timecard.idEmployee}/checkouts/', {
          "workplace": timecard.checkOut.idWorkplace,
          "timestamp": timecard.checkOut.timestamp
        });
        await dbHelper.updateTableWhereId('checkout', timecard.checkOut.id, {
          'id': checkout['id'],
          'idTimecard': timecard.checkIn.idTimecard,
          'offline': 0
        });
        timecard.checkOut.id = checkout['id'];
      }
    });
  }
}
