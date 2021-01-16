import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_task_planner_app/db/firebase-db.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/active_project_card.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_task_planner_app/widgets/top_container.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();

}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _currentDate = DateTime.now();

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: LightColors.kLightGreen,
      body: SafeArea(
        child:SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            0,
            0,
            0,
          ),
          child: Column(
            children: <Widget>[
              TopContainer(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                width: width,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Kalendar',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: CalendarCarousel<Event>(
                  onDayPressed: (DateTime date, List<Event> events) {
                    this.setState(() =>
                      _currentDate = date
                    );
                    this.setState(() =>
                      formattedDate = DateFormat('yyyy-MM-dd').format(date)
                    );
                  },
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                  ),
                  thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
                  customDayBuilder: (   /// you can provide your own build function to make custom day containers
                      bool isSelectable,
                      int index,
                      bool isSelectedDay,
                      bool isToday,
                      bool isPrevMonthDay,
                      TextStyle textStyle,
                      bool isNextMonthDay,
                      bool isThisMonthDay,
                      DateTime day,
                      ) {
                  },
                  weekFormat: false,
                  height: 420.0,
                  selectedDateTime: _currentDate,
                  daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Kecepatan Anda', style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700)),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        StreamBuilder(
                          stream: FirebaseDBCustom.databaseReference.child(FirebaseDBCustom.deviceId.toString()+"/data").orderByChild("date").equalTo(formattedDate).onValue,
                          builder: (context, snap) {
                            var highestSpeed = 0;

                            if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
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
                              value: highestSpeed.toStringAsFixed(1)+ " km/h",
                            );
                          },
                        ),
                        SizedBox(width: 20.0),
                        StreamBuilder(
                          stream: FirebaseDBCustom.databaseReference.child(FirebaseDBCustom.deviceId.toString()+"/data").orderByChild("date").equalTo(formattedDate).onValue,
                          builder: (context, snap) {
                            var avgSpeed = 0;
                            double avgSpeedFinal = 0;

                            if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
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
        ),
        ),
      ),
    );
  }
}
