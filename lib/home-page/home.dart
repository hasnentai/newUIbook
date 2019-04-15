import 'package:bookabook/screens/home-page/categories-controller.dart';
import 'package:flutter/material.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bookabook/screens/service/category_service.dart';

CatController catController = CatController();

class Home extends StatefulWidget {
  final String email;
  final String displayName;
  Home(this.email, this.displayName);
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  String email;
  String displayName;
  List _categories;
  List _products;
  List _masterData = [];

  void initState() {
    email = widget.email;
    displayName = widget.displayName;
    _fetchProducts();
    

    super.initState();
  }

  //fetch categories
  void _fetchProducts() async {
    try {
      List products =(catController.fetchProducts()) as List;
      setState(() => _products = products);
    } catch (e) {
      print(e);
    }
    await uniqueList(_products);
  }

  uniqueList(List list) async {
    final List unique = [];
    for (var i = 0; i < list.length; i++) {
      if (!unique.contains(list[i]['categories'][0]['name'])) {
        unique.add(list[i]['categories'][0]['name']);
      }
       print(list[i]['categories'][0]['name']);
    }

    setState(() => _categories = unique);
    finalComp();
  }

  finalComp() async {
    List masterData = [];
    final List temp = [];
    for (int i = 0; i < _categories.length; i++) {
      for (int j = 0; j < _products.length; j++) {
        if (_categories[i] == _products[j]['categories'][0]['name']) {
          temp.add(_products[j]);
        }

        // print(temp);
      }

      Map jsonMap = {_categories[i]: temp};
      // print(jsonMap);
      masterData.add(jsonMap);
      // print(masterData);
      // temp.clear();
    }

    setState(() => _masterData = masterData);
  }

  Widget navBarBuilder(BuildContext context) {

    
    return ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
            accountName: displayName != null ? Text(displayName) : Text(""),
            accountEmail: email != null ? Text(email) : Text(""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.orange
                  : Colors.white,
              child: Text(
                displayName.split('')[0].toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
            )),
        ListTile(
          title: Text('Logout'),
          onTap: () async {
            prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.pushReplacementNamed(context, "/myhome");
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
  
        
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
        canvasColor: Color(0xFFFF900F),
        // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        primaryColor: Colors.red,
        textTheme: Theme
            .of(context)
            .textTheme
            .copyWith(caption: new TextStyle(color: Colors.white30))),
                  child: new BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.white,
            items: [
              new BottomNavigationBarItem(
                  title: new Text(''), icon: new Icon(Icons.home)),
              new BottomNavigationBarItem(
                  title: new Text(''), icon: new Icon(Icons.notifications)),
              new BottomNavigationBarItem(
                  title: new Text(''), icon: new Icon(Icons.search)),
              new BottomNavigationBarItem(
                  title: new Text(''), icon: new Icon(Icons.person))
            ],
          ),
        ),
        appBar: new AppBar(
          title: new Text('Home',style: new TextStyle(color: Colors.white),),
          backgroundColor: Color(0xFFFF900F),
          leading: GestureDetector(
            child: Icon(Icons.menu,color: Colors.white,),
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Icon(Icons.send,color: Colors.white,),
            ),
          ],
          centerTitle: false,
        ),
        drawer: Drawer(child: navBarBuilder(context)),
        body: homeBodybuilder(context));
  }

  Widget homeBodybuilder(BuildContext context) {
    if (_masterData.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // print(_masterData);
      return ListView.builder(
        itemCount: _masterData.length,
        itemBuilder: (BuildContext context, int index) {
        },
      );
    }
  }
}