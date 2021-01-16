import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_planner_app/db/firebase-db.dart';
import 'package:flutter_task_planner_app/loading/loading.dart';
import 'package:flutter_task_planner_app/main.dart';
import 'package:flutter_task_planner_app/screens/home.dart';
import 'package:flutter_task_planner_app/screens/register.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/top_container.dart';
import 'package:flutter_task_planner_app/widgets/back_button.dart';
import 'package:flutter_task_planner_app/widgets/my_text_field.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatelessWidget {
  DateTime currentBackPressTime;
  //data form
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Tap 2 kali untuk keluar");
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    _autoLogin(context);
    double width = MediaQuery.of(context).size.width;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'BIKE-M SYSTEM',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.w600,color: LightColors.kLightGreen),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                      children: <Widget>[
                        SizedBox(height: 30),
                        Image.asset('assets/images/Logo bikem.png',width: 160,),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: LightColors.kDarkBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 20),
                        MyTextField(
                          label: 'Email',
                          controller: emailController,
                        ),
                        SizedBox(height: 20),
                        MyTextField(
                            label: 'Password',
                            obscureText:true,
                            controller: passwordController,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    )
                  )),
              Container(
                height: 60,
                width: width,
                padding: const EdgeInsets.fromLTRB(0,10,0,0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to second route when tapped.
                        final Map<String, String> data = new Map<String, String>();
                        data['email'] = emailController.text;
                        data['password'] = passwordController.text;
                        loginListener(context,Home(),_formKey,data);
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
                        'Login',
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
                height: 100,
                width: width,
                padding: const EdgeInsets.fromLTRB(0,10,0,40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to second route when tapped.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: LightColors.kDarkBlue,
                        onPrimary: Colors.white,
                        onSurface: Colors.grey,
                        padding: const EdgeInsets.fromLTRB(20,10,20,10),
                        minimumSize: Size(width-40, 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      child: Text(
                        'Register',
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
      ),
    );
  }

  void loginListener(context,page,_formKey,dataForm) {
    //validate form
    if (_formKey.currentState.validate()) {
      MyApp().openLoadingToNewPage(context, page, 'login', dataForm);
    }
  }


  Future<void> _autoLogin(BuildContext context)  async {
    //auto login
    FirebaseDBCustom.checkLogin(context,Home());
  }
}
