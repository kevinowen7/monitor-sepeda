import 'dart:io';

import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/Splashscreen.dart';
import 'package:flutter_task_planner_app/db/firebase-db.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_support/overlay_support.dart';


Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: LightColors.kLightGreen, // navigation bar color
    statusBarColor: Color(0x9977dd77), // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return OverlaySupport(
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: LightColors.kDarkBlue,
              displayColor: LightColors.kDarkBlue,
              fontFamily: 'Poppins'
            ),
      ),
      home: SplashScreen()
      ,
      debugShowCheckedModeBanner: false,
    ),
      );
  }

  void openLoadingToNewPage(context,page,type,payload) {

    Future<void> _handleSubmit(BuildContext context,page,type,payload) async {
      try {
        ProgressDialog _progressDialog = ProgressDialog();
        _progressDialog.showProgressDialog(context,dismissAfter: Duration(seconds: 30),textToBeDisplayed:'Loading...',barrierColor: LightColors.transparant,onDismiss:() {
          Fluttertoast.showToast(msg: "No Internet Access");
        });
        if (type=="register"){
          //register to firebase
          String result = await FirebaseDBCustom.createNewUser(payload["email"], payload["password"], payload["device_id"], payload["device_password"]);
          await Future.delayed(Duration(seconds: 2));
          _progressDialog.dismissProgressDialog(context);
          if (result=="1"){
            //move page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => page,
              ),
            );
          } else {
            Fluttertoast.showToast(msg: result);
          }
        } else if (type=="login"){
          //register to firebase
          String result = await FirebaseDBCustom.login(payload["email"], payload["password"]);
          await Future.delayed(Duration(seconds: 2));
          _progressDialog.dismissProgressDialog(context);//close the dialoge
          if (result=="1"){
            //move page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => page,
              ),
            );
          } else {
            Fluttertoast.showToast(msg: result);
          }
        } else {
          await Future.delayed(Duration(seconds: 2));
          _progressDialog.dismissProgressDialog(context);//close the dialoge
          //move page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        }
      } catch (error) {
        print("error");
        print(error);
      }
    };

    _handleSubmit(context,page,type,payload);
  }


}
