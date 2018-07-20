import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flut_run/widgets/hamburger_menu.dart';
import 'package:flut_run/widgets/auth.dart';
import 'package:flut_run/widgets/race_predictor_settings.dart';


import 'package:flut_run/widgets/main_logo_image.dart';

RacePredictorPageState racePredictorPageState;

class RacePredictorPage extends StatefulWidget {
  RacePredictorPage({this.themeData});

  final themeData;

  @override
  RacePredictorPageState createState() =>
      racePredictorPageState = RacePredictorPageState();
}

class RacePredictorPageState extends State<RacePredictorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MainLogoImage mainLogo = MainLogoImage();


  //initializing setting variables


  final formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    RacePredictorSettings racePredictorSettings = RacePredictorSettings(
        themeData: widget.themeData,
        racePredictorPage: racePredictorPageState);
    return Theme(
        data: widget.themeData,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Race Predictor"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => _scaffoldKey.currentState.openEndDrawer())
            ],
            backgroundColor: Theme
                .of(context)
                .primaryColorDark,
          ),
          drawer: HamburgerMenu(
              currentTab: 5,
              themeData: widget.themeData,
              ),
          endDrawer: racePredictorSettings,
          body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(mainLogo.imagePath),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.75), BlendMode.srcATop),
                  fit: BoxFit.contain,
                ),
              ),
              child: Text("Coming Soon...")
          ),
        ));
    }
  }
