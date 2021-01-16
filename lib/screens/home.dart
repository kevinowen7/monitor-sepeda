import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/db/firebase-db.dart';
import 'package:flutter_task_planner_app/loading/loading.dart';
import 'package:flutter_task_planner_app/screens/akun.dart';
import 'package:flutter_task_planner_app/screens/calendar_page.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:flutter_task_planner_app/screens/login.dart';
import 'package:flutter_task_planner_app/screens/map_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    CalendarPage(),
    MapPage(),
    Akun()
  ];

  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Tap 2 kali untuk keluar");
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod(
        'SystemNavigator.pop');
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
        onWillPop: onWillPop,
          child:Scaffold(
          body: _children[_currentIndex], // new
          backgroundColor: LightColors.kLightGreen,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTabTapped, // new
            currentIndex: _currentIndex, // new
            unselectedItemColor: LightColors.kDarkBlue,
            backgroundColor: LightColors.kLightGreen,
            selectedItemColor: LightColors.kLightBlue,
            items: [
              new BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text('Kalendar'),
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  title: Text('Map')
              ),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.supervised_user_circle),
                  title: Text('Akun'),
              ),
            ],
          ),
        ),
    );
  }

}