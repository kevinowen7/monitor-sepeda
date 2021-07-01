import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final bool obscureText;
  final Icon icon;
  final TextEditingController  controller;
  MyTextField({this.label, this.maxLines = 1, this.minLines = 1, this.obscureText = false, this.icon, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      style: TextStyle(color: Colors.black87),
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value.isEmpty) {
          return 'Silahkan isi kolom';
        }else {
          if (label=="Email") {
            bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value);
            if (!emailValid){
              return 'Email tidak valid';
            }
          } else if(label=="Password"){
            if (value.length<6){
              return 'Password minimal 6 digit';
            }
          }

        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: icon == null ? null: icon,
          labelText: label,
          labelStyle: TextStyle(color: Colors.black45),
          
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
