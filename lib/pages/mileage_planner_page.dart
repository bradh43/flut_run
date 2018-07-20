import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flut_run/widgets/hamburger_menu.dart';
import 'package:flut_run/widgets/mileage_planner_settings.dart';
import 'package:flut_run/overlays/feature_discovery.dart';
import 'package:flut_run/globalVariables/mileage_planner_data.dart' as mileagePlannerData;
import 'package:flut_run/widgets/distance.dart';
import 'package:flut_run/widgets/main_logo_image.dart';

MileagePlannerPageState mileagePageState;
final mileageFeature = "MILEAGE_FEATURE";


class MileagePlannerPage extends StatefulWidget {
  MileagePlannerPage({this.themeData});

  final themeData;

  @override
  MileagePlannerPageState createState() =>
      mileagePageState = MileagePlannerPageState();
}

class MileagePlannerPageState extends State<MileagePlannerPage> {
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
            title: Text("Mileage Planner"),
            actions: <Widget>[
              mileageSettings(widget.themeData)
            ],
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
          drawer: HamburgerMenu(
            currentTab: 1,
            themeData: widget.themeData,
          ),
          endDrawer: MileagePlannerSettings(
              themeData: widget.themeData,
              mileagePage: mileagePageState,
              time: mileagePlannerData.time,
              distance: mileagePlannerData.distance),

          bottomNavigationBar: Material(
            elevation: 10.0,
            color: widget.themeData.primaryColor,
            child: Padding(padding: EdgeInsets.all(10.0), child: bottomText()),
          ),
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
        ),
      ),
    );
  }

  Widget mileageSettings(ThemeData themeData){
    return DescribedFeatureOverlay(
      featureId: mileageFeature,
      icon: Icons.settings,
      color: themeData.primaryColor,
      title: 'Mileage Planner',
      description: 'Tap the settings icon to start planning miles and change the settings.',
      action: () => _scaffoldKey.currentState.openEndDrawer(),
      child: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
      ),
    );
  }


  Widget bottomText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text("Total Distance: ", style: TextStyle(fontSize: 32.0)),
        Text(mileagePlannerData.totalMileage.toString(), style: TextStyle(fontSize: 32.0)),
      ],
    );
  }
}

class Content extends StatefulWidget {

  @override
  ContentState createState() =>  mileagePlannerData.mileageContentState = ContentState();
}

class ContentState extends State<Content> {

  @override
  Widget build(BuildContext context) {

    return mainBody(mileagePlannerData.showInitial);
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
                      Text(mileagePlannerData.initialMessage, style: TextStyle(fontSize: 24.0),),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      RaisedButton(
                        child: new Text(' Learn More '),
                        onPressed: () {
                          FeatureDiscovery.discoverFeatures(context, [mileageFeature]);
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
        controller: mileagePlannerData.contentListViewController,
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