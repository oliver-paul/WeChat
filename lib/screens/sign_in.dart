import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/Widgets/widget.dart';
import 'package:we_chat/backend/auth_method.dart';
import 'package:we_chat/backend/database_methods.dart';
import 'package:we_chat/screens/chat_page.dart';
import 'package:we_chat/screens/sign_up.dart';
import 'package:we_chat/classes/shared_preference_methods.dart';

// shift+alt_f
// ignore: camel_case_types
class sign_in extends StatefulWidget {
  sign_in({Key key}) : super(key: key);

  @override
  _sign_inState createState() => _sign_inState();
}

// ignore: camel_case_types
class _sign_inState extends State<sign_in> {
  GlobalKey<FormState> key1 = new GlobalKey<FormState>();

  auth_methods a = new auth_methods();
  Database_Methods m = new Database_Methods();
  QuerySnapshot snap;

  bool isLoading = false;

  TextEditingController email_editing_controller = new TextEditingController();
  TextEditingController password_editing_controller =
      new TextEditingController();

  sign_in_user() async {
    if (key1.currentState.validate()) {
      shared_preferenec_methods
          .saveUserEmailSharedPreference(email_editing_controller.text);
      setState(() {
        isLoading = true;
      });
    }

    m.getEmail(email_editing_controller.text).then((val) {
      snap = val;
      print("The shared preference: Username  " +
          snap.docs[0].get("Username") +
          " The email : " +
          snap.docs[0].get("Email"));
      shared_preferenec_methods
          .saveUserNameSharedPreference(snap.docs[0].get("Username"));
    });  

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email_editing_controller.text,
              password: password_editing_controller.text)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => chat_page()));
        shared_preferenec_methods.saveUserLoggedInSharedPreference(true);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: main_app_bar(context),
      body: isLoading ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ): ListView(
        children: [
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Image.asset(
                  "assets/images/wechat_logo.jpg",
                  height: 290.0,
                  width: 270.0,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                child: Form(
                  key: key1,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val) {
                          if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                  .hasMatch(val) ||
                              val.isEmpty) {
                            return "The email Id is invalid";
                          }
                        },
                        controller: email_editing_controller,
                        decoration: text_design('Email'),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val.isEmpty || val.length < 6) {
                            return "Check the password you have enetred";
                          }
                        },
                        controller: password_editing_controller,
                        obscureText: true,
                        decoration: text_design('Password'),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(210.0, 10.0, 0.0, 10.0),
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
                onTap: () {
                  print("Forgot Password");
                  email_editing_controller.text.isNotEmpty
                      ? a.forgot_password(email_editing_controller.text)
                      : print("The email box is empty");
                },
              ),
              GestureDetector(
                onTap: () {
                  sign_in_user();
                  print("Sign In");
                },
                child: Container(
                  height: 50.0,
                  width: 270.0,
                  child: Center(child: Text("Sign In")),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.greenAccent[700],
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              // GestureDetector(
              //   onTap: () {
              //     print("Sign In with google");
              //   },
              //   child: Container(
              //     height: 50.0,
              //     width: 270.0,
              //     child: Center(child: Text("Sign In With Google")),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       color: Colors.green[300],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
              Center(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(130.0, 0, 0, 0),
                      child: Text("Dont Have a account ?"),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Register Now");

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => sign_up()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
