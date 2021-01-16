import 'dart:async';
import 'package:flutter/material.dart';

import 'screens/login.dart';
import 'theme/colors/light_colors.dart';
import 'theme/colors/light_colors.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.blueAccent;
  final TextStyle styleTextUnderTheLoadersty = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final splashDelay = 5;

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightGreen,
      body: InkWell(
        child: Container(
          padding: EdgeInsets.fromLTRB(60, 40, 60, 40),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(00, 100, 0, 0),
                width: 50,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'BIKE-M SYSTEM',
                          style: TextStyle(
                            fontSize: 32.0,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2.8
                              ..color = Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Image.asset('assets/images/Logo bikem.png',width: 100,height: 100,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(height: 400),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Container(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}