import 'package:flutter/material.dart';
import './utils/theme.dart';
import './views/time_table.dart';
import './views/checkin.dart';
import './views/tapin.dart';
import './views/settings.dart';

class BaseView extends StatefulWidget {
  BaseView({Key key}) : super(key: key);

  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int selectedIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[TimeTable(), CheckIn(), TapIn()],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void changeView(int index) {
    setState(() {
      selectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
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
        drawer: Settings(),
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          backgroundColor: PrimaryColor,
          selectedItemColor: SecondaryColorLight,
          unselectedItemColor: TextColor,
          onTap: (index) {
            changeView(index);
          },
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.timer), label: 'Horas'),
            BottomNavigationBarItem(
                icon: new Icon(Icons.adjust_outlined), label: 'Check-in'),
            BottomNavigationBarItem(
                icon: new Icon(Icons.person_add), label: 'Tap-in')
          ],
        ),
      ),
    );
  }
}
