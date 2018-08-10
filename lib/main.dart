import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'package:flutter/scheduler.dart';
import 'package:flut_run/globalVariables/user_data.dart' as userData;

final List<ThemeData> teamThemeData = [
  ThemeData(
      //PLU Theme Colors
      fontFamily: 'Aileron',
      splashColor: Colors.lightBlueAccent,
      brightness: Brightness.dark,
      primaryColor: Colors.yellow[700],
      accentColor: Colors.yellow[700],
      primarySwatch: Colors.yellow[750],
      primaryColorDark: Colors.yellow[700],
      textSelectionColor: Colors.yellow[700],
      highlightColor: Colors.yellow[650],
      buttonColor: Colors.yellow[700],
      toggleableActiveColor: Colors.yellow[700],
  ),
  ThemeData(
    //Wash U theme Colors
    fontFamily: 'Aileron',
    splashColor: Colors.lightBlueAccent,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF007360),
    accentColor: const Color(0xFFA51417),
    primarySwatch: Colors.green,
    primaryColorDark: const Color(0xFF007360),
    textSelectionColor: const Color(0xFF007360),
    highlightColor: const Color(0xFF007360),
    buttonColor: const Color(0xFFA51417),
    toggleableActiveColor: const Color(0xFFA51417),



  ),
  ThemeData(
    //Snohomish Theme colors
    fontFamily: 'Aileron',
    splashColor: Colors.lightBlueAccent,
    brightness: Brightness.dark,
    primaryColor: Colors.red[800],
    accentColor: Colors.white,
    primarySwatch: Colors.red,
    primaryColorDark: Colors.red[800],
    textSelectionColor: Colors.white,
    highlightColor: Colors.grey,
    buttonColor: Colors.red[800],
    toggleableActiveColor: Colors.red[700],
  ),
  ThemeData(
    //Default Theme
    fontFamily: 'Aileron',
    splashColor: Colors.lightBlueAccent,
    primaryColor: Colors.lightBlueAccent,
    primaryColorDark: Colors.lightBlueAccent,
    brightness: Brightness.dark,
  ),
];



void main() {

  final ThemeData _themData = teamThemeData[1];

  userData.imagePath = "assets/images/bears.png";
  //userData.imagePath = "assets/images/lutes.png";
  //userData.imagePath = "assets/images/panther.png";


  timeDilation = 1.0;
  runApp(MaterialApp(
    title: "Flut Run",
    theme: _themData,
    debugShowCheckedModeBanner: false,
    home: SplashScreen(themeData: _themData),
  ));
}
