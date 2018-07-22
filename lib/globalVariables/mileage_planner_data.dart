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

ScrollController contentListViewController = ScrollController();
ContentState mileageContentState;
