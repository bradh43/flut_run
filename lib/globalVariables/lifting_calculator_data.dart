library flut_run.globals;

import 'package:flutter/material.dart';
import 'package:flut_run/pages/lifting_calculator_page.dart';

bool showInitial = true;
String initialMessage = "Click on the settings icon to get started.";
String settingsHint =
    "You can enter your goal time for a given race distance and get your splits for a specified lap length.";
String resultMessage = "";
bool validWeight = false;

//initialize variables
double totalWeight = 0.0;
String units = "lb";
List<double> plates = [0.5, 1.0, 1.25, 2.5, 5.0, 10.0, 25.0, 35.0, 45.0];
List<bool> plateSelected = [
  false,
  false,
  true,
  true,
  true,
  true,
  true,
  false,
  true
];
bool clamsOn = false;
double clampWeight = 0.5;
double barWeight = 45.0;
List<double> weightsNeeded = [];
List<int> numberOfWeights = [];

int unitGroupValue = 1;
String onOff = "Off";
int clampGroupValue = 1;

ScrollController contentListViewController = ScrollController();
ContentState liftingContentState;
