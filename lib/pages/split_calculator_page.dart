import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flut_run/widgets/hamburger_menu.dart';
import 'package:flut_run/widgets/split_calculator_settings.dart';
import 'package:flut_run/overlays/feature_discovery.dart';
import 'package:flut_run/widgets/main_logo_image.dart';
import 'package:flut_run/globalVariables/split_data.dart' as splitData;

SplitCalculatorPageState splitPageState;
ContentState splitContentState;
final splitFeature = "SPLIT_FEATURE";

class SplitCalculatorPage extends StatefulWidget {
  SplitCalculatorPage({this.themeData});

  final themeData;

  @override
  SplitCalculatorPageState createState() =>
      splitPageState = SplitCalculatorPageState();
}

class SplitCalculatorPageState extends State<SplitCalculatorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //initializing setting variables
  final formKey = GlobalKey<FormState>();
  MainLogoImage mainLogo = MainLogoImage();

  Content splitContent = Content();

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: Theme(
        data: widget.themeData,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Split Calculator"),
            actions: <Widget>[splitSettings(widget.themeData)],
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
          drawer: HamburgerMenu(
            currentTab: 3,
            themeData: widget.themeData,
          ),
          endDrawer: SplitCalculatorSettings(
              themeData: widget.themeData,
              splitContent: splitContentState,
              splitPage: splitPageState,
              time: splitData.time,
              distance: splitData.distance),
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
            child: splitContent,
          ),
        ),
      ),
    );
  }

  Widget splitSettings(ThemeData themeData) {
    return DescribedFeatureOverlay(
      featureId: splitFeature,
      icon: Icons.settings,
      color: themeData.primaryColor,
      title: 'Split Calculator',
      description: 'Tap the settings icon to get started & change settings.',
      action: () => _scaffoldKey.currentState.openEndDrawer(),
      child: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
      ),
    );
  }

  Widget bottomText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(splitData.totalDistance.toString() + splitData.distanceUnit,
            style: TextStyle(fontSize: 32.0)),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: splitData.finalTime
                    .substring(0, splitData.finalTime.length - 1),
                style: TextStyle(fontSize: 32.0),
              ),
              TextSpan(
                text: splitData.finalTime
                    .substring(splitData.finalTime.length - 1),
                style: TextStyle(fontSize: 24.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Content extends StatefulWidget {
  @override
  ContentState createState() => splitContentState = ContentState();
}

class ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return mainBody(splitData.showInitial);
  }

  Widget mainBody(bool showInitialBody) {
    if (showInitialBody) {
      return initialBody();
    } else {
      return splitBody();
    }
  }

  Widget initialBody() {
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
                      Text(
                        splitData.initialMessage,
                        style: TextStyle(fontSize: 24.0),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      RaisedButton(
                        child: new Text(' Learn More '),
                        onPressed: () {
                          FeatureDiscovery
                              .discoverFeatures(context, [splitFeature]);
                        },
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget splitBody() {
    return Scrollbar(
      child: ListView.builder(
          controller: splitData.contentListViewController,
          padding: EdgeInsets.all(10.0),
          itemCount: splitData.splits.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${splitData.lapDistance.toInt()*splitData.lap[index]}' +
                              splitData.lapUnit,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: splitData.elapsedTime[index].substring(
                                    0, splitData.elapsedTime[index].length - 1),
                                style: TextStyle(fontSize: 32.0),
                              ),
                              TextSpan(
                                text: splitData.elapsedTime[index].substring(
                                    splitData.elapsedTime[index].length - 1),
                                style: TextStyle(fontSize: 24.0),
                              ),
                            ],
                          ),
                        ),
                        //Text("${elapsedTime[index]}", style: TextStyle(fontSize: 32.0)),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Lap ${splitData.lap[index]}',
                                style: TextStyle(fontSize: 18.0)),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: splitData.splits[index].substring(
                                        0, splitData.splits[index].length - 1),
                                    style: TextStyle(fontSize: 32.0),
                                  ),
                                  TextSpan(
                                    text: splitData.splits[index].substring(
                                        splitData.splits[index].length - 1),
                                    style: TextStyle(fontSize: 24.0),
                                  ),
                                ],
                              ),
                            ),
                            //Text(' ${splits[index]} ', style: TextStyle(fontSize: 32.0)),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.add_circle),
                                iconSize: 25.0,
                                onPressed: () => incrementSplit(index)),
                            IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                iconSize: 25.0,
                                onPressed: () => decrementSplit(index)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
              ]),
            );
          }),
    );
  }

  void incrementSplit(int i) {
    setState(() {
      //add 1 second to to split time
      double splitTime = splitData.time.formatTotalSeconds(splitData.splits[i]);
      splitData.splits[i] =
          splitData.time.formatTime(splitTime + splitData.deltaLap, true);
      //update the rest of the elapsed time
      for (int j = i; j < splitData.numberLaps.toInt(); j++) {
        splitData.elapsedTime[j] = splitData.time.formatTime(
            splitData.time.formatTotalSeconds(splitData.elapsedTime[j]) +
                splitData.deltaLap,
            false);
      }
    });

    splitPageState.setState(() {
      //update the final time
      splitData.finalTime = splitData.time.formatTime(
          splitData.time.formatTotalSeconds(splitData.finalTime) +
              splitData.deltaLap,
          false);
    });
  }

  void decrementSplit(int i) {
    setState(() {
      //add 1 second to to split time
      double splitTime = splitData.time.formatTotalSeconds(splitData.splits[i]);
      splitData.splits[i] =
          splitData.time.formatTime(splitTime - splitData.deltaLap, true);
      //update the rest of the elapsed time
      for (int j = i; j < splitData.numberLaps.toInt(); j++) {
        splitData.elapsedTime[j] = splitData.time.formatTime(
            splitData.time.formatTotalSeconds(splitData.elapsedTime[j]) -
                splitData.deltaLap,
            false);
      }
    });

    splitPageState.setState(() {
      //update the final time
      splitData.finalTime = splitData.time.formatTime(
          splitData.time.formatTotalSeconds(splitData.finalTime) -
              splitData.deltaLap,
          false);
    });
  }
}
