import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: new Text('Drawer Menu'),
                decoration: BoxDecoration(color: Colors.yellow)),
            ListTile(
              title: new Text('Home'),
              onTap: () => {}, //0 é o índice da view que se pretende selecionar
            ),
            ListTile(
              title: new Text('TabBar'),
              onTap: () => {}, //1 é o índice da view que se pretende selecionar
            ),
            ListTile(
              title: new Text('ListView'),
              onTap: () => {}, //0 é o índice da view que se pretende selecionar
            ),
          ],
        ),
      ),
    );
  }
}
