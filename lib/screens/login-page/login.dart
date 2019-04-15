import 'dart:convert';


import 'package:bookabook/screens/home-page/home.dart';
import 'package:bookabook/screens/login-page/login_controller.dart';
import 'package:bookabook/screens/practice/practice.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// FormValidator validator = new FormValidator();
LoginController controller = new LoginController();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _autovalidate = false;

  String _email;
  String _password;

  bool _isLoading = false;

  Map<String, dynamic> userInfo;
  http.Response response;
  submitForm() async {
     
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      setState(() => _autovalidate = true);
      return;
    }
    setState(() => _isLoading = true);
    // final Map<String, dynamic> data = {
    //   "username": _email,
    //   "password": _password
    // };
    // print(_isLoading);
    try {
      response = await controller.login(_email, _password);
    } catch (e) {
      print(e);
    }

    setState(() => _isLoading = false);
    if (response.statusCode == 403) {
      return _showSnackBar(context, "Invalid Password");
    } else if (response.statusCode == 200) {
      userInfo = json.decode(response.body);
      await controller.saveUserData(userInfo);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Home(userInfo["user_email"], userInfo["user_display_name"])));
    } 
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = new SnackBar(
      content: new Text(message),
      duration: new Duration(seconds: 4),
      action: new SnackBarAction(
          label: 'OK', textColor: Colors.yellow, onPressed: () {}),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(child: loginPageBuilder(context)),
            _isLoading
                ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black45,
                  child: Center(child: CircularProgressIndicator())
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget emailField() {
    return new TextFormField(
      initialValue: 'hasnen712',
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email',
        hasFloatingPlaceholder: true,
      ),
      // validator: validator.validateEmail,
      onSaved: (String val) => _email = val,
    );
  }

  Widget passwordField() {
    return TextFormField(
        initialValue: 'hasnenvkfan712',
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          hasFloatingPlaceholder: true,
        ),
        // validator: validator.validatePassword,
        onSaved: (String val) => _password = val);
  }

  Widget loginPageBuilder(BuildContext context) {
    return Column(
      children: <Widget>[
        headerbuilder(context),
        Padding(
          padding: const EdgeInsets.only(top: 38.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Form(
                autovalidate: _autovalidate,
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: emailField(),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: passwordField(),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: submitForm,
                child: new Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(200.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFF900F),
                          const Color(0xFFF46948)
                        ],
                        // whitish to gray
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius:
                              10.0, // has the effect of softening the shadow
                          // has the effect of extending the shadow
                          offset: Offset(
                            0, // horizontal, move right 10
                            8.0, // vertical, move down 10
                          ),
                        )
                      ],
                    ),
                    child: RotatedBox(
                        quarterTurns: 2,
                        child: Icon(
                          Icons.keyboard_backspace,
                          color: Colors.white,
                          size: 30.0,
                        ))),
              ),
            )
          ],
        )
      ],
    );
  }
}

Widget headerbuilder(BuildContext context) {
  // var width = MediaQuery.of(context).size.width;
  return new Container(
    height: MediaQuery.of(context).size.height / 2.3,
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Stack(
          children: <Widget>[
            Positioned(
                right: 10.0,
                top: 0.0,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: new Icon(
                      Icons.close,
                      size: 30.0,
                      color: Colors.white,
                    ))),
            Positioned(
              left: 20.0,
              child: Transform(
                transform: Matrix4.rotationZ(0.2),
                child: Opacity(
                  opacity: 0.6,
                  child: new Icon(
                    Icons.class_,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20.0,
              top: 30.0,
              child: Transform(
                transform: Matrix4.rotationZ(0.5),
                child: Opacity(
                  opacity: 0.7,
                  child: new Icon(
                    Icons.class_,
                    size: 60.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 130.0,
              top: 110.0,
              child: Transform(
                transform: Matrix4.rotationZ(2.0),
                child: Opacity(
                  opacity: 0.4,
                  child: new Icon(
                    Icons.class_,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10.0,
              top: 180.0,
              child: Transform(
                transform: Matrix4.rotationZ(3.0),
                child: Opacity(
                  opacity: 0.6,
                  child: new Icon(
                    Icons.class_,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Center(
              child: Hero(
                tag: 'icon',
                child: new Icon(
                  Icons.class_,
                  size: 200.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Book a Book',
              style: new TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            )
          ],
        )
      ],
    ),
    decoration: new BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [const Color(0xFFFF900F), const Color(0xFFF46948)],
        // whitish to gray
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6.0, // has the effect of softening the shadow
          // has the effect of extending the shadow
          offset: Offset(
            0, // horizontal, move right 10
            3.0, // vertical, move down 10
          ),
        )
      ],
      borderRadius: new BorderRadius.vertical(
          bottom:
              new Radius.elliptical(MediaQuery.of(context).size.width, 100.0)),
    ),
  );
}
