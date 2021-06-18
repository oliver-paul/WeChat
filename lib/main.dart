import 'package:flutter/material.dart';
import 'package:we_chat/screens/chat_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:we_chat/classes/shared_preference_methods.dart';
import 'package:we_chat/screens/splash.dart';

void main() 
{
  runApp(MyApp());
}

class MyApp extends StatefulWidget 
{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    Firebase.initializeApp().whenComplete(() => {print("In Intialize")});
    await shared_preferenec_methods
        .getUserLoggedInSharedPreference()
        .then((value) {
      setState(() {
        print("Enter the main.dart page The value now is :" + value.toString());
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      debugShowCheckedModeBanner: false,
      home: userIsLoggedIn != null
          ? userIsLoggedIn
              ? chat_page()
              : splash()
          : splash(),
      //home: conversation(),
    );
  }
}
