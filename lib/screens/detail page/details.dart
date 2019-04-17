import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;

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

class _DetailPageState extends State<DetailPage> {
  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    print(widget.avgRating);
    if (index >= widget.avgRating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    } else if (index > widget.avgRating - 1 && index < widget.avgRating) {
      icon = new Icon(
        Icons.star_half,
        color: widget.avgRating ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: Colors.white ?? Theme.of(context).primaryColor,
      );
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFF900F),
          statusBarIconBrightness: Brightness.light),
    );
    return new Scaffold(
        body: Column(
          children: <Widget>[
            headerbuilder(context),
            new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                 new Text(widget.bookAttributes[0].name,textAlign: TextAlign.left,),
                ],
              ),
            )
          ],
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
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: MediaQuery.of(context).size.height / 4.2,
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
                  width: 250.0,
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
                  width: 250.0,
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
                  width: 250.0,
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
