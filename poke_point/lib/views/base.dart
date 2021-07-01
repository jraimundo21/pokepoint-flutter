import 'package:flutter/material.dart';
import '../utils/theme.dart';
import './time_table.dart';
import './checkin.dart';
import './checkout.dart';
import './tapin.dart';
import '../views/login.dart';
import '../utils/db_helper.dart';
import '../models/employee.dart';

class BaseView extends StatefulWidget {
  BaseView({Key key}) : super(key: key);

  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int selectedIndex = 0;
  bool iAmCheckedIn = false;

  void checkCheckInStatus() async {
    iAmCheckedIn = await Employee.isCheckedIn();
  }

  @override
  void initState() {
    super.initState();
    checkCheckInStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'poke-point',
      theme: MyTheme.myCustom,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        drawer: new Drawer(
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
                  decoration: BoxDecoration(color: PrimaryColorDark),
                ),
              ),
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
                    'Sincronizar dados',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  onTap: () async {
                    if (mounted)
                      setState(() {
                        DbHelper dbHelper = new DbHelper();
                        dbHelper.cacheData();
                      });
                  }, //0 é o índice da view que se pretende selecionar
                ),
              )
            ],
          ),
        ),
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            backgroundColor: PrimaryColor,
            selectedItemColor: SecondaryColorLight,
            unselectedItemColor: TextColor,
            onTap: (index) {
              _changeView(index);
            },
            items: !iAmCheckedIn
                ? this.checkedOutNavOptions
                : this.checkedInNavOptions),
      ),
    );
  }

  void _pageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _changeView(int index) {
    setState(() {
      selectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void changeCheckInToCheckOut() {
    _changeView(0); // 0 is the first position: 'TimeTable'
    setState(() {
      iAmCheckedIn = true;
    });
  }

  void changeCheckOutToCheckIn() {
    _changeView(0); // 0 is the second position: 'TimeTable'
    setState(() {
      iAmCheckedIn = false;
    });
  }

  void changeBackToTimeTable() {
    _changeView(0); // 0 is the second position: 'TimeTable'
  }

  void logout(_context) {
    Navigator.pop(_context);
  }

  List<BottomNavigationBarItem> checkedOutNavOptions = [
    BottomNavigationBarItem(icon: new Icon(Icons.timer), label: 'Horas'),
    BottomNavigationBarItem(
        icon: new Icon(Icons.adjust_outlined), label: 'Check-in'),
  ];

  List<BottomNavigationBarItem> checkedInNavOptions = [
    BottomNavigationBarItem(icon: new Icon(Icons.timer), label: 'Horas'),
    BottomNavigationBarItem(icon: new Icon(Icons.person_add), label: 'Tap-in'),
    BottomNavigationBarItem(
        icon: new Icon(Icons.adjust_outlined), label: 'Check-out'),
  ];

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    List<Widget> views = [
      TimeTable(changeCheckInToCheckOut: this.changeCheckInToCheckOut),
      !iAmCheckedIn
          ? CheckIn(
              changeCheckInToCheckOut: this.changeCheckInToCheckOut,
              changeBackToTimeTable: this.changeBackToTimeTable)
          : TapIn(),
      CheckOut(
          changeCheckOutToCheckIn: this.changeCheckOutToCheckIn,
          changeBackToTimeTable: this.changeBackToTimeTable)
    ];

    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        _pageChanged(index);
      },
      children: views,
    );
  }
}
