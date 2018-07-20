import 'package:flutter/material.dart';
import 'package:flut_run/widgets/auth.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'package:flut_run/globalVariables/user_data.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth, this.themeData}) : super(key: key);
  final BaseAuth auth;
  final ThemeData themeData;

  @override
  State<StatefulWidget> createState() =>  _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(
          title: 'FlutRun',
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
          themeData: widget.themeData,
        );
        break;
      case AuthStatus.signedIn:
        auth =  widget.auth;
        //onSignOut = () => _updateAuthStatus(AuthStatus.notSignedIn);
        onSignOut = () => null;
        return HomePage(themeData: widget.themeData,);
        break;
      default:
        return null;
    }
  }
}