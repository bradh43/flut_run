import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flut_run/widgets/hamburger_menu.dart';
import 'package:flut_run/widgets/lifting_calculator_settings.dart';
import 'package:flut_run/overlays/feature_discovery.dart';
import 'dart:async';
import 'package:flut_run/globalVariables/lifting_calculator_data.dart'
    as liftingCalculatorData;

import 'package:flut_run/widgets/main_logo_image.dart';

LiftingCalculatorPageState liftingPageState;
final liftingFeature = "LIFTING_FEATURE";

class LiftingCalculatorPage extends StatefulWidget {
  LiftingCalculatorPage({this.themeData});

  final themeData;

  @override
  LiftingCalculatorPageState createState() =>
      liftingPageState = LiftingCalculatorPageState();
}

class LiftingCalculatorPageState extends State<LiftingCalculatorPage> {

  //initializing setting variables
  Content liftingContent = Content();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: Theme(
        data: widget.themeData,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Lifting Calculator"),
            actions: <Widget>[liftingSettings(widget.themeData)],
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
          drawer: HamburgerMenu(
            currentTab: 6,
            themeData: widget.themeData,
          ),
          endDrawer: LiftingCalculatorSettings(
              themeData: widget.themeData, liftingPage: liftingPageState),
          body: liftingContent,
        ),
      ),
    );
  }

  Widget liftingSettings(ThemeData themeData) {
    return DescribedFeatureOverlay(
      featureId: liftingFeature,
      icon: Icons.settings,
      color: themeData.primaryColor,
      title: 'Lifting Calculator',
      description: 'Tap the settings icon to edit the default weight settings.',
      action: () => settingsAction(),
      child: IconButton(
        tooltip: "Settings",
        icon: Icon(Icons.settings),
        onPressed: () => settingsAction(),
      ),
    );
  }

  void settingsAction(){
    _scaffoldKey.currentState.openEndDrawer();
    liftingCalculatorData.showInitial = false;
  }

}


class Content extends StatefulWidget {
  @override
  ContentState createState() =>
      liftingCalculatorData.liftingContentState = ContentState();
}

