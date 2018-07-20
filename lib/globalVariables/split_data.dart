library flut_run.globals;

import 'package:flut_run/widgets/time.dart';
import 'package:flut_run/widgets/distance.dart';
import 'package:flutter/material.dart';

bool showInitial = true;
double totalDistance = 0.0;
Time time = Time();
String finalTime = time.formatTime(0.0, false);
String distanceUnit = " M ";
final splitFeature = "SPLIT_FEATURE";

double deltaLap = 1.0;

Distance distance = Distance();


int totalHours = 0;
int totalMinutes = 0;
double totalSeconds = 0.0;
double lapDistance = 400.0;

String miPace = "0:00.0";
String kmPace = "0:00.0";
int distanceGroupValue = 1;
int lapGroupValue = 1;


String lapUnit = " M ";

double totalTime = 0.0;
double numberLaps = 0.0;
double splitTime = 0.0;

String initialMessage = "Click on the settings icon to get started.";
String settingsHint = "You can enter your goal time for a given race distance and get your splits for a specified lap length.";






List<int> lap = List<int>.generate(0, (int index) => index + 1);
List<String> splits = List<String>.generate(0, (int index) => time.formatTime(0.0, true));

List<String> elapsedTime = List<String>.generate(
0, (int index) => time.formatTime(((index + 1) * 0.0), false));

ScrollController contentListViewController = ScrollController();