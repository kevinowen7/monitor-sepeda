import 'dart:math';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/screens/home.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FirebaseDBCustom {
  static final databaseReference = FirebaseDatabase.instance.reference();
  static String deviceId;
  static String userEmail;
  static String userdisplayName;


  static Future<String> createNewUser(email,password,device_id,device_password) async {
    //validasi device_id dan device_password
    var returnData = "";
    await databaseReference.child(device_id+"/password_device").once().then((DataSnapshot snapshot) async {
      var encrypt = sha256.convert(utf8.encode(device_password)).toString();
      if (encrypt.toLowerCase()==snapshot.value.toString().toLowerCase()){
        //success validate
        try {
          //create auth
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password
          );

          //create db
          databaseReference.child(device_id).update({
            'user':userCredential.user.uid,
            'password_device':null
          });

          deviceId = device_id;

          returnData = "1";
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            returnData = 'The password provided is too weak.';
          } else if (e.code == 'email-already-in-use') {
            returnData = 'The account already exists for that email.';
          }
        } catch (e) {
          returnData =  e.toString();
        }
      } else {
        returnData = 'Device ID atau Password Salah';
      }
    });
    return returnData;
  }

  static Future<String> login(email,password) async {
    //validasi device_id dan device_password
    var returnData = "";
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      await databaseReference.orderByChild("user").equalTo(userCredential.user.uid).once().then((DataSnapshot snapshot) async {
        Map<dynamic, dynamic> data = snapshot.value;
        String device_id = data.keys.toString();
        device_id = device_id.split("(")[1].split(")")[0];

        if (device_id!=null){
          deviceId = device_id;
          userEmail = userCredential.user.email;
          userdisplayName = userCredential.user.email.split("@")[0];

          returnData = '1';
        } else {
          returnData = 'Email tidak terhubung dengan perangkat lagi';
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        returnData = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        returnData = 'Wrong password provided for that user.';
      }
    }
    return returnData;
  }
  static Future<void> checkLogin(context,toPage) async {
    ProgressDialog _progressDialog = ProgressDialog();
    _progressDialog.showProgressDialog(context,dismissAfter: Duration(seconds: 30),textToBeDisplayed:'Loading...',barrierColor: LightColors.transparant,onDismiss:() {
      Fluttertoast.showToast(msg: "No Internet Access");
    });
    await FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user == null) {
        _progressDialog.dismissProgressDialog(context);
      } else {
        await databaseReference.orderByChild("user").equalTo(user.uid).once().then((DataSnapshot snapshot) async {
          Map<dynamic, dynamic> data = snapshot.value;
          String device_id = data.keys.toString();
          device_id = device_id.split("(")[1].split(")")[0];

          if (device_id!=null){
            deviceId = device_id;
            userEmail = user.email;
            userdisplayName = user.email.split("@")[0];
          }
          //move page
          _progressDialog.dismissProgressDialog(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        });
      }
    });
  }

  static random(min, max){
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }

  static Future<String> logout() async {
    await FirebaseAuth.instance.signOut();
    deviceId="";
    //create db
    /* add dummy data
    for(var i=0;i<20;i++) {
      databaseReference.child("device-01abc/data").push().set({
        'date': "2021-01-" + random(2, 15).toString(),
        'time': "14:10:25",
        'kecepatan': random(10, 40),
        'pemakaian': random(5, 16),
      });
    }
    */
    return "1";
  }

  static Future<List<DataPoint<dynamic>>> getBulkDataPemakaian() async {
    List<DataPoint<dynamic>> returnData = new List<DataPoint<dynamic>>();
    for(var i=0;i<=14;i++){
      DateTime d1 = DateTime.now().subtract(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(d1);
      await databaseReference.child(deviceId.toString()+"/data").orderByChild("date").equalTo(formattedDate).limitToLast(1).once().then((DataSnapshot snapshot) async {
        if (snapshot.value!=null) {
          Map<dynamic, dynamic> data = snapshot.value;
          String key = data.keys.toString();
          key = key.split("(")[1].split(")")[0];
          double valuePemakaian = data[key]["pemakaian"].toDouble();
          returnData.add(DataPoint<DateTime>(value: valuePemakaian, xAxis: d1));
        }
      });
    }
    return returnData;
  }

  static Future<void> resetPassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: userEmail);
    return "1";
  }

  static void setTokenDevice(String token) {
    databaseReference.child(deviceId).update({
      'token':token
    });
  }

}