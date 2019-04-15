import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SingleChildScrollView(child: registerPageBuilder(context)),
    );
  }
}

Widget registerPageBuilder(BuildContext context) {
  return Column(
    children: <Widget>[
      headerbuilder(context),
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
        child: new Row(
          children: <Widget>[
            new Container(
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 44.0,
              ),
              height: 110.0,
              width: 110.0,
              decoration: new BoxDecoration(
                border: new Border.all(color: Colors.white, width: 4.0),
                borderRadius: new BorderRadius.circular(200.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFFFF900F), const Color(0xFFF46948)],
                  // whitish to gray
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0, // has the effect of softening the shadow
                    // has the effect of extending the shadow
                    offset: Offset(
                      0, // horizontal, move right 10
                      8.0, // vertical, move down 10
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: new TextFormField(
                      decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                    hasFloatingPlaceholder: true,
                  )),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: new TextFormField(
                      decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                    hasFloatingPlaceholder: true,
                  )),
                )
              ],
            )),
          ],
        ),
      ),
      Row(
        children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: new TextFormField(
                    decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hasFloatingPlaceholder: true,
                )),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: new TextFormField(
                    decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                  hasFloatingPlaceholder: true,
                )),
              )
            ],
          )),
        ],
      ),
      new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Container(
                height: 70.0,
                width: 70.0,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(200.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFFFF900F), const Color(0xFFF46948)],
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
          )
        ],
      )
    ],
  );
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
