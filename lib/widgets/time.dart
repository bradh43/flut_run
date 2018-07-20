class Time{

  double timeSet = 0.0;
  void setTime(double time){
    this.timeSet = time;
  }

  double getTime(){
    return this.timeSet;
  }


  double getTotalSeconds(hours, minutes, seconds){
    return (hours*3600) + (minutes*60) + seconds;
  }

  String formatTime(double totalSeconds, bool split){
    String formattedTime = "";
    //check if the total time is longer than 1 hour
    if(totalSeconds >= 3600){
      //calculate the total number of hours
      int totalHours = (totalSeconds/3600).toInt();
      //update the remaining number of seconds
      totalSeconds -= totalHours*3600;
      //update the formatted time string
      formattedTime = totalHours.toString() + ":";
      //calculate the total number of minutes
      int totalMinutes = (totalSeconds/60).toInt();
      //update the remaining number of seconds
      totalSeconds -= totalMinutes*60;
      if(totalMinutes < 10){
        formattedTime = formattedTime + "0";
      }
      //update the formatted time string
      if(totalSeconds < 10){
        formattedTime = formattedTime + totalMinutes.toString() + ":0" + totalSeconds.toStringAsFixed(1);
      } else {
        formattedTime = formattedTime + totalMinutes.toString() + ":" + totalSeconds.toStringAsFixed(1);
      }
    } else if((!split && totalSeconds >= 60) || (split && totalSeconds >= 100)){
      //calculate the total number of minutes
      int totalMinutes = (totalSeconds/60).toInt();
      //update the remaining number of seconds
      totalSeconds -= totalMinutes*60;
      //update the formatted time string
      if(totalSeconds < 10){
        formattedTime = formattedTime + totalMinutes.toString() + ":0" + totalSeconds.toStringAsFixed(1);
      } else {
        formattedTime = formattedTime + totalMinutes.toString() + ":" + totalSeconds.toStringAsFixed(1);
      }
    } else {
      //update the formatted time string
      formattedTime = formattedTime + totalSeconds.toStringAsFixed(1);
    }
    return formattedTime;
  }

  double formatTotalSeconds(String formattedTime){
    double totalSeconds;

    //determine if the formatted time has hours, minutes, seconds
    int timeCount = 0;
    for(int i = 0; i < formattedTime.length-3; i++){
      if(formattedTime.substring(i,i+1) == ":"){
        timeCount++;
      }
    }

    double seconds;
    double minutes;
    double hours;
    //convert the formatted time string to total number of seconds
    switch(timeCount){
      case 0:
        totalSeconds = num.parse(formattedTime).toDouble();
        break;
      case 1:
        seconds = num.parse(formattedTime.substring(formattedTime.length-4)).toDouble();
        minutes = num.parse(formattedTime.substring(0, formattedTime.length-5)).toDouble();
        totalSeconds = (60*minutes) + seconds;
        break;
      case 2:
        seconds = num.parse(formattedTime.substring(formattedTime.length-4)).toDouble();
        minutes = num.parse(formattedTime.substring(formattedTime.length-7, formattedTime.length-5)).toDouble();
        hours = num.parse(formattedTime.substring(0, formattedTime.length-8)).toDouble();
        totalSeconds = (hours*3600) + (60*minutes) + seconds;
        break;
    }
    return totalSeconds;

  }

}