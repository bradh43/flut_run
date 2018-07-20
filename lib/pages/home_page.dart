import 'package:flutter/material.dart';
import 'package:flut_run/widgets/auth.dart';
import 'package:flut_run/widgets/hamburger_menu.dart';
import 'package:flut_run/widgets/main_logo_image.dart';
import 'package:flut_run/globalVariables/user_data.dart';
import 'package:flut_run/pages/root_page.dart';
import 'package:flut_run/pages/login_page.dart';


class HomePage extends StatelessWidget {
  HomePage({this.themeData});

  final ThemeData themeData;



  @override
  Widget build(BuildContext context) {

    void _signOut() async {

      try {
        await auth.signOut();
        onSignOut();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext) => RootPage(auth: Auth(), themeData: themeData,)),);

      } catch (e) {
        print(e);
      }

    }

    Widget logoutButton() {
      return  FlatButton(
          onPressed: _signOut,
          child:  Text('Logout', style:  TextStyle(fontSize: 17.0))
      );
    }

    Widget welcomeMessage() {
      return  Text(
        'Welcome',
        style:  TextStyle(fontSize: 32.0),
      );
    }

    Widget homeBody() {
      return Center(
        child: Column(
          children: <Widget>[
            welcomeMessage(),
            MainLogoImage(),
          ],
        ),
      );
    }

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[logoutButton()],
        ),
        drawer: HamburgerMenu(currentTab: 0, themeData: themeData),
        body: homeBody(),
      )
    );
  }
}