import 'package:flut_run/globalVariables/mileage_planner_data.dart' as mileageSettingsData;

class MileageCalculator{

  int raceMiles = 0;

  void planMileage(){
    //call helper methods in order of priority
    //todo
    planRaceDay();
    planRestDay();
    planLongRun(mileageSettingsData.totalMileage);
    calculateMileage(mileageSettingsData.totalMileage);
    print("---------------------------");
    print(mileageSettingsData.amPercent);
    print(mileageSettingsData.pmPercent);

  }

  void planRaceDay(){
    raceMiles = 0;
    //plan how far to run for warm up and cool down, disable long run
    //todo
    //check how many miles the race is a race day is selected
    if(mileageSettingsData.raceDayGroupValue != 7){
      raceMiles = getRaceMiles().round();
      //check to make sure there is enough mileage for the race selected
      if(raceMiles > mileageSettingsData.totalMileage){
        mileageSettingsData.mileageContentState.setState((){
          mileageSettingsData.totalMileage = raceMiles+2;
        });
        mileageSettingsData.coolDown = 1;
        mileageSettingsData.warmUp = 1;
      } else {
        mileageSettingsData.warmUp = planWarmUp(mileageSettingsData.totalMileage);
        mileageSettingsData.coolDown = planCoolDown(mileageSettingsData.totalMileage);

      }
    }


  }

  int planWarmUp(int totalMiles){
    int warmUp;
    if(totalMiles >= 80){
      warmUp = 3;
    } else if(totalMiles >= 40){
      warmUp = 2;
    } else {
      warmUp = 1;
    }
    return warmUp;
  }

  int planCoolDown(int totalMiles){
    int coolDown;
    if(totalMiles >= 80){
      coolDown = 5;
    } else if(totalMiles >= 70){
      coolDown = 4;
    } else if(totalMiles >= 60){
      coolDown = 3;
    } else if(totalMiles >= 50){
      coolDown = 2;
    } else {
      coolDown = 1;
    }
    return coolDown;
  }


  double getRaceMiles(){

    //determine how many miles the race is
    bool flag = false;
    int i = 0;
    while(!flag){
      i++;
      if(mileageSettingsData.currentRace[i] == " "){
        flag = true;
      }
    }

    double raceDist = double.tryParse(mileageSettingsData.currentRace.substring(0, i));
    //convert race distance to miles
    switch(mileageSettingsData.currentRace.substring(i+1, mileageSettingsData.currentRace.length)){
      case "M":
        raceDist = mileageSettingsData.distance.getConvertedDistance(raceDist, 3, 1);
        break;
      case "Km":
        raceDist = mileageSettingsData.distance.getConvertedDistance(raceDist, 2, 1);
        break;
      case "Mi":
        break;
    }
    return raceDist;
  }

  void planRestDay(){
    //determine which day the rest day is if not selected, else run 0
    if(mileageSettingsData.restDayGroupValue == 7){
      //no rest selected, determine which day is suppose to be the rest day
      print("no rest");
    } else {
      //rest day selected, run 0
      mileageSettingsData.pmPercent[mileageSettingsData.restDayGroupValue] = 0.0;
    }


  }

  void planLongRun(int totalMiles){
    //check to make sure not race day
    if(mileageSettingsData.raceDayGroupValue != mileageSettingsData.longRunGroupValue){
      //determine how far to run for the long run
      if(totalMiles >= 80){
        mileageSettingsData.pmPercent[mileageSettingsData.longRunGroupValue] = 0.20;
      } else if(totalMiles <= 45){
        mileageSettingsData.pmPercent[mileageSettingsData.longRunGroupValue] = 0.25;
      } else {
        mileageSettingsData.pmPercent[mileageSettingsData.longRunGroupValue] = 0.25-(((totalMiles - 45) / 35.0)*0.05);
      }
    }


  }

  void planDoubles(int totalMiles, int dayMiles){
    //Determine how far to run if doubling for the day
    //check to make sure not long run
    //check to make sure not race day
    //make sure it is not rest day
    //todo

    for(int index = 0; index < mileageSettingsData.amRunsSelected.length; index++){
      if(mileageSettingsData.amRunsSelected[index]){

      }
    }

  }

  void calculateMileage(int totalMiles){
    totalMiles -= raceMiles;
    //Calculate how far to run each day based off the percentages calculated
    mileageSettingsData.mileageContentState.setState((){
      for(int i = 0; i < 7; i++){
        mileageSettingsData.amRuns[i] = (mileageSettingsData.amPercent[i]*totalMiles).round();
        mileageSettingsData.pmRuns[i] = (mileageSettingsData.pmPercent[i]*totalMiles).round();
      }
    });
  }

  void checkMileage(){
    //Make sure all the mileage adds up to the total mileage entered
    //todo


  }


}