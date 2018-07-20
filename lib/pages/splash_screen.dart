import 'package:flutter/material.dart';
import 'dart:async';
import 'root_page.dart';
import 'package:flut_run/widgets/auth.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({this.themeData});
  final ThemeData themeData;
  static String tag = "Splash Screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    //push route and remove
    Timer(Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext) => RootPage(auth: Auth(), themeData: widget.themeData,))));
    //Timer(Duration(seconds: 3), () => _splash = RootPage(auth: Auth()));
  }


  static Widget splashImage() {
    return
      CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage("assets/images/rainbow_runner.png"),
        radius: 75.0,
//                        child: Icon(Icons.directions_run,
//                            color: Colors.greenAccent, size: 50.0),
      );
  }

  static Widget splashText() {
    return Text(
      "FlutRun",
      style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.themeData,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
              ),
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          splashImage(),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          splashText(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        Text(
                          "Bringing the running community together",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

}

