import 'package:flutter/material.dart';
import 'package:flut_run/widgets/auth.dart';
import 'package:flut_run/widgets/main_logo_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

TabController tabController;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn, this.themeData})
      : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;
  final ThemeData themeData;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum ButtonState {
  animate,
  progress,
  complete
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {

  //login form key
  final formKey = GlobalKey<FormState>();

  //login button variables
  final String buttonText = "Login";
  GlobalKey loginButtonKey = GlobalKey();
  ButtonState loginButtonState = ButtonState.animate;
  double loginHeight = 40.0;
  double loginWidth = double.infinity;
  Animation _loginButtonAnimation;




  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getRememberMePreference().then(updateRememberMe);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  TabBar makeTabBar() {
    return TabBar(
      tabs: <Widget>[
        Tab(text: "Login"),
        Tab(text: "Create Account"),
      ],
      controller: tabController,
    );
  }

  TabBarView makeTabBarView(tabs) {
    return TabBarView(
      children: tabs,
      controller: tabController,
    );
  }

  String _email;
  String _password;
  bool _keepSignedInVal = false;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void saveRememberMePreferences(
      String _emailPref, String _passwordPref, bool _rememberMePref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", _emailPref);
    prefs.setString("password", _passwordPref);
    prefs.setBool("rememberMe", _rememberMePref);
  }

  Future<String> getEmailPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get("email");
  }

  Future<String> getPasswordPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get("password");
  }

  Future<bool> getRememberMePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get("rememberMe");
  }

  bool checkKeepSignedInVal() {
    try {
      return this._keepSignedInVal;
    } catch (e) {
      return false;
    }
  }

  void updateRememberMe(bool rememberMe) {
    setState(() {
      this._keepSignedInVal = rememberMe;
    });
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      //change login button to progress indicator
      setState((){
        loginButtonState = ButtonState.progress;
      });
      animateButton();
      try {
        String userId = await widget.auth.signIn(_email, _password);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
        //successfully logged in
        Timer(Duration(milliseconds: 1300), (){
          setState((){
            loginButtonState = ButtonState.complete;
          });
        });
        Timer(Duration(milliseconds: 1800), (){
          widget.onSignIn();
        });
      } catch (e) {
        //change login button to original state
        setState((){
          loginWidth = double.infinity;
          loginButtonState = ButtonState.animate;
        });
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
      if (_keepSignedInVal) {
        saveRememberMePreferences(_email, _password, _keepSignedInVal);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _authHint = '';
    });
  }

  Widget usernameTextForm() {
    return padded(
        child: TextFormField(
      key: Key('email'),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Email',
          labelText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
      onSaved: (val) => _email = val,
    ));
  }

  Widget passwordTextForm() {
    return padded(
        child: TextFormField(
      key: Key('password'),
      keyboardType: TextInputType.text,
      obscureText: true,
      autocorrect: false,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Password',
          labelText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
      onSaved: (val) => _password = val,
    ));
  }

  Widget keepSignedIn() {
    return Container(
        child: Row(
      children: <Widget>[
        Checkbox(
          value: _keepSignedInVal,
          onChanged: (bool value) {
            setState(() {
              _keepSignedInVal = value;
            });
          },
        ),
        Text("Remember Me"),
      ],
    ));
  }

  Widget hintText() {
    return Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: Text(_authHint,
            key: Key('hint'),
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.themeData,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            automaticallyImplyLeading: false,
            bottom: makeTabBar(),
          ),
          resizeToAvoidBottomPadding: false,
          body: makeTabBarView(<Widget>[
            loginTab(),
            AccountWidget(
                auth: this.widget.auth, onSignIn: this.widget.onSignIn)
          ]),
        ));
  }

  Widget loginTab() {
    return ListView(
      children: <Widget>[
        MainLogoImage(),
        loginBody(),
      ],
    );
  }

  Widget loginBody() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          usernameTextForm(),
                          passwordTextForm(),
                          //keepSignedIn(),
                          loginButton(),
                          needAccountButton(),
                          forgotLabel()
                        ]))),
          ]),
          hintText()
        ]));
  }

  Widget loginButton() {
    return Container(
      key: loginButtonKey,
      height: loginHeight,
      width: loginWidth,
      child:RaisedButton(
        padding: EdgeInsets.all(0.0),
        color: loginButtonState != ButtonState.complete ? this.widget.themeData.primaryColor : Colors.green,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(loginHeight / 2))),
        child: buildButtonChild(),
        onPressed: (){
          if(loginButtonState == ButtonState.animate){
            validateAndSubmit();
          }
        },
      ),
    );
  }

  void animateButton(){
    double initialWidth = loginButtonKey.currentContext.size.width;
    var controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _loginButtonAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(controller)
      ..addListener((){
        setState(() {
          loginWidth = initialWidth - ((initialWidth - loginHeight) * _loginButtonAnimation.value);
        });
      });
    controller.forward();
  }

  Widget buildButtonChild() {
    if(loginButtonState == ButtonState.animate) {
      return Text(buttonText, style: TextStyle(fontSize: loginHeight/2),);
    } else if(loginButtonState == ButtonState.progress) {
      return SizedBox(
        height: 0.75*loginHeight,
        width: 0.75*loginHeight,
        child: CircularProgressIndicator(
            value: null,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
        ),
      );
    } else {
      return Icon(Icons.check);
    }
  }


}

