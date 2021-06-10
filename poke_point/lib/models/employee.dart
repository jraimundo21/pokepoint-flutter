import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Employee {
  int id;
  String name;
  String nif;
  String address;
  String email;
  String phone;

  Employee(this.id, this.name, this.nif, this.address, this.email, this.phone);

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(json['id'], json['name'], json['nif'], json['address'],
        json['email'], json['phone']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nif': nif,
      'address': address,
      'email': email,
      'phone': phone
    };
  }

  static Future<Employee> getEmployee(id) async {
    final response = await http.get(
        Uri.https('jsonplaceholder.typicode.com', 'employees/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      // Using array assuming the service returns a list, may need to adapt
      dynamic employeeResult = jsonDecode(response.body);
      return Employee.fromJson(employeeResult);
    } else {
      throw Exception('Failed to get Employee.');
    }
  }
}
