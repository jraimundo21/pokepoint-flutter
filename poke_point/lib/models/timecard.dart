import 'package:poke_point/models/checkin.dart';
import 'package:poke_point/models/checkout.dart';

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
    return Timecard(json['id'], json['employee'], json['time_work']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'idEmployee': idEmployee, 'worktime': worktime};
  }

  void setCheckIn(CheckIn checkIn) {
    this.checkIn = checkIn;
  }

  void setCheckOut(CheckOut checkOut) {
    this.checkOut = checkOut;
  }
}
