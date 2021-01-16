import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/db/firebase-db.dart';
import 'package:flutter_task_planner_app/screens/login.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/top_container.dart';
import 'package:flutter_task_planner_app/widgets/back_button.dart';
import 'package:flutter_task_planner_app/widgets/my_text_field.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Akun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return Scaffold(
      backgroundColor: LightColors.kLightGreen,
      body: SafeArea(
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
                        'Akun',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Name',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: LightColors.kDarkBlue,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          flex: 1,
                          child: Text(
                            ":",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: LightColors.kDarkBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                      ),
                      Expanded(
                        flex: 8,
                        child: Text(
                          FirebaseDBCustom.userdisplayName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: LightColors.kDarkBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Device ID',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: LightColors.kDarkBlue,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          flex: 1,
                          child: Text(
                            ":",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: LightColors.kDarkBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                      ),
                      Expanded(
                          flex: 8,
                          child: Text(
                            FirebaseDBCustom.deviceId,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: LightColors.kDarkBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Email',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: LightColors.kDarkBlue,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          flex: 1,
                          child: Text(
                            ":",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: LightColors.kDarkBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                      ),
                      Expanded(
                          flex: 8,
                          child: Text(
                            FirebaseDBCustom.userEmail,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: LightColors.kDarkBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                      ),
                    ],
                  )
                ],
              ),
            )),
            Container(
              height: 80,
              width: width,
              padding: const EdgeInsets.fromLTRB(0,10,0,20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      _resetPassword(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: LightColors.kLightBlue,
                      onPrimary: Colors.white,
                      onSurface: Colors.grey,
                      padding: const EdgeInsets.fromLTRB(20,10,20,10),
                      minimumSize: Size(width-40, 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 80,
              width: width,
              padding: const EdgeInsets.fromLTRB(0,10,0,20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      _logOut(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      onSurface: Colors.grey,
                      padding: const EdgeInsets.fromLTRB(20,10,20,10),
                      minimumSize: Size(width-40, 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logOut(BuildContext context) async {
    //log out
    await FirebaseDBCustom.logout();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }

  Future<void> _resetPassword(BuildContext context) async {
    //log out
    ProgressDialog _progressDialog = ProgressDialog();
    _progressDialog.showProgressDialog(context,dismissAfter: Duration(seconds: 30),textToBeDisplayed:'Loading...',barrierColor: LightColors.transparant,onDismiss:() {
      Fluttertoast.showToast(msg: "No Internet Access");
    });
    await FirebaseDBCustom.resetPassword();
    _progressDialog.dismissProgressDialog(context);
    Fluttertoast.showToast(msg: "Password reset was sent by email");
  }
}
