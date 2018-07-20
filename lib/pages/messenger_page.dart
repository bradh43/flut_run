import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flut_run/widgets/hamburger_menu.dart';
import 'package:flut_run/widgets/auth.dart';
import 'package:flut_run/globalVariables/user_data.dart';

class Messenger extends StatefulWidget {
  Messenger({this.themeData});
  final themeData;

  @override
  State createState() =>  ChatWindow();
}

class ChatWindow extends State<Messenger> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController =  TextEditingController();
  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return  Theme(
      data: widget.themeData,
      child:  Scaffold(
        appBar:  AppBar(
          title:  Text("Message Board"),
        ),
        drawer: HamburgerMenu(currentTab: 4, themeData: widget.themeData),
        body:  Column(
          children: <Widget>[
             Flexible(
                child:  ListView.builder(
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                  reverse: true,
                  padding:  EdgeInsets.all(7.0),
                )),
             Divider(height: 1.0),
             Container(
              child: _buildComposer(),
              decoration:
               BoxDecoration(color: Theme.of(context).primaryColor),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return  IconTheme(
      data:  IconThemeData(color: Colors.blue),
      child:  Container(
        margin: const EdgeInsets.symmetric(horizontal: 9.0),
        child:  Row(
          children: <Widget>[
             Flexible(
              child:  TextField(
                controller: _textController,
                onChanged: (String txt) {
                  setState(() {
                    _isWriting = txt.length > 0;
                  });
                },
                onSubmitted: _submitMsg,
                decoration:
                 InputDecoration.collapsed(hintText: "Enter a message"),
              ),
            ),
             Container(
                margin:  EdgeInsets.symmetric(horizontal: 3.0),
                child:  IconButton(
                  icon:  Icon(Icons.send),
                  onPressed: _isWriting
                      ? () => _submitMsg(_textController.text)
                      : null,
                ))
          ],
        ),
      ),
    );
  }

  void _submitMsg(String txt) {
    if (txt != "") {
      _textController.clear();
      setState(() {
        _isWriting = false;
      });
      Msg msg =  Msg(
        txt: txt,
        animationController:  AnimationController(
            vsync: this, duration:  Duration(milliseconds: 800)),
      );
      setState(() {
        _messages.insert(0, msg);
      });
      msg.animationController.forward();
    }
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});
  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return  SizeTransition(
      sizeFactor:  CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceIn,
      ),
      axisAlignment: 0.0,
      child:  Row(children: <Widget>[
         Container(
          margin: const EdgeInsets.only(right: 18.0, top: 1.0),
          child:  CircleAvatar(
            backgroundImage:  AssetImage(profilePicture),
          ),
        ),
         Expanded(
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child:  Text(userName),
                ),
                 Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child:  Text(txt),
                ),
              ],
            ))
      ]),
    );
  }
}
