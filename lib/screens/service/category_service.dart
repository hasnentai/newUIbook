import 'package:bookabook/models/categories.dart';
import 'package:bookabook/screens/home-page/categories-controller.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class CatService {
  int catId;
  String catName;
  int count;

  CatService({this.catId, this.catName,this.count});

  factory CatService.fromJson(Map<String, dynamic> json) {
    return CatService(catId: json['id'], catName: json['name'],count: json['count']);
  }

  
}
