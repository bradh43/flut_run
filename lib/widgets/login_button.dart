import 'package:flutter/material.dart';
import 'dart:async';


class ProgressButton extends StatefulWidget {
  ProgressButton(
      {this.key, this.text, this.height, this.onPressed, this.loginButtonColor})
      : super(key: key);
  final Key key;
  final String text;
  final double height;
  final VoidCallback onPressed;
  final Color loginButtonColor;



  @override
  State<StatefulWidget> createState() =>
      _ProgressButtonState(text, loginButtonColor, height, onPressed);
}


enum ButtonState {
  animate,
  progress,
  complete
}

class _ProgressButtonState extends State<ProgressButton> with SingleTickerProviderStateMixin {
  _ProgressButtonState(this.buttonText, this.buttonColor, this.height, this.onPressed);

  final String buttonText;
  Color buttonColor;
  final double height;
  final VoidCallback onPressed;

  GlobalKey buttonKey = GlobalKey();

  ButtonState buttonState = ButtonState.animate;
  double width = double.infinity;
  Animation _animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: buttonKey,
      height: height,
      width: width,
      child: RaisedButton(
        padding: EdgeInsets.all(0.0),
        color: buttonColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(height / 2))),
        child: buildButtonChild(),
        onPressed: (){
          setState(() {
            if(buttonState == ButtonState.animate){
              animateButton();
            }
          });
        },
      ),
    );
  }

  void animateButton(){
    double initialWidth = buttonKey.currentContext.size.width;
    var controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(controller)
      ..addListener((){
        setState(() {
          width = initialWidth - ((initialWidth - height) * _animation.value);
        });
      });
    controller.forward();

    setState(() {
      buttonState = ButtonState.progress;
    });

    Timer(Duration(milliseconds: 2300), (){
      setState((){
        buttonState = ButtonState.complete;
        buttonColor = Colors.green;

      });
    });
  }

  Widget buildButtonChild() {
    if(buttonState == ButtonState.animate) {
      return Text(buttonText);
    } else if(buttonState == ButtonState.progress) {
      return SizedBox(
        height: 0.75*height,
        width: 0.75*height,
        child: CircularProgressIndicator(
            value: null,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
        ),
      );
    } else {
      return Icon(Icons.check);
    }
  }


  Widget loginButton(){
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: height),
      child: RaisedButton(
          color: buttonState == ButtonState.complete ? buttonColor : Colors.green,
          child:
          Text(buttonText, style: TextStyle(color: Colors.white, fontSize: height/2)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(height / 2))),
          onPressed: onPressed),
    );
  }
}
