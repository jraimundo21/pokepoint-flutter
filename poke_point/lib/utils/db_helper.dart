import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/employee.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  final int version = 1;
  Database db;

  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'pokepoint.db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE employee(id INTEGER PRIMARY KEY, name TEXT, nif TEXT, address TEXT, email TEXT, phone TEXT)');
      }, version: version);
    }
    return db;
  }

  Future<Employee> getEmployee(id) async {
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT TOP 1 * FROM employee WHERE id=?', [id]);
    Employee employee = Employee(
      result[0]['id'],
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
}
