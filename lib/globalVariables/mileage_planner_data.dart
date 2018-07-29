library flut_run.globals;

import 'package:flut_run/widgets/time.dart';
import 'package:flut_run/widgets/distance.dart';
import 'package:flutter/material.dart';
import 'package:flut_run/pages/mileage_planner_page.dart';

bool showInitial = true;
String initialMessage = "Click on the settings icon to get started.";
String settingsHint = "You can enter your goal time for a given race distance and get your splits for a specified lap length.";

Time time = Time();
Distance distance = Distance();

int totalMileage = 0;
List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
List<int> amRuns = [4,3,4,2,4,0,0];
List<bool> amRunsSelected = [false, false, false, false, false, false, false];
List<bool> workoutRunsSelected = [true, false, true, false, false, false, false];
List<int> pmRuns = [9,7,8,7,6,12,5];
List<int> dayOrder = [0,1,2,3,4,5,6];
List<int> runOrder = [0,1,2,3,4,5,6];
int startDayGroupValue = 1;
int longRunGroupValue = 5;
int restDayGroupValue = 6;
int raceDayGroupValue = 5;

ScrollController contentListViewController = ScrollController();
ContentState mileageContentState;
