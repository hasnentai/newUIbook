import 'package:bookabook/screens/detail page/details.dart';
import 'package:bookabook/screens/home-page/index.dart';
import 'package:bookabook/screens/login-page/login.dart';
import 'package:bookabook/screens/practice/practice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register.dart';

var routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => Login(),
  '/register': (BuildContext context) => Register(),
  "/myhome": (BuildContext context) => MyHomePage(),
  "/mypractice": (BuildContext context) => MyPractice(),
  "/details": (BuildContext context) => DetailPage(),
};

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFF900F),

      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFFFF900F), //bottom bar color
      systemNavigationBarIconBrightness: Brightness.light, //bottom bar icons
    ));
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Raleway'),
        home: MyHomePage(title: 'Book a Book'),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: routes);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    _auth();
    super.initState();
  }

  void _auth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token");

    if (token != null) {
      String _email = prefs.getString('email');
      String _displayName = prefs.getString('displayName');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => IndexScreen(_email, _displayName)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyBuilder(context),
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}

Widget bodyBuilder(BuildContext context) {
  return new Stack(
    children: <Widget>[
      Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage('res/images/loginbg.png'),
                fit: BoxFit.cover)),
      ),
      Opacity(
        opacity: 0.94,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: new BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xFFFF900F), const Color(0xFFF46948)],
              // whitish to gray
            ),
          ),
        ),
      ),
      iconBuilder(context)
    ],
  );
}

Widget iconBuilder(BuildContext context) {
  return Container(
    width: double.infinity,
    child: new Column(
      children: <Widget>[
        Expanded(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Hero(
                tag: 'icon',
                child: Icon(
                  Icons.class_,
                  size: 200.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'Book a Book',
                style: new TextStyle(fontSize: 25.0, color: Colors.white),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: new Container(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                    decoration: new BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius:
                                                6.0, // has the effect of softening the shadow
                                            // has the effect of extending the shadow
                                            offset: Offset(
                                              0, // horizontal, move right 10
                                              3.0, // vertical, move down 10
                                            ),
                                          )
                                        ],
                                        color: Colors.white,
                                        borderRadius:
                                            new BorderRadius.circular(35.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: new Text(
                                        'Login',
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFFF46948)),
                                      ),
                                    )))),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Container(
                          height: 2.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'OR',
                      style: new TextStyle(color: Colors.white),
                    ),
                    new Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Container(
                          height: 2.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: new Container(
                                    decoration: new BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius:
                                                6.0, // has the effect of softening the shadow
                                            // has the effect of extending the shadow
                                            offset: Offset(
                                              0, // horizontal, move right 10
                                              3.0, // vertical, move down 10
                                            ),
                                          )
                                        ],
                                        color: Colors.white,
                                        borderRadius:
                                            new BorderRadius.circular(35.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: new Text(
                                        'Register',
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFFF46948)),
                                      ),
                                    )),
                              ))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

// Widget StackBuilder(BuildContext context) {
//   return new Stack(
//     children: <Widget>[
//       Container(

//         decoration: new BoxDecoration(
//             image: new DecorationImage(
//                 image: new AssetImage('res/images/loginbg.png'),
//                 fit: BoxFit.cover)),
//       ),
//       Opacity(
//         opacity: 0.94,
//         child: Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: new BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [const Color(0xFFFF900F), const Color(0xFFF46948)],
//               // whitish to gray
//             ),
//           ),
//         ),
//       ),
//       new Container(
//         child: CoulmnBuilder(context),
//       )
//     ],
//   );
// }

// Widget CoulmnBuilder(BuildContext context) {
//   return Center(
//     child: new Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         new Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Hero(
//               tag: 'icon',
//                           child: new Icon(
//                 Icons.class_,
//                 size: 200.0,
//                 color: Colors.white,
//               ),
//             ),
//             new Text(
//                 'Book a Book',
//                 style: new TextStyle(
//                     color: Colors.white,
//                     fontSize: 24.0,
//                     fontFamily: 'Raleway',
//                     fontWeight: FontWeight.w600),
//               ),
//           ],
//         ),
//         new Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             new Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: ButtonBuilder('Register Here'),
//                 )
//               ],
//             ),
//             Divider(),
//             new Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 new Expanded(child: ButtonBuilder('Login Here')
//                 )
//               ],
//             ),
//           ],
//         )
//       ],
//     ),
//   );
// }

// Widget ButtonBuilder(String name) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: new Container(
//       decoration: new BoxDecoration(boxShadow: [
//         BoxShadow(
//           color: Colors.black12,
//           blurRadius: 6.0, // has the effect of softening the shadow
//           // has the effect of extending the shadow
//           offset: Offset(
//             0, // horizontal, move right 10
//             3.0, // vertical, move down 10
//           ),
//         )
//       ], color: Colors.white, borderRadius: new BorderRadius.circular(35.0)),
//       child: Padding(
//         padding: const EdgeInsets.all(22.0),
//         child: new Text(
//           name,
//           textAlign: TextAlign.center,
//           style: new TextStyle(fontSize: 20.0, color: Color(0xFFF46948)),
//         ),
//       ),
//     ),
//   );
// }

Widget divider() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
    child: new Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: new Container(
              height: 1.0,
              color: Colors.white,
            ),
          ),
        ),
        new Text(
          'OR',
          style: new TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Container(
              height: 1.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
