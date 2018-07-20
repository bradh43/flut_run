import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flut_run/widgets/hamburger_menu.dart';
import 'package:flut_run/widgets/mileage_log_settings.dart';
import 'package:flut_run/overlays/feature_discovery.dart';
import 'package:flut_run/globalVariables/mileage_log_data.dart' as mileageLogData;
import 'package:flut_run/widgets/distance.dart';
import 'package:flut_run/widgets/main_logo_image.dart';

MileageLogPageState mileagePageState;
final mileageFeature = "MILEAGE_FEATURE";
final addFeature = "ADD_FEATURE";
final todayFeature = "TODAY_FEATURE";


class MileageLogPage extends StatefulWidget {
  MileageLogPage({this.themeData});

  final themeData;

  @override
  MileageLogPageState createState() =>
      mileagePageState = MileageLogPageState();
}

class MileageLogPageState extends State<MileageLogPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //initializing setting variables
  final formKey = GlobalKey<FormState>();
  MainLogoImage mainLogo = MainLogoImage();

  Content mileageContent = Content();


  @override
  Widget build(BuildContext context) {

    return FeatureDiscovery(
      child: Theme(
        data: widget.themeData,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Center(child: Text("Mileage Log")),
            actions: <Widget>[
              currentDay(widget.themeData),
              mileageSettings(widget.themeData)
            ],
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
          drawer: HamburgerMenu(
            currentTab: 2,
            themeData: widget.themeData,
          ),
          endDrawer: MileageLogSettings(
              themeData: widget.themeData,
              mileagePage: mileagePageState,
              time: mileageLogData.time,
              distance: mileageLogData.distance),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(mainLogo.imagePath),
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.75), BlendMode.srcATop),
                fit: BoxFit.contain,
              ),
            ),
            child: mileageContent,
          ),
          floatingActionButton: addWorkout(widget.themeData),
        ),
      ),
    );
  }

  Widget currentDay(ThemeData themeData){
    return DescribedFeatureOverlay(
      featureId: todayFeature,
      icon: Icons.calendar_today,
      color: themeData.primaryColor,
      title: 'Current Day',
      description: 'Tap the calendar icon to return back to the current day.',
      //action: () => _scaffoldKey.currentState.openEndDrawer(),
      action: () => null,
      child: IconButton(
        icon: Icon(Icons.today),
        //todo
        onPressed: () => null,
      ),
    );
  }

  Widget addWorkout(ThemeData themeData){
    return DescribedFeatureOverlay(
      featureId: addFeature,
      icon: Icons.add,
      color: themeData.primaryColor,
      title: 'Add Workout',
      description: 'Tap the plus icon to add workouts to the calendar.',
      action: () => null,
      child: FloatingActionButton(onPressed: () => null, child: Icon(Icons.add),),
    );
  }

  Widget mileageSettings(ThemeData themeData){
    return DescribedFeatureOverlay(
      featureId: mileageFeature,
      icon: Icons.settings,
      color: themeData.primaryColor,
      title: 'Calendar Settings',
      description: 'Tap the settings icon edit and change the calendar the settings.',
      //action: () => _scaffoldKey.currentState.openEndDrawer(),
      action: () => null,
      child: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
      ),
    );
  }
  
}

class Content extends StatefulWidget {

  @override
  ContentState createState() =>  mileageLogData.mileageContentState = ContentState();
}

class ContentState extends State<Content> {

  @override
  Widget build(BuildContext context) {

    return mainBody(mileageLogData.showInitial);
  }

  Widget mainBody(bool showInitialBody){
    if(showInitialBody){
      return initialBody();
    } else {
      return mileageBody();
    }
  }

  Widget initialBody(){
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(1.0),
          child: Container(
            width: double.infinity,
            child: Card(
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text(mileageLogData.initialMessage, style: TextStyle(fontSize: 24.0),),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      RaisedButton(
                        child: new Text(' Learn More '),
                        onPressed: () {
                          FeatureDiscovery.discoverFeatures(context, [todayFeature, mileageFeature, addFeature]);
                        },
                      ),
                    ],
                  )
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget mileageBody(){
    return Scrollbar(
        child: ListView(
          controller: mileageLogData.contentListViewController,
          children: <Widget>[
            day("Monday"),
            day("Tuesday"),
            day("Wednesday"),
            day("Thursday"),
            day("Friday"),
            day("Saturday"),
            day("Sunday"),
          ],
        )
    );
  }


  Widget day(String day){
    return Opacity(
      opacity: 0.90,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              child: Text(day, style: TextStyle(fontSize: 28.0)),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text("AM", style: TextStyle(fontSize: 20.0)),
                        Text("4 Mi", style: TextStyle(fontSize: 24.0)),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.add_circle),
                            iconSize: 25.0,
                            onPressed: () => incrementMileage(4256)),
                        IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            iconSize: 25.0,
                            onPressed: () => decrementMileage(3289)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text("PM", style: TextStyle(fontSize: 20.0)),
                        Text("9 Mi", style: TextStyle(fontSize: 24.0)),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.add_circle),
                            iconSize: 25.0,
                            onPressed: () => incrementMileage(4256)),
                        IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            iconSize: 25.0,
                            onPressed: () => decrementMileage(3289)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void incrementMileage(int i) {
    //todo
  }

  void decrementMileage(int i) {
    //todo
  }

}