Widget needAccountButton() {
  return FlatButton(
    key: Key('need-account'),
    child: Text("New User? Register"),
    //onPressed: null,
    //onPressed: moveToRegister
    onPressed: () => tabController.index = 1,
  );
}

Widget forgotLabel() {
  return FlatButton(
    child: Text("Forgot Password?"),
    onPressed: () {},
  );
}

Widget padded({Widget child}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: child,
  );
}

//----------------------------- Account Widget ------------------------------
class AccountWidget extends StatefulWidget {
  AccountWidget({this.auth, this.onSignIn});
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  AccountWidgetState createState() => AccountWidgetState();
}

class AccountWidgetState extends State<AccountWidget> {
  static String _authHint = '';
  static String _email;
  static String _password;
  static String _firstName;
  static String _lastName;

  //todo
  static bool step1Complete = true;

  final formKey = GlobalKey<FormState>();

  int stepCounter = 0;
  List<Step> steps = step1() + step2() + step3() + step4();

  static List<Step> step1() {
    return [
      Step(
        //todo
        state: step1Complete ? StepState.indexed : StepState.error,
        title: Text("Name"),
        content: Column(
          children: <Widget>[
            TextFormField(
              key: Key('firstName'),
              decoration: InputDecoration(labelText: 'First Name'),
              autocorrect: false,
              keyboardType: TextInputType.text,
              validator: (val) {
                if (val.isEmpty) {
                  return 'First name is required.';
                } else {
                  return null;
                }
              },
              onSaved: (val) => _firstName = val,
            ),
            TextFormField(
              key: Key('lastName'),
              decoration: InputDecoration(labelText: 'Last Name'),
              autocorrect: false,
              keyboardType: TextInputType.text,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Last name is required.';
                } else {
                  return null;
                }
              },
              onSaved: (val) => _lastName = val,
            ),
          ],
        ),
      )
    ];
  }

  static List<Step> step2() {
    return [
      Step(
        title: Text("Email"),
        content: Column(children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Icon(Icons.email),
                flex: 1,
              ),
              Expanded(
                flex: 8,
                child: TextFormField(
                  key: Key('email'),
                  decoration: InputDecoration(labelText: 'Email'),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val.isEmpty ? 'Email is required.' : null,
                  onSaved: (val) => _email = val,
                ),
              )
            ],
          )
        ]),
      ),
    ];
  }

  static List<Step> step3() {
    String _tempPassword = "";
    return [
      Step(
        title: Text("Set Password"),
        content: Column(
          children: <Widget>[
            TextFormField(
                key: Key('password'),
                decoration: InputDecoration(labelText: 'Password'),
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Password can\'t be empty';
                  } else {
                    _tempPassword = val;
                    return null;
                  }
                }),
            TextFormField(
                key: Key('tempPassword'),
                decoration: InputDecoration(labelText: 'Re-enter Password'),
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Password is required.';
                  } else if (val != _tempPassword) {
                    return 'Passwords do not match.';
                  } else {
                    _password = val;
                    return null;
                  }
                }),
          ],
        ),
      )
    ];
  }

  static List<Step> step4() {
    return [
      Step(
          title: Text("Review"),
          content: Column(
            children: <Widget>[
              Text("Review the application and make sure all the information "
                  "provided is correct. \nIf all the information is correct press "
                  "continue to create an account, if you already have an account "
                  "and you need to login press cancel."),
              //hintText(),
            ],
          ))
    ];
  }

  static Widget hintText() {
    return Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: Text(_authHint,
            key: Key('hint'),
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _authHint = '';
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = await widget.auth
            .createUser(_email, _password, _firstName, _lastName);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
//        Scaffold.of(context).showSnackBar(SnackBar(
//              content: Text("Account was successfully created!"),
//              duration: Duration(seconds: 3),
//            ));
        widget.onSignIn();
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        createAccountBody(),
      ],
    );
  }

  Widget createAccountBody() {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          createAccountSteps(),
        ],
      ),
    );
  }

  Widget createAccountSteps() {
    return Stepper(
      currentStep: this.stepCounter,
      steps: steps,
      type: StepperType.vertical,
      onStepTapped: (step) {
        setState(() {
          stepCounter = step;
        });
      },
      onStepCancel: () {
        setState(() {
          if (stepCounter == steps.length - 1 || stepCounter == 0) {
            tabController.index = 0;
          } else if (stepCounter > 0) {
            stepCounter--;
          } else {
            stepCounter = 0;
          }
        });
      },
      onStepContinue: () {
        setState(() {
          if (stepCounter == steps.length - 1) {
            validateAndSubmit();
          } else if (stepCounter < steps.length - 1) {
            stepCounter++;
          } else {
            stepCounter = 0;
          }

        });
      },
    );
  }
}
