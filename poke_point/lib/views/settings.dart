import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../views/login.dart';
import '../utils/http_helper.dart';
import '../utils/db_helper.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Drawer(
        child: ListView(
          children: <Widget>[
            new Container(
                child: DrawerHeader(
                    child: new Text(
                      'Settings',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    decoration: BoxDecoration(color: PrimaryColorDark))),
            new Container(
              child: ListTile(
                title: new Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                onTap: () => {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ))
                }, //0 é o índice da view que se pretende selecionar
              ),
            ),
            new Container(
              child: ListTile(
                title: new Text(
                  'Botão para testar coisas',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                onTap: () async {
                  // var a = await HttpHelper.getEmployee();
                  DbHelper dbHelper = new DbHelper();
                  var c = dbHelper.cacheData();
                  var b = 2;
                }, //0 é o índice da view que se pretende selecionar
              ),
            ),
          ],
        ),
      ),
    );
  }
}
