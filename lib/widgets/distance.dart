//1 = Miles
//2 = Kilometers
//3 = Meters

class Distance {


  double getMiles(double distance, int unit){
    double convertedDistance;
    switch(unit){
      case 2:
        convertedDistance = distance * 0.621371;
        break;
      case 3:
        convertedDistance = distance * 0.000621371;
        break;
      case 1:
      default:
        convertedDistance = distance;
    }
    return convertedDistance;
  }

  double getKilometers(double distance, int unit){
    double convertedDistance;
    switch(unit){
      case 1:
        convertedDistance = distance * 1.60934;
        break;
      case 3:
        convertedDistance = distance * 0.001;
        break;
      case 2:
      default:
        convertedDistance = distance;
    }
    return convertedDistance;
  }

  double getMeters(double distance, int unit){
    double convertedDistance;
    switch(unit){
      case 1:
        convertedDistance = distance * 1609.34;
        break;
      case 2:
        convertedDistance = distance * 1000;
        break;
      case 3:
      default:
        convertedDistance = distance;
    }
    return convertedDistance;
  }

  double getConvertedDistance(double distance, int startUnits, int endUnits){
    if(startUnits != endUnits){
      switch(endUnits){
        case 3:
          distance = getMeters(distance, startUnits);
          break;
        case 2:
          distance = getKilometers(distance, startUnits);
          break;
        case 1:
          distance = getMiles(distance, startUnits);
          break;
      }
    }
    return distance;
  }

}