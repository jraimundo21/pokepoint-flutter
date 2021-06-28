import 'package:path/path.dart';
import 'package:poke_point/utils/http_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../models/employee.dart';
import '../models/timecard.dart';
import '../models/company.dart';
import '../models/workplace.dart';
import '../models/checkin.dart';
import '../models/checkout.dart';
import '../models/user.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  final int version = 1;
  Database db;

  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    // deleteDatabase(join(await getDatabasesPath(), 'pokepoint.db'));
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'pokepoint.db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE current(singularity INTEGER unique, idUser INTEGER UNIQUE)');
        database.execute(
            'CREATE TABLE user(id INTEGER PRIMARY KEY, username TEXT UNIQUE, basicAuth TEXT)');
        database.execute(
            'CREATE TABLE company(id INTEGER PRIMARY KEY, name TEXT, nif TEXT, address TEXT, email TEXT, phone TEXT)');
        database.execute(
            'CREATE TABLE employee(id INTEGER PRIMARY KEY, idCompany INTEGER, name TEXT, nif TEXT, address TEXT, email TEXT, phone TEXT, FOREIGN KEY(idCompany) REFERENCES company(id))');
        database.execute(
            'CREATE TABLE workplace(id INTEGER PRIMARY KEY, idCompany INTEGER, name TEXT, latitude REAL, longitude REAL, address TEXT, FOREIGN KEY(idCompany) REFERENCES company(id))');
        database.execute(
            'CREATE TABLE timecard(id INTEGER PRIMARY KEY, idEmployee INTEGER, worktime INTEGER, offline INTEGER DEFAULT 0, FOREIGN KEY(idEmployee) REFERENCES employee(id))');
        database.execute(
            'CREATE TABLE checkin(id INTEGER PRIMARY KEY, idCheckintype INTEGER, idWorkplace INTEGER, idTimecard INTEGER, timestamp TEXT, offline INTEGER DEFAULT 0, FOREIGN KEY(idTimecard) REFERENCES company(id))');
        database.execute(
            'CREATE TABLE checkout(id INTEGER PRIMARY KEY, idWorkplace INTEGER, idTimecard INTEGER, timestamp TEXT, offline INTEGER DEFAULT 0, FOREIGN KEY(idTimecard) REFERENCES company(id))');
      }, version: version);
    }
    return db;
  }

  Future<void> updateCurrent(idUser) async {
    await this.db.insert(
          'current',
          {"singularity": 1, "idUser": idUser},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
  }

  Future<int> getCurrentEmployeeId() async {
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM current LIMIT 1');
    if (result.isEmpty) return null;
    dynamic current = result[0]['idUser'];
    return current;
  }

  Future<int> getCurrentEmployeeCompanyId() async {
    final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT e.idCompany FROM current c JOIN employee e ON c.idUser = e.id LIMIT 1');
    if (result.isEmpty) return null;
    dynamic currentEmployeeId = result[0]['idCompany'];
    return currentEmployeeId;
  }

  Future<void> cacheTimecards(List<dynamic> timecardsData) async {
    for (var i = 0; i < timecardsData.length; i++) {
      var jsonTimecard = timecardsData[i];
      Timecard timecard = new Timecard.fromJson(jsonTimecard);
      await insertTimecard(timecard);
      if (jsonTimecard["checkIn"] != null) {
        var jsonCheckIn = jsonTimecard['checkIn'];
        CheckIn checkIn = new CheckIn(
            jsonCheckIn["id"],
            jsonCheckIn["workplace"],
            jsonCheckIn["checkInType"],
            jsonCheckIn["timeCard"],
            jsonCheckIn["timestamp"]);
        insertCheckIn(checkIn);
      }
      if (jsonTimecard["checkOut"] != null) {
        var jsonCheckOut = jsonTimecard['checkOut'];
        CheckOut checkOut = new CheckOut(
            jsonCheckOut["id"],
            jsonCheckOut["workplace"],
            jsonCheckOut["timeCard"],
            jsonCheckOut["timestamp"]);
        insertCheckOut(checkOut);
      }
    }
  }

  Future<void> cacheData() async {
    var employeeData = await HttpHelper.getEmployee();
    employeeData['idCompany'] = employeeData['worksAtCompany'];
    Employee employee = new Employee.fromJson(employeeData);
    await insertEmployee(employee);
    var companyData = await HttpHelper.getCompany(employee.idCompany);
    Company company = new Company.fromJson(companyData);
    insertCompany(company);
    var workplacesData = await HttpHelper.getWorkplaces(employee.idCompany);
    // Cache workplaces
    for (var i = 0; i < workplacesData.length; i++) {
      workplacesData[i]['idCompany'] = workplacesData[i]['company_id'];
      Workplace workplace =
          new Workplace.fromJsonStringCoords(workplacesData[i]);
      await insertWorkplace(workplace);
    }
    await cacheTimecards(employeeData['timeCards']);
  }

  getLastCheckIn() async {
    List<Timecard> timecards = await getTimecards();
    CheckIn lastCheckIn = timecards[0].checkIn;
    timecards.forEach((timecard) {
      if (timecard.checkIn != null && timecard.checkIn.timestamp != null) {
        if (timecard.checkIn.timestamp.compareTo(lastCheckIn.timestamp) > 0)
          lastCheckIn = timecard.checkIn;
      }
    });
    return lastCheckIn;
  }

  Future<int> getSmallestCheckInId() async {
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT id FROM checkin order by id ASC LIMIT 1');
    if (result.isEmpty) return null;
    return result[0]['id'];
  }

  Future<int> getSmallestCheckOutId() async {
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT id FROM checkout order by id ASC LIMIT 1');
    if (result.isEmpty) return null;
    return result[0]['id'];
  }

  Future<int> getSmallestTimecardId() async {
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT id FROM timecard order by id ASC LIMIT 1');
    if (result.isEmpty) return null;
    return result[0]['id'];
  }

  Future<CheckIn> getCheckIn(int idTimecard, [bool last = false]) async {
    final List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM checkin WHERE idTimecard=?', [idTimecard]);
    if (result.isEmpty) return null;
    CheckIn checkIn = new CheckIn(
      result[0]['id'],
      result[0]['idWorkplace'],
      result[0]['idCheckintype'],
      result[0]['idTimecard'],
      result[0]['timestamp'],
      result[0]['offline'],
    );
    return checkIn;
  }

  Future<int> insertCheckIn(CheckIn checkIn) async {
    int id = await this.db.insert(
          'checkIn',
          checkIn.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<CheckOut> getCheckOut(idTimecard) async {
    final List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM checkout WHERE idTimecard=?', [idTimecard]);
    if (result.isEmpty) return null;
    CheckOut checkOut = new CheckOut(
      result[0]['id'],
      result[0]['idWorkplace'],
      result[0]['idTimecard'],
      result[0]['timestamp'],
      result[0]['offline'],
    );
    return checkOut;
  }

  Future<int> insertCheckOut(CheckOut checkOut) async {
    int id = await this.db.insert(
          'checkOut',
          checkOut.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<List<Workplace>> getWorkplaces() async {
    final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT w.id, w.idCompany, w.name, w.address, w.latitude, w.longitude FROM workplace w JOIN employee e ON e.idCompany = w.idCompany JOIN current c ON c.idUser = e.id');
    List<Workplace> workplaces = List.generate(result.length, (i) {
      return new Workplace(
        result[i]['id'],
        result[i]['idCompany'],
        result[i]['name'],
        result[i]['address'],
        result[i]['latitude'],
        result[i]['longitude'],
      );
    });
    return workplaces;
  }

  Future<Workplace> getWorkplace(int idWorkplace) async {
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM workplace WHERE id=?', [idWorkplace]);
    if (result.isEmpty) return null;
    Workplace workplace = new Workplace(
      result[0]['id'],
      result[0]['idCompany'],
      result[0]['name'],
      result[0]['address'],
      result[0]['latitude'],
      result[0]['longitude'],
    );
    return workplace;
  }

  Future<int> insertWorkplace(Workplace workplace) async {
    int id = await this.db.insert(
          'workplace',
          workplace.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<Company> getCompany() async {
    final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT c.id, c.name, c.nif, c.address, c.email, c.phone FROM company c JOIN employee e ON e.idCompany = c.id JOIN current curr ON e.id = curr.idUser');
    if (result.isEmpty) return null;
    Company company = new Company(
        result[0]['id'],
        result[0]['name'],
        result[0]['nif'],
        result[0]['address'],
        result[0]['email'],
        result[0]['phone']);
    return company;
  }

  Future<int> insertCompany(Company company) async {
    int id = await this.db.insert(
          'company',
          company.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<List<Timecard>> getTimecards() async {
    final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT tc.id, tc.idEmployee, tc.worktime, tc.offline FROM timecard tc JOIN current c ON tc.idEmployee = c.idUser');
    List<Timecard> timecards = List.generate(result.length, (i) {
      return new Timecard(
        result[i]['id'],
        result[i]['idEmployee'],
        result[i]['worktime'],
        result[i]['offline'],
      );
    });
    for (var i = 0; i < timecards.length; i++) {
      var checkIn = await getCheckIn(timecards[i].id);
      timecards[i].setCheckIn(checkIn);
      var checkOut = await getCheckOut(timecards[i].id);
      timecards[i].setCheckOut(checkOut);
    }
    return timecards;
  }

  Future<int> insertTimecard(Timecard timecard) async {
    int id = await this.db.insert(
          'timecard',
          timecard.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<Employee> getEmployee() async {
    final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT e.id, e.idCompany, e.name, e.nif, e.address, e.email, e.phone FROM employee e JOIN current c on e.id = c.idUser');
    Employee employee = Employee(
      result[0]['id'],
      result[0]['idCompany'],
      result[0]['name'],
      result[0]['nif'],
      result[0]['address'],
      result[0]['email'],
      result[0]['phone'],
    );
    return employee;
  }

  Future<int> insertEmployee(Employee employee) async {
    int id = await this.db.insert(
          'employee',
          employee.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<User> getUserByUsername(username) async {
    final List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM user WHERE username=? LIMIT 1', [username]);
    if (result.isEmpty) return null;
    User user =
        User(result[0]['id'], result[0]['username'], result[0]['basicAuth']);
    return user;
  }

  Future<User> getUser() async {
    var current = await getCurrentEmployeeId();
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM user WHERE id=? LIMIT 1', [current]);
    if (result.isEmpty) return null;
    User user =
        User(result[0]['id'], result[0]['username'], result[0]['basicAuth']);
    return user;
  }

  Future<int> insertUser(User user) async {
    int id = await this.db.insert(
          'user',
          user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }
}
