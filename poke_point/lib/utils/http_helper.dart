import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'db_helper.dart';

class HttpHelper {
  static final String baseUrl = 'http://167.233.9.184:81/pokepoint/api/';

  static getEmployee() async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();
    var user = await dbHelper.getUser();

    final response = await http.get(
      Uri.parse(baseUrl + 'employees/' + user.id.toString() + '/'),
      headers: {
        HttpHeaders.authorizationHeader: user.basicAuth,
      },
    );
    return json.decode(response.body);
  }

  static getCompany(id) async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();
    var user = await dbHelper.getUser();

    final response = await http.get(
      Uri.parse(baseUrl + 'companies/' + id.toString() + '/'),
      headers: {
        HttpHeaders.authorizationHeader: user.basicAuth,
      },
    );
    return json.decode(response.body);
  }

  static getWorkplaces(idCompany) async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();
    var user = await dbHelper.getUser();

    final response = await http.get(
      Uri.parse(baseUrl + 'companies/' + idCompany.toString() + '/workplaces/'),
      headers: {
        HttpHeaders.authorizationHeader: user.basicAuth,
      },
    );
    return json.decode(response.body);
  }

  static get(resource) async {
    DbHelper dbHelper = new DbHelper();
    await dbHelper.openDb();
    var user = await dbHelper.getUser();

    final response = await http.get(
      Uri.parse(baseUrl + resource),
      headers: {
        HttpHeaders.authorizationHeader: user.basicAuth,
      },
    );
    return response;
  }
}
