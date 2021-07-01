import '../utils/db_helper.dart';
import './timecard.dart';

class Employee {
  int id;
  int idCompany;
  String name;
  String nif;
  String address;
  String email;
  String phone;

  Employee(this.id, this.idCompany, this.name, this.nif, this.address,
      this.email, this.phone);

  factory Employee.fromJson(Map<String, dynamic> json) {
    return json == null
        ? json
        : Employee(json['id'], json['idCompany'], json['name'], json['nif'],
            json['address'], json['email'], json['phone']);
  }

  static Future<Employee> getEmployee() async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();
    // dbHelper.cacheData();
    return dbHelper.getEmployee();
  }

  static Future<bool> isCheckedIn() async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();

    List<Timecard> timecards = await dbHelper.getTimecards();
    if (timecards.isEmpty) return false;

    Timecard lastTimecard = timecards.last;
    return lastTimecard.checkOut == null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCompany': idCompany,
      'name': name,
      'nif': nif,
      'address': address,
      'email': email,
      'phone': phone
    };
  }
}
