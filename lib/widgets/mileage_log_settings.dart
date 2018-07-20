import 'package:flutter/material.dart';
import 'package:flut_run/pages/mileage_log_page.dart';
import 'package:flut_run/widgets/distance.dart';
import 'package:flut_run/globalVariables/mileage_log_data.dart' as mileageLogData;
import 'package:flut_run/widgets/time.dart';

class MileageLogSettings extends StatefulWidget {
  MileageLogSettings(
      {this.themeData,
        this.mileagePage,
        this.time,
        this.distance});

  final ThemeData themeData;
  final MileageLogPageState mileagePage;
  final Time time;
  final Distance distance;

  @override
  MileageLogSettingsState createState() => MileageLogSettingsState();
}

class MileageLogSettingsState extends State<MileageLogSettings> {
  ScrollController _settingsListViewController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.themeData,
        child: Drawer(
            child: ListView(
              controller: _settingsListViewController,
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
                    key: this.widget.mileagePage.formKey,
                    child: Padding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //todo
                          calculateButton(),
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

  Widget calculateButton() {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 30.0),
      child: RaisedButton(
          child: Text("Calculate",
              style: TextStyle(color: Colors.white, fontSize: 20.0)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0 / 2))),
          onPressed: () => calculateMileage()),
    );
  }


  bool validateAndSave() {
    final form = this.widget.mileagePage.formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }



  void calculateMileage() {
    if (validateAndSave()) {
      //calculate total miles
      //todo
      mileageLogData.totalMileage = 91;

      //update state of the settings menu
      this.setState(() {
        //scroll to top of settings menu
        FocusScope.of(context).requestFocus(new FocusNode());
        _settingsListViewController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
      });


      //update the state of the mileage calculator page
      this.widget.mileagePage.setState(() {
        //update how far to run each day
        //todo
      });

      mileageLogData.mileageContentState.setState((){
        mileageLogData.showInitial = false;
      });

      
    }
  }
}