import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flut_run/pages/mileage_planner_page.dart';
import 'package:flut_run/widgets/distance.dart';
import 'package:flut_run/widgets/time.dart';
import 'package:flut_run/globalVariables/mileage_planner_data.dart' as mileagePlannerData;


class MileagePlannerSettings extends StatefulWidget {
  MileagePlannerSettings(
      {this.themeData,
        this.mileagePage,
        this.time,
        this.distance});

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
                         //todo
                         totalMileage(),
                         calculateButton(),
                         startWeek(),
                         dayCheckBoxSelector("Select Moring Runs", mileagePlannerData.amRunsSelected),
                         dayCheckBoxSelector("Select 2 Workout Days", mileagePlannerData.workoutRunsSelected),
                         dayRadioSelector("Select Long Run", 1),
                         dayRadioSelector("Select Rest Day", 2),
                         //todo
                         //need to make separate unique setting for race day
                         dayCheckBoxSelector("Select Race Day", mileagePlannerData.workoutRunsSelected),

                         Padding(
                           padding: EdgeInsets.symmetric(vertical: 130.0),
                         )
                       ],
                     ),
                     padding: EdgeInsets.symmetric(horizontal: 4.0),
                   ))
             ],
           )
           ),
        )
    );
  }


  Widget settingsCard(Widget cardWidget){
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Card(
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: cardWidget
          ),
        ),
      ),
    );
  }

  Widget totalMileage(){
    return settingsCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Enter total mileage", style: TextStyle(fontSize: 20.0),),
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
            onSaved: (val) => mileagePlannerData.totalMileage = num.parse(val).round(),
            decoration: InputDecoration(
              labelText: "Enter total mileage",
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
        ],
      )
    );
  }

  Widget startWeek(){
    return settingsCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Start of Week", style: TextStyle(fontSize: 20.0),),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
             Row(
               children: <Widget>[
                 Radio(
                   onChanged: (int e) => updateStartDayGroupValue(e),
                   activeColor: widget.themeData.accentColor,
                   value: 1,
                   groupValue: mileagePlannerData.startDayGroupValue,
                 ),
                 Text("Monday", style: TextStyle(fontSize: 18.0),),
               ],
             ),
              Row(
                children: <Widget>[
                  Radio(
                    onChanged: (int e) => updateStartDayGroupValue(e),
                    activeColor: widget.themeData.accentColor,
                    value: 2,
                    groupValue: mileagePlannerData.startDayGroupValue,
                  ),
                  Text("Sunday", style: TextStyle(fontSize: 18.0),),
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
        Text(mileagePlannerData.days[location], style: TextStyle(fontSize: 16.0),)
      ],
    );
  }


  Widget dayCheckBoxSelector(String title, List<bool> runSettings){
    return settingsCard(
      ExpansionTile(
        title: Text(title, style: TextStyle(fontSize: 18.0),),
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mileagePlannerData.days.length,
              itemBuilder: (context, index){
                return dayCheckBoxChoice(runSettings, mileagePlannerData.dayOrder[index]);
              }
          ),
        ],
      ),
    );
  }

  Widget dayRadioChoice(int location, int groupType) {
    return Row(
      children: <Widget>[
        Radio(
          onChanged: (int e) => updateRadioGroupValue(e, groupType),
          activeColor: widget.themeData.accentColor,
          value: location,
          groupValue: groupType == 1 ? mileagePlannerData.longRunGroupValue : mileagePlannerData.restDayGroupValue,
        ),
        Text(mileagePlannerData.days[location], style: TextStyle(fontSize: 16.0),)
      ],
    );
  }

  void updateRadioGroupValue(int e, int groupType){
    setState(() {
      if(groupType == 1){
        mileagePlannerData.longRunGroupValue = e;
      } else if(groupType == 2){
        mileagePlannerData.restDayGroupValue = e;
      }
    });
  }


  Widget dayRadioSelector(String title, int groupType){
    return settingsCard(
      ExpansionTile(
        title: Text(title, style: TextStyle(fontSize: 18.0),),
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: mileagePlannerData.days.length,
              itemBuilder: (context, index){
                return dayRadioChoice(mileagePlannerData.dayOrder[index], groupType);
              }
          ),
        ],
      ),
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

  void updateStartDayGroupValue(int e) {
    setState(() {
      mileagePlannerData.startDayGroupValue = e;
    });
    mileagePlannerData.mileageContentState.setState((){
      if(e == 2){
        mileagePlannerData.dayOrder = [6,0,1,2,3,4,5];
      } else {
        mileagePlannerData.dayOrder = [0,1,2,3,4,5,6];
      }
    });
  }

  void calculateMileage() {
    if (validateAndSave()) {
      //calculate total miles
      //todo

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

      mileagePlannerData.mileageContentState.setState((){
        mileagePlannerData.showInitial = false;
      });
    }
  }


}