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
  TextEditingController textController = new TextEditingController();
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
                Padding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: liftingCalculatorData.plates.length,
            itemBuilder: (context, index){
              return weightChoice(liftingCalculatorData.plates[index], index);
            }
        ),
      ],
    );
  }

  Widget weightChoice(double plateWeight, int location) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: liftingCalculatorData.plateSelected[location],
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
    setState(() {
      if (e == 1) {
        units = "lb";
        liftingCalculatorData.plates = liftingCalculatorData.lbPlates;
        liftingCalculatorData.plateSelected = liftingCalculatorData.lbPlateSelected;
        liftingCalculatorData.barWeight = liftingCalculatorData.lbBarWeight;
        textController.text = liftingCalculatorData.barWeight.toString();
      } else {
        units = "kg";
        liftingCalculatorData.plates = liftingCalculatorData.kgPlates;
        liftingCalculatorData.plateSelected = liftingCalculatorData.kgPlateSelected;
        liftingCalculatorData.barWeight = liftingCalculatorData.kgBarWeight;
        textController.text = liftingCalculatorData.barWeight.toString();

      }
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
        clampChoice(liftingCalculatorData.units == "lb" ? 0.5 : 0.25, 1, liftingCalculatorData.clampGroupValue),
        clampChoice(liftingCalculatorData.units == "lb" ? 1.0 : 0.5, 2, liftingCalculatorData.clampGroupValue),
        clampChoice(2.5, 3, liftingCalculatorData.clampGroupValue),
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
      liftingCalculatorData.clampWeight = liftingCalculatorData.units == "lb" ? 0.5 : 0.25;
    } else if(val == 2){
      liftingCalculatorData.clampWeight = liftingCalculatorData.units == "lb" ? 1.0 : 0.5;
    } else {
      liftingCalculatorData.clampWeight = 2.5;
    }
    setState(() {
      liftingCalculatorData.clampGroupValue = val;
    });
  }

  Widget barSettings() {
    textController.text = liftingCalculatorData.barWeight.toString();
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
              controller: textController,
              //initialValue: liftingCalculatorData.barWeight.toString(),
              autocorrect: false,
              autofocus: false,
              focusNode: _focus,
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
