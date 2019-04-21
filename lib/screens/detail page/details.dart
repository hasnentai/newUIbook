import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:bookabook/screens/ratingcontrol.dart';
import 'package:bookabook/screens/service/reviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final int id;
  final String bookImage;
  final String bookName;
  final int bookPrice;
  final String bookDescription;
  final List bookAttributes;
  final String purchaseNote;
  final String rating;
  final String priceHtml;
  final String sortDec;
  final int starCount;
  final double avgRating;
  int radioValue;
  double newRating;

  DetailPage(
      {this.id,
      this.bookName,
      this.bookAttributes,
      this.bookDescription,
      this.bookImage,
      this.bookPrice,
      this.purchaseNote,
      this.rating,
      this.priceHtml,
      this.sortDec,
      this.starCount = 5,
      this.avgRating});
  @override
  _DetailPageState createState() => new _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = new TextEditingController();
  TextEditingController reviewController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool postingComment = false;

  List<Review> reviewListGlobal;
  Widget buildStar(BuildContext context, int index) {
    Icon icon;

    if (index >= widget.avgRating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > widget.avgRating - 1 && index < widget.avgRating) {
      icon = new Icon(
        Icons.star_half,
        color: Colors.white ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: Colors.white ?? Theme.of(context).primaryColor,
      );
    }
    return icon;
  }

  Widget buildStarc(BuildContext context, int index, int rating) {
    Icon icon;

    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Colors.black54,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: Colors.black54 ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: Colors.black54 ?? Theme.of(context).primaryColor,
      );
    }
    return icon;
  }

  TabController _tabController;
  VoidCallback onChanged;
  int rating = 2;

  void initState() {
    super.initState();
    setState(() {
      getAllItems();
    });
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);

    _tabController.addListener(onChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getAllItems() async {
    var client = new http.Client();
    String id = widget.id.toString();

    try {
      var response = await client.get(
          'https://bookabook.co.za/wp-json/wc/v3/products/reviews?product=$id&per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data as List;
        setState(() {
          List<Review> reviewList =
              list.map<Review>((i) => Review.fromJson(i)).toList();
          reviewListGlobal =
              reviewList.where((data) => data.status == "approved").toList();
        });
      } else {
        print('Somthing went wrong');
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

  Future<void> createPost(BuildContext context) async {
    setState(() {
      postingComment = true;
    });

    var client = new http.Client();
    String id = widget.id.toString();
    String reviewer = nameController.text;
    String reviewer_email = emailController.text;
    String review = reviewController.text;
    int innerRating = this.rating;
    var response = await client.post(
        'https://bookabook.co.za/wp-json/wc/v3/products/reviews?consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&product_id=$id&reviewer=$reviewer&reviewer_email=$reviewer_email&review=$review&rating=$innerRating');
    if (response.statusCode == 201) {
      setState(() {
        postingComment = false;
        final snackBar = SnackBar(content: Text('Comment poted !!'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      });
    } else {
      setState(() {
        postingComment = false;
        final snackBar = SnackBar(content: Text('Some thing went wrong  !!'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      });
    }
    client.close();
  }

  @override
  Widget build(BuildContext context) {
    void _handleRadioValueChange(int value) {
      setState(() {
        widget.radioValue = value;
      });
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFF900F),
          statusBarIconBrightness: Brightness.light),
    );

    Widget myBodyBuilder(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          headerbuilder(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                child: new Container(
                  child: new Text(
                    widget.bookAttributes[0].name,
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        color: Color(0xFFFF900F),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Column(
                  children: <Widget>[
                    new ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.bookAttributes[0].options.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: <Widget>[
                            new Radio(
                              value: index,
                              groupValue: widget.radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            new Text(widget.bookAttributes[0].options[index]),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              DefaultTabController(
                  length: 3,
                  initialIndex: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TabBar(tabs: [
                        Tab(text: 'Description'),
                        Tab(text: 'Reviews '),
                        Tab(text: 'Add Review')
                      ]),
                      Container(
                        height: 600.0,
                        child: !(postingComment)
                            ? TabBarView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Container(
                                      decoration: new BoxDecoration(
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                          border: new Border.all(
                                              color: Colors.grey)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: new Text(
                                          parse(widget.bookDescription)
                                              .body
                                              .text,
                                          style: new TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  !(reviewListGlobal == null)
                                      ? new ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: reviewListGlobal.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            print(
                                                reviewListGlobal[index].rating);
                                            if (reviewListGlobal.length != 0) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: new Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10.0),
                                                  child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      new Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 16.0),
                                                        child: new CircleAvatar(
                                                            child: (reviewListGlobal[
                                                                            index]
                                                                        .reviewer !=
                                                                    "")
                                                                ? new Text(reviewListGlobal[
                                                                        index]
                                                                    .reviewer[0]
                                                                    .toUpperCase())
                                                                : new Text(
                                                                    'U')),
                                                      ),
                                                      new Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          (reviewListGlobal[
                                                                          index]
                                                                      .reviewer !=
                                                                  "")
                                                              ? new Text(
                                                                  reviewListGlobal[
                                                                          index]
                                                                      .reviewer
                                                                      .toUpperCase(),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subhead)
                                                              : new Text(
                                                                  "Unkown"),
                                                          new Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0),
                                                            width: 200.0,
                                                            child: new Text(parse(
                                                                    reviewListGlobal[
                                                                            index]
                                                                        .review)
                                                                .body
                                                                .text),
                                                          ),
                                                          Container(
                                                              child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          4.0,
                                                                      vertical:
                                                                          0.0),
                                                                  child: new Row(
                                                                      children: new List
                                                                              .generate(
                                                                          widget
                                                                              .starCount,
                                                                          (i) => buildStarc(
                                                                              context,
                                                                              i,
                                                                              reviewListGlobal[index].rating)))))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return new Text(
                                                  'No Comments to Display');
                                            }
                                          })
                                      : new Center(
                                          child:
                                              new CircularProgressIndicator(),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          'Add New Rating',
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        new StarRating(
                                          rating: rating,
                                          onRatingChanged: (rating) => setState(
                                              () => this.rating = rating),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 18.0, bottom: 8.0),
                                          child: new Text(
                                            'Your Review',
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                        new TextFormField(
                                          maxLines: 5,
                                          controller: reviewController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hasFloatingPlaceholder: true,
                                          ),
                                          // validator: validator.validateEmail,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 18.0, bottom: 8.0),
                                          child: new Text(
                                            'Your Name ',
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                        new TextFormField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hasFloatingPlaceholder: true,
                                          ),
                                          // validator: validator.validateEmail,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 18.0, bottom: 8.0),
                                          child: new Text(
                                            'Your Email ',
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                        new TextFormField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hasFloatingPlaceholder: true,
                                          ),
                                          // validator: validator.validateEmail,
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 9.0),
                                            child: new RaisedButton(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 14.0,
                                                    horizontal: 18.0),
                                                child: new Text(
                                                  'Submit',
                                                  style: new TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                onPressed: () {
                                                  if (reviewController
                                                      .text.isEmpty) {
                                                    final snackBar = SnackBar(
                                                        content: Text(
                                                            'Review feild can not be blank'));
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(snackBar);
                                                  } else if (nameController
                                                      .text.isEmpty) {
                                                    final snackBar = SnackBar(
                                                        content: Text(
                                                            'Name feild can not be blank'));
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(snackBar);
                                                  } else if (emailController
                                                      .text.isEmpty) {
                                                    final snackBar = SnackBar(
                                                        content: Text(
                                                            'Email feild can not be blank'));
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(snackBar);
                                                  } else {
                                                    createPost(context);
                                                  }
                                                }))
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : new Center(
                                child: new CircularProgressIndicator()),
                      ),
                    ],
                  ))
            ],
          )
        ],
      );
    }

    return new Scaffold(
        key: _scaffoldKey,
        body: ListView(
          children: <Widget>[myBodyBuilder(context)],
        ),
        appBar: new AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          title: new Text(
            parse(widget.bookName).body.text,
            style: new TextStyle(color: Colors.white),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }

  Widget headerbuilder(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return new Container(
      height: MediaQuery.of(context).size.height / 2.8,
      width: MediaQuery.of(context).size.width,
      child: new Row(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: widget.bookName,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: new Container(
                    width: 120.0,
                    height: 180.0,
                    decoration: new BoxDecoration(
                        color: Colors.black26,
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.black45,
                            offset: new Offset(1.0, 1.0),
                            blurRadius: 4.0,
                          )
                        ],
                        borderRadius: new BorderRadius.circular(10.0),
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(widget.bookImage))),
                  ),
                ),
              ),
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: 200.0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text(
                      parse(widget.bookName).body.text,
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                  )),
              Container(
                  width: 200.0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text(
                      widget.priceHtml,
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                  )),
              Container(
                  width: 200.0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Text(
                      widget.sortDec.trim(),
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )),
              Container(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 0.0),
                      child: new Row(
                          children: new List.generate(widget.starCount,
                              (index) => buildStar(context, index)))))
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
            bottom: new Radius.elliptical(
                MediaQuery.of(context).size.width, 100.0)),
      ),
    );
  }
}
