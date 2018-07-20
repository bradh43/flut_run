import 'package:flutter/material.dart';
import 'package:flut_run/pages/lifting_calculator_page.dart';
import 'dart:async';
import 'package:flut_run/globalVariables/lifting_calculator_data.dart'
    as liftingCalculatorData;

class LiftingCalculatorSettings extends StatefulWidget {
  LiftingCalculatorSettings({this.themeData, this.liftingPage});

  final ThemeData themeData;
  final LiftingCalculatorPageState liftingPage;

  @override
  LiftingCalculatorSettingsState createState() =>
      LiftingCalculatorSettingsState();
}

class LiftingCalculatorSettingsState extends State<LiftingCalculatorSettings> {
  ScrollController _settingsListViewController = ScrollController();

  final liftSettingsKey = GlobalKey<FormState>();

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
                Padding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //todo
                      preferredWeightSetting(),
                      clampSettings(),
                      barSettings(),
                      saveButton(),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 140.0),
                      )
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                ),
              ],
            ),
          ),
        ));
  }

  Widget preferredWeightSetting() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "Select Weights",
              style: TextStyle(fontSize: 18.0),
            ),
            Radio(
              onChanged: (int e) => updateUnitGroupValue(e),
              activeColor: widget.themeData.accentColor,
              value: 1,
              groupValue: liftingCalculatorData.unitGroupValue,
            ),
            Text("lb"),
            Radio(
              onChanged: (int e) => updateUnitGroupValue(e),
              activeColor: widget.themeData.accentColor,
              value: 2,
              groupValue: liftingCalculatorData.unitGroupValue,
            ),
            Text("kg"),
          ],
        ),
        weightChoice(0.5, 0),
        weightChoice(1.0, 1),
        weightChoice(1.25, 2),
        weightChoice(2.5, 3),
        weightChoice(5.0, 4),
        weightChoice(10.0, 5),
        weightChoice(25.0, 6),
        weightChoice(35.0, 7),
        weightChoice(45.0, 8),
      ],
    );
  }

  Widget weightChoice(double plateWeight, int location) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: liftingCalculatorData.plateSelected.elementAt(location),
          onChanged: (val) => setState(() {
                liftingCalculatorData.plateSelected.removeAt(location);
                liftingCalculatorData.plateSelected.insert(location, val);
              }),
        ),
        Text(
          plateWeight.toString() + " " + liftingCalculatorData.units,
          style: TextStyle(fontSize: 20.0),
        )
      ],
    );
  }

  void updateUnitGroupValue(int e) {
    String units;
    if (e == 1) {
      units = "lb";
    } else {
      units = "kg";
    }
    setState(() {
      liftingCalculatorData.unitGroupValue = e;
    });
    liftingCalculatorData.liftingContentState.setState(() {
      liftingCalculatorData.units = units;
    });
  }

  Widget clampSettings() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "Clamps " + liftingCalculatorData.onOff,
              style: TextStyle(fontSize: 20.0),
            ),
            Switch(
              value: liftingCalculatorData.clamsOn,
              onChanged: (val) => clampSwitch(val),
            ),
          ],
        ),
        clampChoice(0.5, 1, liftingCalculatorData.clampGroupValue),
        clampChoice(1.0, 2, liftingCalculatorData.clampGroupValue)
      ],
    );
  }

  void clampSwitch(val) {
    liftingCalculatorData.clamsOn = val;
    setState(() {
      if (val) {
        liftingCalculatorData.onOff = "On";
      } else {
        liftingCalculatorData.onOff = "Off";
      }
    });
  }

  Widget clampChoice(double clampWeight, int value, groupValue) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          onChanged: (val) => updateClampWeight(val),
          groupValue: groupValue,
        ),
        Text(
          clampWeight.toString() + " " + liftingCalculatorData.units,
          style: TextStyle(fontSize: 20.0),
        )
      ],
    );
  }

  void updateClampWeight(int val) {
    if (val == 1) {
      liftingCalculatorData.clampWeight = 0.5;
    } else {
      liftingCalculatorData.clampWeight = 1.0;
    }
    setState(() {
      liftingCalculatorData.clampGroupValue = val;
    });
  }

  Widget barSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Enter Weight of Bar:",
          style: TextStyle(fontSize: 20.0),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Form(
            key: liftSettingsKey,
            child: TextFormField(
              key: Key('bar'),
              initialValue: liftingCalculatorData.barWeight.toString(),
              autocorrect: false,
              autofocus: false,
              keyboardType: TextInputType.number,
              validator: (val) =>
                  val.isEmpty || num.parse(val).toDouble() == 0.0
                      ? 'Bar Weight not properly filled out.'
                      : null,
              onSaved: (val) => liftingCalculatorData.barWeight =
                  num.parse(val).toDouble() + 0.0,
              decoration: InputDecoration(
                labelText: "Bar Weight in " + liftingCalculatorData.units,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget saveButton() {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 30.0),
      child: RaisedButton(
        child:
            Text("Save", style: TextStyle(color: Colors.white, fontSize: 20.0)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0 / 2))),
        onPressed: () => save(),
      ),
    );
  }

  void save() {
    //validate and save the weight of the bar
    if (liftSettingsKey.currentState.validate()) {
      liftSettingsKey.currentState.save();
    }
    liftingCalculatorData.showInitial = false;
    //dismiss the keyboard
    FocusScope.of(context).requestFocus(new FocusNode());
    //animate to the top of the settings menu
    _settingsListViewController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
    );
    Timer(Duration(milliseconds: 800), () => Navigator.pop(context));

  }
}
