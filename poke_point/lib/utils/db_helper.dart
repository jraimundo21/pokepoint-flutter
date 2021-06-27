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
            'CREATE TABLE timecard(id INTEGER PRIMARY KEY, idEmployee INTEGER, worktime INTEGER, FOREIGN KEY(idEmployee) REFERENCES employee(id))');
        database.execute(
            'CREATE TABLE checkin(id INTEGER PRIMARY KEY, idCheckintype idWorkplace INTEGER, idTimecard INTEGER, timestamp TEXT, FOREIGN KEY(idTimecard) REFERENCES company(id))');
        database.execute(
            'CREATE TABLE checkout(id INTEGER PRIMARY KEY, idWorkplace INTEGER, idTimecard INTEGER, timestamp TEXT, FOREIGN KEY(idTimecard) REFERENCES company(id))');
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

  Future<dynamic> getCurrent() async {
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM current LIMIT 1');
    if (result.isEmpty) return null;
    dynamic current = result[0]['idUser'];
    return current;
  }

  Future<void> cacheData() async {
    var employeeData = await HttpHelper.getEmployee();
    employeeData['idCompany'] = employeeData['worksAtCompany'];
    Employee employee = new Employee.fromJson(employeeData);
    await insertEmployee(employee);
    for (var i = 0; i < employeeData['timeCards'].length; i++) {
      var jsonTimecard = employeeData['timeCards'][i];
      Timecard timecard = new Timecard.fromJson(jsonTimecard);
      await insertTimecard(timecard);
    }

    var d = await getTimecards(employee.id);
    var e = await getCompany(employee.idCompany);
    var a = 9;
  }

  Future<List<Workplace>> getWorkplaces(idCompany) async {
    final List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM workplace WHERE idEmployee=?', [idCompany]);
    List<Workplace> workplaces = List.generate(result.length, (i) {
      return new Workplace(
        result[i]['id'],
        result[i]['idCompany'],
        result[i]['address'],
        result[i]['latitude'],
        result[i]['longitude'],
        result[i]['name'],
      );
    });
    return workplaces;
  }

  Future<int> insertWorkplace(Workplace workplace) async {
    int id = await this.db.insert(
          'workplace',
          workplace.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<Company> getCompany(idCompany) async {
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM company WHERE id=?', [idCompany]);
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

  Future<List<Timecard>> getTimecards(idEmployee) async {
    final List<Map<String, dynamic>> result = await db
        .rawQuery('SELECT * FROM timecard WHERE idEmployee=?', [idEmployee]);
    List<Timecard> timecards = List.generate(result.length, (i) {
      return new Timecard(
        result[i]['id'],
        result[i]['idEmployee'],
        result[i]['worktime'],
      );
    });
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

  Future<Employee> getEmployee(id) async {
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM employee WHERE id=? LIMIT 1', [id]);
    Employee employee = Employee(
      result[0]['idCompany'],
      result[0]['username'],
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
    var current = await getCurrent();
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
