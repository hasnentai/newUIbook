import 'dart:async';
import 'dart:convert';
import 'package:bookabook/screens/service/category_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:bookabook/screens/service/productService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexScreen extends StatefulWidget {
  final String email;
  final String displayName;
  IndexScreen(this.email, this.displayName);
  @override
  _IndexScreenState createState() => new _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SharedPreferences prefs;
  String email;
  String displayName;

  List<ProductService> productList;
  List<ProductService> filteredProducts;
  List<CatService> category;
  List<CatService> filterdCategory;

  var scrollController = ScrollController(initialScrollOffset: 50.0);

  Future<void> getAllItems() async {
    var client = new http.Client();
    try {
      var response = await client.get(
          'https://bookabook.co.za/wp-json/wc/v3/products?per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=1&order=asc&filter[meta_key]=total_sales&per_page=100');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data as List;
        productList = list
            .map<ProductService>((json) => ProductService.fromJson(json))
            .toList();
        filteredProducts = productList
            .where((data) => data.status == "publish" && data.totalSales > 1)
            .toList();
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

  Future<void> getAllCategory() async {
    var client = new http.Client();
    try {
      var response = await client.get(
          'https://bookabook.co.za/wp-json/wc/v3/products/categories?per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=1&order=asc&filter[meta_key]=total_sales&per_page=100');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data as List;
        category =
            list.map<CatService>((json) => CatService.fromJson(json)).toList();
        filterdCategory = category
            .where((data) => data.count > 0 && data.catName != "Uncategorized")
            .toList();
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

  void initState() {
    email = widget.email;
    displayName = widget.displayName;
    this.getAllItems();
    this.getAllCategory();
    super.initState();
  }

  Widget customSlider(BuildContext context) {
    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
            height: 200.0,
            decoration: new BoxDecoration(
                color: Colors.indigo,
                borderRadius: new BorderRadius.circular(20.0)),
          ),
        );
      },
      itemCount: 3,
      viewportFraction: 0.8,
      autoplay: true,
    );
  }

  Widget topRatedBooks(BuildContext context) {
    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: filteredProducts.map((item) {
          return Card(
            child: new Text(
              item.name,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = 200.0; // or something else..
      if (maxScroll - currentScroll <= delta) {
        print('hi');
      }
    });
    filteredProducts.shuffle();
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
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Container(height: 200.0, child: customSlider(context)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new Text(
                        'Browse By Categories',
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
                          child: Icon(
                            Icons.arrow_drop_down_circle,
                            color: Color(0xFFFF900F),
                          )),
                    )
                  ],
                ),
              ),
              new Container(
                height: 60.0,
                child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filterdCategory.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, left: 8.0, right: 8.0),
                          child: Container(
                              decoration: new BoxDecoration(
                                  color: Color(0xFFFF900F),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.black45,
                                      offset: new Offset(1.0, 1.0),
                                      blurRadius: 4.0,
                                    )
                                  ],
                                  borderRadius: new BorderRadius.circular(5.0),
                                  border: new Border.all(color: Colors.white)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(
                                  filterdCategory[i].catName,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                      color: Colors.white),
                                ),
                              )),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new Text(
                        'Listing Popular Rentals',
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
                          child: Icon(
                            Icons.arrow_drop_down_circle,
                            color: Color(0xFFFF900F),
                          )),
                    )
                  ],
                ),
              ),
            ]),
          ),
          SliverGrid.count(
            crossAxisCount: 3,
            childAspectRatio: 0.58,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            children: filteredProducts.map((item) {
              return Column(
                children: <Widget>[
                  Container(
                    height: 180.0,
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
                            borderRadius: new BorderRadius.circular(15.0),
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: new NetworkImage(item.images[0].src))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                        width: 140.0,
                        child: new Text(
                          item.name,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16.0),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                        width: 140.0,
                        child: new Text(
                          item.priceHtml,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              fontStyle: FontStyle.normal),
                        )),
                  ),
                ],
              );
            }).toList(),
          )
          //topRatedBooks(context)
        ],
      ),
    );
  }
}
