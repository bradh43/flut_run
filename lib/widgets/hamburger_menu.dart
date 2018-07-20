import 'package:flutter/material.dart';
import 'package:flut_run/pages/home_page.dart';
import 'package:flut_run/pages/mileage_planner_page.dart';
import 'package:flut_run/pages/mileage_log_page.dart';
import 'package:flut_run/pages/split_calculator_page.dart';
import 'package:flut_run/pages/messenger_page.dart';
import 'package:flut_run/pages/race_predictor_page.dart';
import 'package:flut_run/pages/lifting_calculator_page.dart';
import 'package:flut_run/pages/about_page.dart';
import 'package:flut_run/globalVariables/user_data.dart';


class HamburgerMenu extends StatelessWidget {
  HamburgerMenu({this.currentTab, this.themeData});

  final int currentTab;
  final ThemeData themeData;

//  final String _name = "Brad";
//  final String _email = "brad.hodkinson2@gmail.com";
//  final String profilePicture = "assets/images/runnerIcon.png";
//  //final String profilePicture = "assets/images/noProfileIcon.png";
  final String backGroundImage = "assets/images/run_background.jpg";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              name,
              style: TextStyle(color: Colors.black, fontSize: 25.0),
            ),
            accountEmail:
                Text(email, style: TextStyle(color: Colors.black)),
            currentAccountPicture: GestureDetector(
              onTap: () => print("This is the current user, " + userName),
              child: CircleAvatar(
                backgroundImage: AssetImage(profilePicture),
              ),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(backGroundImage),
            )),
          ),
          ListTile(
            title: Text("Home", style: TextStyle(fontSize: 20.0)),
            trailing: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).pop();
              if (currentTab != 0) {
                
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext) => HomePage(themeData: this.themeData))
                );
              }
            },
          ),
          ListTile(
            title: Text("Mileage Planner", style: TextStyle(fontSize: 18.0)),
            trailing: Icon(Icons.directions_run),
            onTap: () {
              Navigator.of(context).pop();
              if (currentTab != 1) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext) => MileagePlannerPage(
                      themeData: this.themeData,
                    )),
                );

              }
            },
          ),
          ListTile(
            title: Text("Mileage Log", style: TextStyle(fontSize: 18.0)),
            trailing: Icon(Icons.grid_on),
            onTap: () {
              Navigator.of(context).pop();
              if (currentTab != 2) {
                
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext) => MileageLogPage(
                      themeData: this.themeData,
                    )));
              }
            },
          ),
          ListTile(
            title: Text("Split Calculator", style: TextStyle(fontSize: 18.0)),
            trailing: Icon(Icons.timer),
            onTap: () {
              Navigator.of(context).pop();
              if (currentTab != 3) {
                
                Navigator
                    .of(context)
                    .pushReplacement(MaterialPageRoute(builder: (BuildContext) => SplitCalculatorPage(
                  themeData: themeData,
                )));
              }
            },
          ),
          ListTile(
            title: Text("Messenger", style: TextStyle(fontSize: 18.0)),
            trailing: Icon(Icons.message),
            onTap: () {
              Navigator.of(context).pop();
              if (currentTab != 4) {
                
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext) => Messenger(
                          themeData: themeData,
                        )));
              }
            },
          ),
          ListTile(
            title: Text("Race Predictor", style: TextStyle(fontSize: 18.0)),
            trailing: ImageIcon(AssetImage("assets/icons/ai_brain.png")),
            onTap: () {
              Navigator.of(context).pop();
              if (currentTab != 5) {
                
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext) => RacePredictorPage(
                      themeData: this.themeData,
                    )));
              }
            },
          ),
          ListTile(
            title: Text("Lifting Calculator", style: TextStyle(fontSize: 18.0)),
            trailing: ImageIcon(AssetImage("assets/icons/barbell.png")),
            onTap: () {
              Navigator.of(context).pop();
              if (currentTab != 6) {
                
                Navigator
                    .of(context)
                    .pushReplacement(MaterialPageRoute(builder: (BuildContext) => LiftingCalculatorPage(
                  themeData: themeData,
                )));
              }
            },
          ),
          ListTile(
            title: Text("About", style: TextStyle(fontSize: 18.0)),
            trailing: Icon(Icons.more),
            onTap: () {
              Navigator.of(context).pop();
              if (currentTab != 7) {
                
                Navigator
                    .of(context)
                    .pushReplacement(MaterialPageRoute(builder: (BuildContext) => AboutPage(
                  themeData: themeData,
                )));
              }
            },
          )
        ],
      ),
    );
  }
}