class ContentState extends State<Content> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (liftingCalculatorData.showInitial) {
      Timer(Duration(milliseconds: 2300),() => showFeature());
    }
    return liftingBody();
  }

  void showFeature(){
    if(liftingCalculatorData.showInitial){
      FeatureDiscovery.discoverFeatures(context, [liftingFeature]);
    }
  }

  Widget liftingBody() {
    //fetch main logo
    MainLogoImage mainLogo = MainLogoImage();

    return Stack(
      children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Scrollbar(
              child: ListView(
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50.0),
                              child: mainLogo.getImage(),
                            ),
                            totalWeightForm(),
                            calculateButton(),
                            results(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        )
      ],
    );
  }

  Widget totalWeightForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Enter total weight you wish to lift in " +
              liftingCalculatorData.units +
              ":",
          style: TextStyle(fontSize: 18.0),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
            key: Key('lifting'),
            initialValue: liftingCalculatorData.totalWeight.toString(),
            autocorrect: false,
            autofocus: false,
            keyboardType: TextInputType.number,
            validator: (val) => val.isEmpty || num.parse(val).toDouble() == 0.0
                ? 'Total Weight not properly filled out.'
                : null,
            onSaved: (val) => liftingCalculatorData.totalWeight =
                num.parse(val).toDouble() + 0.0,
            decoration: InputDecoration(
              labelText: "Enter total weight",
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
        )
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
        onPressed: () => calculateLift(),
      ),
    );
  }

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void calculateLift() {
    if (validateAndSave()) {
      //Dismiss the keyboard
      FocusScope.of(context).requestFocus(new FocusNode());

      //reset previous weights
      liftingCalculatorData.weightsNeeded = [];
      liftingCalculatorData.numberOfWeights = [];

      //figure out how much initial weight is on the bar
      double initialWeight = liftingCalculatorData.barWeight;
      //add weight if the clamps are on
      if (liftingCalculatorData.clamsOn) {
        initialWeight += 2 * liftingCalculatorData.clampWeight;
      }

      //find the smallest weight
      bool smallWeightFoundFlag = false;
      int smallWeightLocation = 0;
      while(!smallWeightFoundFlag && smallWeightLocation <= liftingCalculatorData.plates.length-1){
        if(liftingCalculatorData.plateSelected[smallWeightLocation]){
          smallWeightFoundFlag = true;
        } else {
          smallWeightLocation++;
        }
      }

      //check if enough weight was entered
      setState(() {
        if (liftingCalculatorData.totalWeight < initialWeight) {
          liftingCalculatorData.resultMessage =
              "Not enough weight was entered, please enter more than " +
                  initialWeight.toString() +
                  " " +
                  liftingCalculatorData.units;
          liftingCalculatorData.validWeight = false;
        } else if (liftingCalculatorData.totalWeight == initialWeight) {
          liftingCalculatorData.resultMessage =
              "No additional weight is required to place on either side.";
          liftingCalculatorData.validWeight = false;
        } else {
          liftingCalculatorData.resultMessage = "Place on each side:";
          liftingCalculatorData.validWeight = true;
        }
      });

      //calculate how much should go on each side
      if (liftingCalculatorData.validWeight) {
        double weightRemaining =
            liftingCalculatorData.totalWeight - initialWeight;
        //cycle through all the plates
        for (int i = liftingCalculatorData.plates.length - 1; i >= 0; i--) {
          //if a weight is chosen see how many plates of that weight are needed on each side
          if (liftingCalculatorData.plateSelected[i]) {
            //check if possible to use plate
            if (weightRemaining >= 2 * liftingCalculatorData.plates[i]) {
              //add weight to the list of needed plates
              liftingCalculatorData.weightsNeeded
                  .add(liftingCalculatorData.plates[i]);
              int numberPlates = 0;
              //check how many plates can be used
              while (weightRemaining >= 2 * liftingCalculatorData.plates[i]) {
                weightRemaining -= 2 * liftingCalculatorData.plates[i];
                numberPlates++;
              }
              //update the number of plates needed for specific weight of plate
              liftingCalculatorData.numberOfWeights.add(numberPlates);
            }
          }
        }
        //check if there is still weight remaining
        if (weightRemaining != 0.0) {
          //check to see if the smallest weight can go into the total weight
          if(liftingCalculatorData.totalWeight % (2*liftingCalculatorData.plates[smallWeightLocation]) == 0){
            //todo
            print("More can be done. Try taking away 1 plate of the biggest weight and adding smallest plate");
          }else{
            double newWeight =
                liftingCalculatorData.totalWeight - weightRemaining;
            setState(() {
              liftingCalculatorData.totalWeight = newWeight;
              liftingCalculatorData.resultMessage =
                  "Weight entered is too specific with the given plates available. Changed to " +
                      newWeight.toString() +
                      " " +
                      liftingCalculatorData.units;
            });
          }
          }
      }
    }
  }

  Widget results() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(
            liftingCalculatorData.resultMessage,
            style: TextStyle(fontSize: 24.0),
          ),
          weightsNeeded(),
        ],
      ),
    );
  }

  Widget weightsNeeded() {
    if (liftingCalculatorData.validWeight) {
      return Container(
        child: ListView.builder(
            controller: liftingCalculatorData.contentListViewController,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            itemCount: liftingCalculatorData.weightsNeeded.length,
            itemBuilder: (context, index) {
              return Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: listWeight(
                          liftingCalculatorData.numberOfWeights[index],
                          liftingCalculatorData.weightsNeeded[index]),
                    ),
                  ],
                ),
              );
            }),
      );
    } else {
      return Text("");
    }
  }

  Widget listWeight(int numberOfWeights, double weight) {
    return Text(
      numberOfWeights.toString() +
          " X " +
          weight.toString() +
          " " +
          liftingCalculatorData.units,
      style: TextStyle(fontSize: 20.0),
    );
  }
}
