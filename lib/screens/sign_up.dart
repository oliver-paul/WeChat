import 'package:flutter/material.dart';
import 'package:we_chat/Widgets/widget.dart';
import 'package:we_chat/backend/auth_method.dart';
import 'package:we_chat/backend/database_methods.dart';
import 'package:we_chat/classes/shared_preference_methods.dart';
import 'package:we_chat/screens/sign_in.dart';

import 'chat_page.dart';

class sign_up extends StatefulWidget {
  sign_up({Key key}) : super(key: key);

  @override
  _sign_upState createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  bool loading = false;

  TextEditingController user_name_textbox = new TextEditingController();
  TextEditingController password_textbox = new TextEditingController();
  TextEditingController confirm_password_textbox = new TextEditingController();
  TextEditingController email_textbox = new TextEditingController();

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  auth_methods a = new auth_methods();

  Database_Methods m = new Database_Methods();

  button_validator() {
    Map<String, String> userMap = {
      "Username": user_name_textbox.text,
      "Email": email_textbox.text
    };

    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });

      shared_preferenec_methods
          .saveUserEmailSharedPreference(email_textbox.text);
      shared_preferenec_methods
          .saveUserNameSharedPreference(user_name_textbox.text);

      m.uploadData(userMap);

      a.sign_up_email_password(email_textbox.text, password_textbox.text)
          .then((value) {
        print("The auth is: $value");
        shared_preferenec_methods.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => chat_page()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: main_app_bar(context),
      body: loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView(
              children: [
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 35.0,
                          ),
                          Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent[400],
                            ),
                          ),
                          SizedBox(
                            height: 35.0,
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  validator: (val) {
                                    if (val.isEmpty || val.length < 4) {
                                      return "Enter a username with character more than 4 charcters";
                                    }
                                  },
                                  controller: user_name_textbox,
                                  decoration: text_design('Username'),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  controller: email_textbox,
                                  validator: (val) {
                                    if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                            .hasMatch(val) ||
                                        val.isEmpty) {
                                      return "The email Id is invalid";
                                    }
                                  },
                                  decoration: text_design('Email'),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  validator: (val) {
                                    if (val.isEmpty || val.length < 6) {
                                      return "Check the password you have enetred";
                                    }
                                  },
                                  controller: password_textbox,
                                  decoration: text_design('Password'),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  controller: confirm_password_textbox,
                                  validator: (val) {
                                    if (val.isEmpty || val.length < 6) {
                                      return "Check the password you have enetred";
                                    }
                                  },
                                  obscureText: true,
                                  decoration: text_design('Confirm Password'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Sign Up");
                        button_validator();
                      },
                      child: Container(
                        height: 50.0,
                        width: 270.0,
                        child: Center(child: Text("Sign Up")),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.greenAccent[700],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     print("Sign Up with google");
                    //     button_validator();
                    //   },
                    //   child: Container(
                    //     height: 50.0,
                    //     width: 270.0,
                    //     child: Center(child: Text("Sign Up With Google")),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20),
                    //       color: Colors.green[300],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(130.0, 0, 0, 0),
                          child: Text("Already Have a account !"),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Going to sgn in page");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => sign_in()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
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
