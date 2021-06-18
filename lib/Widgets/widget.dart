import 'package:flutter/material.dart';

Widget main_app_bar(BuildContext) {
  return AppBar(
    title: Text("We Chat"),
    backgroundColor: Colors.greenAccent[700],
  );
}

InputDecoration text_design(String s) {
  return InputDecoration(
    hintText: 'Enter your ' + s,
    labelText: s,
    border: OutlineInputBorder(),
    hintStyle: TextStyle(
      color: Colors.black38,
    ),
  );
}

final String current_user=" ";
