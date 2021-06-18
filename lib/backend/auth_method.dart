import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_chat/classes/user_auth.dart';

class auth_methods {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  UserCredential result;
  User firebaseuser;

  user_auth _firebase_user(User u) 
  {
    return u != null ? user_auth(u.uid) : null;
  }

  Future sign_in_email_password(String pass, String emai) async
   {
    try {
      result = await _auth
          .signInWithEmailAndPassword(email: emai, password: pass)
          .then((value) {
        print("In the sign in page of email and password");
      }).onError((error, stackTrace) {
        print("The auth has a problem");
      });

      firebaseuser = result.user;
      print("this is the firebaseuser:" + firebaseuser.toString());
      return _firebase_user(firebaseuser);
    } catch (e) {
      print("Some error with the authentication");
      print(e.toString());
    }
  }

  Future sign_up_email_password(String email, String pass) async {
    try {
      result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);

      firebaseuser = result.user;
      return _firebase_user(firebaseuser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future forgot_password(String e) async {
    try {
      return await _auth.sendPasswordResetEmail(email: e);
    } catch (e) {
      print(e.toString());
    }
  }

  Future sign_out() async {
    return await _auth.signOut();
  }
}
