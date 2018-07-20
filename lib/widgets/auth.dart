import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flut_run/globalVariables/user_data.dart';


abstract class BaseAuth {

  Future<String> currentUser();
  Future<String> signIn(String _email, String _password);
  Future<String> createUser(String _email, String _password, String _firstName, String _lastName);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String _email, String _password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);
    email = _email;
    return user.uid;
  }

  Future<String> createUser(String _email, String _password, String _firstName, String _lastName) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: _email, password: _password);
    return user.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

}