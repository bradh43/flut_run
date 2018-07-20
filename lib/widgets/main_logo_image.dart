import 'package:flutter/material.dart';
import 'package:flut_run/globalVariables/user_data.dart' as userData;

class MainLogoImage extends StatelessWidget {
  //MainLogoImage({this.imagePath});
  //final String imagePath = "assets/images/abstract_runner.png";
  final String defaultImage = "assets/images/abstract_runner.png";
  final String imagePath = userData.imagePath;


  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 80.0,
          child: getImage(),
        ),
      ),
    );
  }

  Widget getImage(){
    try {
      //try to get image
      return Image.asset(userData.imagePath);
    } catch(e) {
      //default image
      userData.imagePath = defaultImage;
      return Image.asset(defaultImage);
    }
  }
}