import 'package:flutter/material.dart';
import 'package:flut_run/pages/split_calculator_page.dart';
import 'package:flut_run/widgets/time.dart';
import 'package:flut_run/widgets/distance.dart';
import 'package:flut_run/globalVariables/split_data.dart' as splitData;

class SplitCalculatorSettings extends StatefulWidget {
  SplitCalculatorSettings(
      {this.themeData,
      this.splitPage,
      this.splitContent,
      this.time,
      this.distance});

  final ThemeData themeData;
  final SplitCalculatorPageState splitPage;
  final ContentState splitContent;
  final Time time;
  final Distance distance;

  @override
  SplitCalculatorSettingsState createState() => SplitCalculatorSettingsState();
}

class SplitCalculatorSettingsState extends State<SplitCalculatorSettings> {
  ScrollController _settingsListViewController = ScrollController();
  FocusNode _focus = new FocusNode();


  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange(){
    //if the last text field in the settings is selected scroll to the bottom
    _settingsListViewController.animateTo(
      _settingsListViewController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focus.dispose();
    _settingsListViewController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.themeData,
        child: Drawer(
            child: Scrollbar(
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
                      key: this.widget.splitPage.formKey,
                      child: Padding(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            distanceSettings(),
                            timeSettings(),
                            paceSettings(),
                            lapSettings(),
                            calculateButton(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 130.0),
                            )
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 7.0),
                      ))
                ],
              ),
            ),
        )
    );
  }

  Widget distanceSettings() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(" Distance ", style: TextStyle(fontSize: 20.0)),
              Radio(
                onChanged: (int e) => updateDistanceGroupValue(e),
                activeColor: widget.themeData.accentColor,
                value: 1,
                groupValue: splitData.distanceGroupValue,
              ),
              Text("Mi"),
              Radio(
                onChanged: (int e) => updateDistanceGroupValue(e),
                activeColor: widget.themeData.accentColor,
                value: 2,
                groupValue: splitData.distanceGroupValue,
              ),
              Text("Km"),
              Radio(
                onChanged: (int e) => updateDistanceGroupValue(e),
                activeColor: widget.themeData.accentColor,
                value: 3,
                groupValue: splitData.distanceGroupValue,
              ),
              Text("M"),
            ],
          ),
          TextFormField(
            key: Key('distance'),
            initialValue: splitData.totalDistance.toString(),
            autocorrect: false,
            autofocus: false,
            keyboardType: TextInputType.number,
            validator: (val) => val.isEmpty || num.parse(val).toDouble() <= 0.0
                ? 'Distance not properly filled out.'
                : null,
            onSaved: (val) =>
                splitData.totalDistance = num.parse(val).toDouble() + 0.0,
            decoration: InputDecoration(
              labelText: "Enter total distance",
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
          Divider()
        ]);
  }

  Widget timeSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(" Time ", style: TextStyle(fontSize: 20.0)),
        TextFormField(
          key: Key('hours'),
          autocorrect: false,
          autofocus: false,
          initialValue: splitData.totalHours.toString(),
          keyboardType: TextInputType.number,
          validator: (val) =>
              val.isEmpty ? 'Time not properly filled out.' : null,
          onSaved: (val) => splitData.totalHours = num.parse(val).toInt(),
          decoration: InputDecoration(
            labelText: "Enter total hours",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
        ),
        TextFormField(
          key: Key('minutes'),
          initialValue: splitData.totalMinutes.toString(),
          autocorrect: false,
          autofocus: false,
          keyboardType: TextInputType.number,
          validator: (val) =>
              val.isEmpty ? 'Time not properly filled out.' : null,
          onSaved: (val) => splitData.totalMinutes = num.parse(val).toInt(),
          decoration: InputDecoration(
            labelText: "Enter total minutes",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
        ),
        TextFormField(
          key: Key('seconds'),
          initialValue: splitData.totalSeconds.toString(),
          autocorrect: false,
          autofocus: false,
          keyboardType: TextInputType.number,
          validator: (val) =>
              val.isEmpty ? 'Time not properly filled out.' : null,
          onSaved: (val) =>
              splitData.totalSeconds = num.parse(val).toDouble() + 0.0,
          decoration: InputDecoration(
            labelText: "Enter total seconds",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
        Divider(),
      ],
    );
  }

  //Text(this.widget.splitPage.miPace + "/Mi", style: TextStyle(fontSize: 16.0)),
  //Text(this.widget.splitPage.kmPace + "/Km", style: TextStyle(fontSize: 16.0)),

  Widget paceSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(" Pace ", style: TextStyle(fontSize: 20.0)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: splitData.miPace
                      .substring(0, splitData.miPace.length - 1),
                  style: TextStyle(fontSize: 16.0),
                ),
                TextSpan(
                  text: splitData.miPace.substring(splitData.miPace.length - 1),
                  style: TextStyle(fontSize: 13.0),
                ),
                TextSpan(
                  text: "/Mi",
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: splitData.kmPace
                      .substring(0, splitData.kmPace.length - 1),
                  style: TextStyle(fontSize: 16.0),
                ),
                TextSpan(
                  text: splitData.kmPace.substring(splitData.kmPace.length - 1),
                  style: TextStyle(fontSize: 13.0),
                ),
                TextSpan(
                  text: "/Km",
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget lapSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(" Lap ", style: TextStyle(fontSize: 20.0)),
            Radio(
              onChanged: (int e) => updateLapGroupValue(e),
              activeColor: widget.themeData.accentColor,
              value: 1,
              groupValue: splitData.lapGroupValue,
            ),
            Text("Mi"),
            Radio(
              onChanged: (int e) => updateLapGroupValue(e),
              activeColor: widget.themeData.accentColor,
              value: 2,
              groupValue: splitData.lapGroupValue,
            ),
            Text("Km"),
            Radio(
              onChanged: (int e) => updateLapGroupValue(e),
              activeColor: widget.themeData.accentColor,
              value: 3,
              groupValue: splitData.lapGroupValue,
            ),
            Text("M"),
          ],
        ),
        TextFormField(
          key: Key('lap distance'),
          autocorrect: false,
          autofocus: false,
          focusNode: _focus,
          initialValue: splitData.lapDistance.toString(),
          validator: (val) => val.isEmpty || num.parse(val).toDouble() == 0.0
              ? 'Lap distance not properly filled out.'
              : null,
          onSaved: (val) =>
              splitData.lapDistance = num.parse(val).toDouble() + 0.0,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Enter lap distance",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget calculateButton() {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 30.0),
      child: RaisedButton(
          child: Text("Calculate",
              style: TextStyle(color: Colors.white, fontSize: 20.0)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0 / 2))),
          onPressed: () => calculateSplits()),
    );
  }

  void updateDistanceGroupValue(int e) {
    setState(() {
      //make unit change convert the initial value
//      print(e);
//      print("before");
//      print(this.widget.splitPage.totalDistance.toString());
//      this.widget.splitPage.totalDistance = this.widget.distance.getConvertedDistance(this.widget.splitPage.totalDistance, this.widget.splitPage.distanceGroupValue, e);
//      print("after");
//      print(this.widget.splitPage.totalDistance.toString());
      splitData.distanceGroupValue = e;
    });
  }

  void updateLapGroupValue(int e) {
    setState(() {
      splitData.lapGroupValue = e;
    });
  }

  bool validateAndSave() {
    final form = this.widget.splitPage.formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String getUnit(int unit) {
    String unitString = " ";
    switch (unit) {
      case 1:
        unitString = " Mi ";
        break;
      case 2:
        unitString = " Km ";
        break;
      case 3:
        unitString = " M ";
        break;
    }
    return unitString;
  }

  void calculateSplits() {
    if (validateAndSave()) {
      //math for pace label
      double totalTime = this.widget.time.getTotalSeconds(
          splitData.totalHours, splitData.totalMinutes, splitData.totalSeconds);
      //math for Mile Pace
      double totalMiles = this
          .widget
          .distance
          .getMiles(splitData.totalDistance, splitData.distanceGroupValue);
      double totalMiPaceSeconds = totalTime / totalMiles;
      //math for Kilometer Pace
      double totalKilometers = this
          .widget
          .distance
          .getKilometers(splitData.totalDistance, splitData.distanceGroupValue);
      double totalKmPaceSeconds = totalTime / totalKilometers;
      String kmPace = this.widget.time.formatTime(totalKmPaceSeconds, false);

      //update state of the settings menu
      this.setState(() {
        //update Mile Pace
        splitData.miPace =
            this.widget.time.formatTime(totalMiPaceSeconds, false);
        //update Kilometer Pace
        splitData.kmPace = kmPace;
        FocusScope.of(context).requestFocus(new FocusNode());
        _settingsListViewController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 800),
        );
      });

      //math for lap splits
      double convertedLapDistance = this.widget.distance.getConvertedDistance(
          splitData.totalDistance,
          splitData.distanceGroupValue,
          splitData.lapGroupValue);
      double numberLaps = convertedLapDistance / splitData.lapDistance;
      double splitTime = totalTime / numberLaps;

      //update the state of the split calculator page
      this.widget.splitPage.setState(() {
        //update total time in seconds
        splitData.totalTime = totalTime;
        //update the final string time
        splitData.finalTime =
            this.widget.time.formatTime(splitData.totalTime, false);

        //update unit of total distance
        splitData.distanceUnit = getUnit(splitData.distanceGroupValue);
        //update unit of lap distance
        splitData.lapUnit = getUnit(splitData.lapGroupValue);

        //update lap splits
        splitData.lap =
            List<int>.generate(numberLaps.toInt(), (int index) => index + 1);
        splitData.splits = List<String>.generate(numberLaps.toInt(),
            (int index) => this.widget.time.formatTime(splitTime, true));
        splitData.elapsedTime = List<String>.generate(
            numberLaps.toInt(),
            (int index) =>
                this.widget.time.formatTime(((index + 1) * splitTime), false));
        splitData.numberLaps = numberLaps;
      });

      this.widget.splitContent.setState(() {
        if (!splitData.showInitial) {
          //move list of splits to the top
          splitData.contentListViewController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 100),
          );
        }
        //update so initial message is no longer displayed
        splitData.showInitial = false;
      });
    }
  }
}
