import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flut_run/pages/mileage_planner_page.dart';
import 'package:flut_run/widgets/distance.dart';
import 'package:flut_run/widgets/time.dart';
import 'package:flut_run/globalVariables/mileage_planner_data.dart'
    as mileagePlannerData;
import 'dart:async';
import 'package:flut_run/widgets/mileage_calculator.dart';

enum runType { double, workout, long, rest, race }

class MileagePlannerSettings extends StatefulWidget {
  MileagePlannerSettings(
      {this.themeData, this.mileagePage, this.time, this.distance});

  final ThemeData themeData;
  final MileagePlannerPageState mileagePage;
  final Time time;
  final Distance distance;

  @override
  MileagePlannerSettingsState createState() => MileagePlannerSettingsState();
}

class MileagePlannerSettingsState extends State<MileagePlannerSettings> {
  ScrollController _settingsListViewController = ScrollController();

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
                  key: this.widget.mileagePage.formKey,
                  child: Padding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        totalMileage(),
                        calculateButton(),
                        weekSettings(true),
                        weekSettings(false),
                        dayCheckBoxSelector("Double Runs",
                            mileagePlannerData.amRunsSelected, runType.double),
                        dayCheckBoxSelector(
                            "Workout Days",
                            mileagePlannerData.workoutRunsSelected,
                            runType.workout),
                        dayRadioSelector("Long Run", runType.long),
                        dayRadioSelector("Rest Day", runType.rest),
                        raceDayRadioSelector("Race Day", runType.race),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 130.0),
                        )
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                  ))
            ],
          )),
        ));
  }

  Widget settingsCard(Widget cardWidget) {
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Card(
        child: Container(
          width: double.infinity,
          child: Padding(padding: EdgeInsets.all(10.0), child: cardWidget),
        ),
      ),
    );
  }

  Widget totalMileage() {
    return settingsCard(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Enter total mileage",
          style: TextStyle(fontSize: 20.0),
        ),
        Divider(),
        TextFormField(
          key: Key('distance'),
          initialValue: mileagePlannerData.totalMileage.toString(),
          autocorrect: false,
          autofocus: false,
          keyboardType: TextInputType.number,
          validator: (val) => val.isEmpty || num.parse(val).round() < 0
              ? 'Total mileage not properly filled out.'
              : null,
          onSaved: (val) =>
              mileagePlannerData.totalMileage = num.parse(val).round(),
          decoration: InputDecoration(
            labelText: "Enter total mileage",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
      ],
    ));
  }

  Widget weekSettings(bool startDay) {
    return settingsCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            startDay ? "Start of Week" : "Practice Time",
            style: TextStyle(fontSize: 20.0),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Radio(
                    onChanged: (int e) => updateStartDayGroupValue(e, startDay),
                    activeColor: widget.themeData.accentColor,
                    value: 1,
                    groupValue: startDay
                        ? mileagePlannerData.startDayGroupValue
                        : mileagePlannerData.practiceTimeGroupValue,
                  ),
                  Text(
                    startDay ? "Monday" : "AM",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                    onChanged: (int e) => updateStartDayGroupValue(e, startDay),
                    activeColor: widget.themeData.accentColor,
                    value: 2,
                    groupValue: startDay
                        ? mileagePlannerData.startDayGroupValue
                        : mileagePlannerData.practiceTimeGroupValue,
                  ),
                  Text(
                    startDay ? "Sunday" : "PM",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dayCheckBoxChoice(List<bool> runSettings, int location) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: runSettings[location],
          onChanged: (val) => setState(() {
                runSettings.removeAt(location);
                runSettings.insert(location, val);
              }),
        ),
        Text(
          mileagePlannerData.days[location],
          style: TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget dayCheckBoxSelector(
      String title, List<bool> runSettings, runType run) {
    return settingsCard(
      ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0),
        ),
        leading: IconButton(
          tooltip: "More Information",
          icon: Icon(Icons.info_outline),
          onPressed: () =>
              run == runType.double ? _doubleInfo() : _workoutInfo(),
        ),
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mileagePlannerData.days.length,
              itemBuilder: (context, index) {
                return dayCheckBoxChoice(
                    runSettings, mileagePlannerData.dayOrder[index]);
              }),
        ],
      ),
    );
  }

  Widget dayRadioChoice(int location, runType run) {
    return Row(
      children: <Widget>[
        Radio(
          onChanged: (int e) => updateRadioGroupValue(e, run),
          activeColor: widget.themeData.accentColor,
          value: location,
          groupValue: run == runType.long
              ? mileagePlannerData.longRunGroupValue
              : mileagePlannerData.restDayGroupValue,
        ),
        Text(
          run == runType.long
              ? mileagePlannerData.days[location]
              : mileagePlannerData.restDays[location],
          style: TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  void updateRadioGroupValue(int e, runType run) {
    setState(() {
      if (run == runType.long) {
        mileagePlannerData.longRunGroupValue = e;
      } else if (run == runType.rest) {
        mileagePlannerData.restDayGroupValue = e;
      } else if (run == runType.race) {
        mileagePlannerData.raceDayGroupValue = e;
      }
    });
  }

  Widget dayRadioSelector(String title, runType run) {
    return settingsCard(
      ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0),
        ),
        leading: IconButton(
            tooltip: "More Information",
            icon: Icon(Icons.info_outline),
            onPressed: () => run == runType.long ? _longInfo() : _restInfo()),
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: run == runType.long
                  ? mileagePlannerData.days.length
                  : mileagePlannerData.restDays.length,
              itemBuilder: (context, index) {
                return dayRadioChoice(
                    run == runType.long
                        ? mileagePlannerData.dayOrder[index]
                        : mileagePlannerData.raceRestDayOrder[index],
                    run);
              }),
        ],
      ),
    );
  }

  Widget raceDayRadioChoice(int location, runType run) {
    return Row(
      children: <Widget>[
        Radio(
          onChanged: (int e) => updateRadioGroupValue(e, run),
          activeColor: widget.themeData.accentColor,
          value: location,
          groupValue: mileagePlannerData.raceDayGroupValue,
        ),
        Text(
          mileagePlannerData.raceDays[location],
          style: TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget raceDayRadioSelector(String title, runType run) {
    return settingsCard(
      ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0),
        ),
        leading: IconButton(
          tooltip: "More Information",
          icon: Icon(Icons.info_outline),
          onPressed: () => _raceInfo(),
        ),
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mileagePlannerData.raceDays.length,
              itemBuilder: (context, index) {
                return raceDayRadioChoice(
                    mileagePlannerData.raceRestDayOrder[index], run);
              }),
        ],
      ),
    );
  }

  Future<Null> _doubleInfo() async {
    return _alertInfo('Daily Double', [
      Text('Select what day you plan to double.'),
      Text(
          'A double is when you run twice in one day in order to spread mileage out.'),
      Text(
          'This is typically done more frequently the higher the mileage you do.'),
      Text(
          'Note that you can not do a double the same day as a Long Run or Race Day.'),
      Text(
          'Click the drop down arrow to select what days you wish to double. Other wise the default will be no doubles.'),
    ]);
  }

  Future<Null> _workoutInfo() async {
    return _alertInfo('Workout', [
      Text('Select 2 days you plan to complete a workout.'),
      Text(
          'The workout days will be slightly higher in mileage than the other normal runs.'),
      Text(
          'If you do not plan to do a workout, just select what 2 days you want to be the next highest mileage other than your long run.'),
      Text('Click the drop down arrow to get started.'),
    ]);
  }

  Future<Null> _longInfo() async {
    return _alertInfo('Long Run', [
      Text('Select what day you plan to do your long run.'),
      Text('Long run is set to Saturday by default.'),
      Text(
          'Note that the program will not allow you to double on the same day as a long run.'),
      Text('Click the drop down arrow to get started.'),
    ]);
  }

  Future<Null> _restInfo() async {
    return _alertInfo('Rest Day', [
      Text('Select what day you plan to rest.'),
      Text(
          'This is typically Sunday for most people, so Sunday is chosen by default.'),
      Text(
          'Rest means no running and cross training. Select no rest if you wish to run everyday.'),
      Text('Click the drop down arrow to get started.'),
    ]);
  }

  Future<Null> _raceInfo() async {
    return _alertInfo('Race Day', [
      Text('Select what day you plan to race.'),
      Text(
          'Note that the race day will overide any other days already selceted for the same day.'),
      Text(
          'Click the drop down arrow to select a race day. Other wise the default will be no race.'),
    ]);
  }

  Future<Null> _alertInfo(String title, List<Widget> message) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title + ' Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: message,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget calculateButton() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(height: 30.0),
        child: RaisedButton(
            child: Text("Calculate",
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0 / 2))),
            onPressed: () => calculateMileage()),
      ),
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

  void updateStartDayGroupValue(int e, bool startDay) {
    setState(() {
      startDay
          ? mileagePlannerData.startDayGroupValue = e
          : mileagePlannerData.practiceTimeGroupValue = e;
    });
    mileagePlannerData.mileageContentState.setState(() {
      if (startDay) {
        if (e == 2) {
          mileagePlannerData.dayOrder = [6, 0, 1, 2, 3, 4, 5];
          mileagePlannerData.raceRestDayOrder = [6, 0, 1, 2, 3, 4, 5, 7];
        } else {
          mileagePlannerData.dayOrder = [0, 1, 2, 3, 4, 5, 6];
          mileagePlannerData.raceRestDayOrder = [0, 1, 2, 3, 4, 5, 6, 7];
        }
      } else {
        List<int> tempRuns = mileagePlannerData.amRuns;
        if (e == 2) {
          if (mileagePlannerData.amPractice) {
            mileagePlannerData.amRuns = mileagePlannerData.pmRuns;
            mileagePlannerData.pmRuns = tempRuns;
          }
          mileagePlannerData.amPractice = false;
        } else {
          if (!mileagePlannerData.amPractice) {
            mileagePlannerData.amRuns = mileagePlannerData.pmRuns;
            mileagePlannerData.pmRuns = tempRuns;
          }
          mileagePlannerData.amPractice = true;
        }
      }
    });
  }

  void calculateMileage() {
    if (validateAndSave()) {
      //calculate total miles
      MileageCalculator calculator = MileageCalculator();

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
        calculator.planMileage();
        //todo
      });

      mileagePlannerData.mileageContentState.setState(() {
        mileagePlannerData.showInitial = false;
      });
    }
  }
}
