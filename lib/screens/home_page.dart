import 'dart:io';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/db/firebase-db.dart';
import 'package:flutter_task_planner_app/screens/calendar_page.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_task_planner_app/widgets/task_column.dart';
import 'package:flutter_task_planner_app/widgets/active_project_card.dart';
import 'package:flutter_task_planner_app/widgets/top_container.dart';
import 'package:permission/permission.dart';

import '../StateFulWrapper.dart';

class HomePage extends StatefulWidget {
  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<DataPoint<dynamic>> dataPemakaian;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  static final databaseReference = FirebaseDatabase.instance.reference();

  var firebaseMessaging = FirebaseMessaging();

  bool isSubscribed = false;
  String token = '';
  String dataName = '';
  String dataAge = '';


  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
    debugPrint('onBackgroundMessage: $message');
    if (message.containsKey('data')) {
      String name = '';
      String age = '';
      if (Platform.isIOS) {
        name = message['name'];
        age = message['age'];
      } else if (Platform.isAndroid) {
        var data = message['data'];
        name = data['name'];
        age = data['age'];
      }
      debugPrint('onBackgroundMessage: name: $name & age: $age');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        getDataFcm(message);
      },
      onResume: (Map<String, dynamic> message) async {
        getDataFcm(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        getDataFcm(message);
      },
    );
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
    firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      debugPrint('Settings registered: $settings');
    });
    firebaseMessaging.getToken().then((tokenData) {
      token = tokenData;
      print(token);
    });

  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final fromDate = DateTime.now().subtract(Duration(days: 14));
    final toDate = DateTime.now();
    return Scaffold(
      backgroundColor: LightColors.kLightGreen,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              height: 100,
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Welcome to BIKE-M',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: LightColors.kDarkBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'Enjoy Your Day',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ),
            Expanded(
                child:SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.fromLTRB(
                            20,30,0,10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Intensitas Pemakaian', style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700)),
                              ],
                            ),

                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: FirebaseDBCustom.getBulkDataPemakaian(),
                        builder: (context, AsyncSnapshot<List<DataPoint<dynamic>>> snapshot) {
                          if( snapshot.connectionState == ConnectionState.waiting){
                            dataPemakaian = [DataPoint<DateTime>(value: 0, xAxis: DateTime.now()),
                              DataPoint<DateTime>(value: 0, xAxis: DateTime.now())];
                          }else{
                            if (snapshot.hasError)
                              dataPemakaian = [DataPoint<DateTime>(value: 0, xAxis: DateTime.now()),
                                DataPoint<DateTime>(value: 0, xAxis: DateTime.now())];
                            else
                              dataPemakaian = snapshot.data;
                              //snapshot.data  :- get your object which is pass from your downloadData() function
                          }
                          return Container(
                            color: Colors.red,
                            height: MediaQuery.of(context).size.height / 5,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: BezierChart(
                              fromDate: fromDate,
                              bezierChartScale: BezierChartScale.WEEKLY,
                              toDate: toDate,
                              selectedDate: toDate,
                              series: [
                                BezierLine(
                                  label: "Jam/Hari",
                                  data: dataPemakaian,
                                ),
                              ],
                              config: BezierChartConfig(
                                verticalIndicatorStrokeWidth: 3.0,
                                verticalIndicatorColor: Colors.black26,
                                showVerticalIndicator: true,
                                verticalIndicatorFixedPosition: false,
                                backgroundColor: LightColors.kDarkBlue,
                                footerHeight: 50.0,
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Kecepatan Anda Hari Ini', style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700)),
                            SizedBox(height: 5.0),
                            Row(
                              children: <Widget>[
                                StreamBuilder(
                                  stream: databaseReference.child(FirebaseDBCustom.deviceId.toString()+"/data").orderByChild("date").equalTo(formattedDate).onValue,
                                  builder: (context, snap) {
                                    var highestSpeed = 0;

                                    if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                                      DataSnapshot snapshot = snap.data.snapshot;
                                      Map data = snap.data.snapshot.value;
                                      List item = [];
                                      data.forEach(
                                              (index, data) => item.add({"key": index, "data":data}));

                                      //get highest speed
                                      for( var i in item) {
                                        if (i["data"]["kecepatan"]>highestSpeed){
                                          highestSpeed = i["data"]["kecepatan"];
                                        }
                                      }
                                      return ActiveProjectsCard(
                                        cardColor: LightColors.kGreen,
                                        loadingPercent: 1,
                                        title: 'Kecepatan Tertinggi',
                                        value: highestSpeed.toStringAsFixed(1) + " km/h",
                                      );
                                    }
                                    return ActiveProjectsCard(
                                      cardColor: LightColors.kGreen,
                                      loadingPercent: 1,
                                      title: 'Kecepatan Tertinggi',
                                      value: highestSpeed.toStringAsFixed(1) + " km/h",
                                    );
                                  },
                                ),
                                SizedBox(width: 20.0),
                                StreamBuilder(
                                  stream: databaseReference.child(FirebaseDBCustom.deviceId.toString()+"/data").orderByChild("date").equalTo(formattedDate).onValue,
                                  builder: (context, snap) {
                                    var avgSpeed = 0;
                                    double avgSpeedFinal = 0;

                                    if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                                      DataSnapshot snapshot = snap.data.snapshot;
                                      Map data = snap.data.snapshot.value;
                                      List item = [];
                                      data.forEach(
                                              (index, data) => item.add({"key": index, "data":data}));

                                      //get highest speed
                                      int x=0;
                                      for( var i in item) {
                                        avgSpeed = avgSpeed + i["data"]["kecepatan"];
                                        x++;
                                      }
                                      avgSpeedFinal = avgSpeed/x;

                                      return ActiveProjectsCard(
                                        cardColor: LightColors.kRed,
                                        loadingPercent: 1,
                                        title: 'Kecepatan rata-rata',
                                        value: avgSpeedFinal.toStringAsFixed(1)+' km/h',
                                      );
                                    }
                                    return ActiveProjectsCard(
                                      cardColor: LightColors.kRed,
                                      loadingPercent: 1,
                                      title: 'Kecepatan rata-rata',
                                      value: '0 km/h',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  Future<List<DataPoint<dynamic>>> _getBulkDataPemakaian() async {
    return await FirebaseDBCustom.getBulkDataPemakaian();
  }
  Future<void> requestPermission() async {
    List<PermissionName> permissionNames = [];
    permissionNames.add(PermissionName.Location);
    permissionNames.add(PermissionName.Internet);
    var message = '';
    var permissions = await Permission.requestPermissions(permissionNames);
    print(permissions);
    permissions.forEach((permission) {
      message += '${permission.permissionName}: ${permission.permissionStatus}\n';
    });
    setState(() {});
  }

  void getDataFcm(Map<String, dynamic> message) {
    String name = '';
    String age = '';
    if (Platform.isIOS) {
      name = message['name'];
      age = message['age'];
    } else if (Platform.isAndroid) {
      var data = message['data'];
      name = data['name'];
      age = data['age'];
    }
    if (name.isNotEmpty && age.isNotEmpty) {
      dataName = name;
      dataAge = age;
    }
    print("nama");
  }
}
