import 'package:flutter/material.dart';
import 'package:flut_run/pages/race_predictor_page.dart';
import 'package:flut_run/widgets/distance.dart';

class RacePredictorSettings extends StatefulWidget {
  RacePredictorSettings(
      {this.themeData, this.racePredictorPage});

  final ThemeData themeData;
  final RacePredictorPageState racePredictorPage;

  @override
  RacePredictorSettingsState createState() => RacePredictorSettingsState();
}

class RacePredictorSettingsState extends State<RacePredictorSettings> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.themeData,
        child: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Title(
                    child: Text(" Settings ", style: TextStyle(fontSize: 32.0)),
                    color: this.widget.themeData.primaryColor,
                  ),
                  decoration:
                  BoxDecoration(color: this.widget.themeData.primaryColor),
                ),
                Form(
                    key: this.widget.racePredictorPage.formKey,
                    child: Padding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Coming soon..."),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 130.0),
                          )
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 7.0),
                    ))
              ],
            )));
  }

}