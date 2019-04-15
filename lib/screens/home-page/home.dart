import 'dart:async';
import 'dart:convert';

import 'package:bookabook/screens/home-page/categories-controller.dart';
import 'package:bookabook/screens/service/productService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:bookabook/screens/service/category_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_swiper/flutter_swiper.dart';

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

  List<ProductService> productList;
  List<ProductService> filteredProducts;
  List<ProductService> auditingProducts;
  List<ProductService> bankProduct;
  List<ProductService> bookRental;
  List<ProductService> businessManagement;
  List<CatService> category;
  List<CatService> categoryList;
  List<ProductService> myNewProducts;
  List<String> pl;

  bool isError = false;

  void initState() {
    email = widget.email;
    displayName = widget.displayName;

    // this.getAuditingData();
    // this.getBankingData();
    // this.getBookRentalData();
    // this.getBusinessManagementData();

    super.initState();
    setState(() {
      this.getAllItems();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget customSlider(BuildContext context) {
    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        return new Container(
          height: 200.0,
          decoration: new BoxDecoration(
              color: Colors.indigo,
              borderRadius: new BorderRadius.circular(20.0)),
        );
      },
      itemCount: 3,
      viewportFraction: 0.8,
      scale: 0.9,
      control: new SwiperControl(),
      autoplay: true,
    );
  }

  Future<void> getAllItems() async {
    var client = new http.Client();

    List<String> itemsIds = ['930', '127', '139']; //different ids
    int counter = 0;
    List<Response> list = await Future.wait(itemsIds.map((itemId) => client.get(
        'https://bookabook.co.za/wp-json/wc/v3/products?category=$itemId&per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=2')));

    return list.map((response) {
      var data = json.decode(response.body);
      var list = data as List;
      if (counter == 0) {
        print('First');
        setState(() {
          productList = list
              .map<ProductService>((json) => ProductService.fromJson(json))
              .toList();

          businessManagement =
              productList.where((data) => data.status == "publish").toList();
        });
      } else if (counter == 1) {
        print('Second');
        setState(() {
          productList = list
              .map<ProductService>((json) => ProductService.fromJson(json))
              .toList();

          filteredProducts =
              productList.where((data) => data.status == "publish").toList();
        });
      } else if (counter == 2) {
        print('Third');
        setState(() {
          productList = list
              .map<ProductService>((json) => ProductService.fromJson(json))
              .toList();

          auditingProducts =
              productList.where((data) => data.status == "publish").toList();
        });
      }
      counter++;
    }).toList();
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFF900F),
          statusBarIconBrightness: Brightness.light),
    );
    return new Scaffold(
      key: _scaffoldKey,
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Color(0xFFFF900F),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color(0xFFFF900F),
        child: new Container(
          height: MediaQuery.of(context).size.height / 17,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Icon(
                Icons.home,
                color: Colors.white,
              ),
              new Icon(Icons.notifications, color: Colors.white),
              new Icon(Icons.search, color: Colors.white),
              new Icon(Icons.person, color: Colors.white),
            ],
          ),
        ),
      ),
      appBar: new AppBar(
        title: new Text(
          'Home',
          style: new TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF900F),
        leading: GestureDetector(
          child: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
        centerTitle: false,
      ),
      drawer: Drawer(child: navBarBuilder(context)),
      body: !(businessManagement == null)
          ? productListBuilder(context)
          : new Center(child: new CircularProgressIndicator()),
    );
  }

  Widget productListBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(height: 200.0, child: customSlider(context)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: new Text(
                      'Banking',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF900F),
                      ),
                    ),
                  ),
                  Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black45,
                              offset: new Offset(1.0, 1.0),
                              blurRadius: 6.0,
                            )
                          ],
                          borderRadius: new BorderRadius.circular(50.0),
                          border: new Border.all(color: Color(0xFFFF900F))),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text('See All'),
                      ))
                ],
              ),
            ),
            !(businessManagement == null)
                ? new Container(
                    height: 250.0,
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: businessManagement.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Container(
                                  width: 130.0,
                                  decoration: new BoxDecoration(
                                      color: Colors.black26,
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.black45,
                                          offset: new Offset(1.0, 1.0),
                                          blurRadius: 4.0,
                                        )
                                      ],
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new NetworkImage(
                                              businessManagement[i]
                                                  .images[0]
                                                  .src))),
                                ),
                              ),
                            ),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  businessManagement[i].name,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0),
                                )),
                            Container(
                                width: 140.0,
                                child: new Text(
                                  businessManagement[i].price,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18.0),
                                ))
                          ],
                        );
                      },
                    ),
                  )
                : new CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: new Text(
                      'Accounting',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF900F)),
                    ),
                  ),
                  Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black45,
                              offset: new Offset(1.0, 1.0),
                              blurRadius: 6.0,
                            )
                          ],
                          borderRadius: new BorderRadius.circular(50.0),
                          border: new Border.all(color: Color(0xFFFF900F))),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text('See All'),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: !(filteredProducts == null)
                  ? new Container(
                      height: 250.0,
                      child: new ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, i) {
                          return Column(
                            children: <Widget>[
                              Container(
                                height: 200.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Container(
                                    width: 130.0,
                                    decoration: new BoxDecoration(
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.black45,
                                            offset: new Offset(1.0, 1.0),
                                            blurRadius: 4.0,
                                          )
                                        ],
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                filteredProducts[i]
                                                    .images[0]
                                                    .src))),
                                  ),
                                ),
                              ),
                              Container(
                                  width: 140.0,
                                  child: new Text(
                                    filteredProducts[i].name,
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0),
                                  )),
                              Container(
                                  width: 140.0,
                                  child: new Text(
                                    filteredProducts[i].price,
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18.0),
                                  ))
                            ],
                          );
                        },
                      ),
                    )
                  : new CircularProgressIndicator(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: new Text(
                      'Auditing',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xFFFF900F),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black45,
                                offset: new Offset(1.0, 1.0),
                                blurRadius: 6.0,
                              )
                            ],
                            borderRadius: new BorderRadius.circular(50.0),
                            border: new Border.all(color: Color(0xFFFF900F))),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text('See All'),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: !(auditingProducts == null)
                  ? new Container(
                      height: 250.0,
                      child: new ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: auditingProducts.length,
                        itemBuilder: (context, i) {
                          return Column(
                            children: <Widget>[
                              Container(
                                height: 200.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Container(
                                    width: 130.0,
                                    decoration: new BoxDecoration(
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.black45,
                                            offset: new Offset(1.0, 1.0),
                                            blurRadius: 4.0,
                                          )
                                        ],
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                auditingProducts[i]
                                                    .images[0]
                                                    .src))),
                                  ),
                                ),
                              ),
                              Container(
                                  width: 140.0,
                                  child: new Text(
                                    auditingProducts[i].name,
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0),
                                  )),
                              Container(
                                  width: 140.0,
                                  child: new Text(
                                    auditingProducts[i].price,
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18.0),
                                  ))
                            ],
                          );
                        },
                      ),
                    )
                  : new CircularProgressIndicator(),
            ),
            new Container(
              decoration: new BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    const Color(0xFFFF900F),
                    const Color(0xFFF46948)
                  ])),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'View All Categories',
                  style: new TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
