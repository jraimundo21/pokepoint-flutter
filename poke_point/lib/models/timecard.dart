import 'package:poke_point/models/checkin.dart';
import 'package:poke_point/models/checkout.dart';

class Timecard {
  int id;
  int idEmployee;
  int worktime;
  CheckIn checkIn;
  CheckOut checkOut;

  Timecard(this.id, this.idEmployee, this.worktime);

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
