import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  String username;
  String password;

  User(this.username, this.password);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['username'], json['password']);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}
