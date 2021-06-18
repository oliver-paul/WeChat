import 'package:flutter/material.dart';
import 'package:we_chat/backend/auth_method.dart';
import 'package:we_chat/classes/constant%20_names.dart';
import 'package:we_chat/classes/shared_preference_methods.dart';
import 'package:we_chat/screens/sign_in.dart';

class drawer extends StatefulWidget {
  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  auth_methods a = new auth_methods();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.green,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                "",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                constant_files.current_username.toUpperCase(),
                style: TextStyle(fontSize: 30),
              ),
              decoration: BoxDecoration(
                color: Colors.green[700],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                a.sign_out().then((value) {
                  shared_preferenec_methods
                      .saveUserLoggedInSharedPreference(false);
                  print("Shared preference is set to false");
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => sign_in()));
                print("Logout user");
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 25.0, 0, 0),
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 25.0, 0, 0),
                    child: Text(
                      "Logout",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
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
}
