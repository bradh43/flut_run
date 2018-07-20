import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flut_run/widgets/hamburger_menu.dart';
import 'package:flut_run/widgets/auth.dart';

import 'package:flut_run/widgets/main_logo_image.dart';

class AboutPage extends StatefulWidget {
  AboutPage({this.themeData});

  final themeData;

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: this.widget.themeData,
      child: Scaffold(
        appBar: AppBar(
          title: Text("About"),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
        drawer: HamburgerMenu(
            currentTab: 7,
            themeData: widget.themeData,
            ),
        body: aboutBody(),
      ),
    );
  }

  Widget aboutBody(){
    return Scrollbar(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                missionStatement(),
                goal(),
                story(),
                creators(),
              ],
            ),
          ],
        ),
    );
  }

  Widget missionStatement() {
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Mission Statement",
                style: TextStyle(fontSize: 32.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                child: Image(
                  image: AssetImage('assets/images/run_community.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Strengthening our running community through an engaging tool that promotes personal development and fosters meaningful connections.",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget goal() {
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Goal",
                style: TextStyle(fontSize: 32.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Runners will develop and learn how to plan out their mileage each week, as well as get better at planning out their racing strategy. Give back to the running community and practice sustainable running practices. For example, at the end of each season have all runners on a team collect all their old running shoes and donate it to the Nike Grind program. This program takes old running shoes and recycles them into new surfaces for Tracks and playgrounds. Recognizing that having the opportunity to be on a running team is bigger than oneself.",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget story() {
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Story",
                style: TextStyle(fontSize: 32.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "This app started back in my second year of college, when I noticed I was spending a lot of time planning out my mileage each week. So I created a very simple command line program that would plan out a base for weekly mileage. This eventually evolved into a nicer graphical user interface with more settings and a better thought out algorithm thanks to the help of my college coach. One day, I realized that other runners could benefit from using this tool and could save time planning out their mileage for the week. So I started to build a running app with this feature included as well as some other features, keeping in mind how I could give back to the running community.",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget creators() {
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Credits",
                style: TextStyle(fontSize: 32.0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "This app was built and created by Brad Hodkinson with the help of his Cross-Country Coach Adam Frye. Curt Wilson designed all of the graphics and logos. He also helped handle all the business logistics as well as branding. Also special thanks to everyone else who helped in the design process giving constructive feedback.",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
