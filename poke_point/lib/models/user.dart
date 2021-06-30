import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/http_helper.dart';
import '../utils/db_helper.dart';
import '../utils/connection.dart';

class User {
  int id;
  String username;
  String basicAuth;

  User(this.id, this.username, this.basicAuth);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['id'], json['username'], json['basicAuth']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'basicAuth': basicAuth,
    };
  }

  static Future<dynamic> _offlinelogin(
      String username, String basicAuth) async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();
    var user = await dbHelper.getUserByUsername(username);
    if (user == null)
      return 'You need internet connection for your first login.';
    if (user.basicAuth == basicAuth && user.username == username)
      return null; //is ok
    else
      return 'Please check your password or username.';
  }

  static Future<dynamic> login(String username, String password) async {
    // Code the password to a basicAuth token
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    // return _offlinelogin(username, basicAuth);
    if (!(await Connection.isOnline()))
      return _offlinelogin(username, basicAuth);
    try {
      var response = await http.post(Uri.parse(HttpHelper.baseUrl + 'login/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"username": username, "password": password}));
      if (response.statusCode == 200) {
        DbHelper dbHelper = new DbHelper();
        await dbHelper.openDb();
        User user = new User(int.parse(response.body), username, basicAuth);
        await dbHelper.insertUser(user);
        await dbHelper.updateCurrent(user.id);
        await dbHelper.cacheData();
        return null;
      } else if (response.statusCode == 500) {
        return _offlinelogin(username, basicAuth);
      } else {
        return 'Please check your username and password.';
      }
    } on TimeoutException catch (e) {
      return _offlinelogin(username, basicAuth);
    } on SocketException catch (e) {
      return _offlinelogin(username, basicAuth);
    } on Error catch (e) {
      return ('Unexpected error. Please restart your app.');
    }
  }
}
