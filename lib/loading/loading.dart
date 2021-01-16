import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
class Loading {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(LightColors.kLightGreen),),
                        SizedBox(height: 10,),
                        Text("Please Wait....",style: TextStyle(color: LightColors.kLightGreen),)
                      ]),
                    )
                  ]));
        });
  }
}