import 'dart:async';
import 'dart:convert';

import 'package:bookabook/constants.dart';
import 'package:bookabook/models/product.dart';
import 'package:http/http.dart' as http;

Constants consts = Constants();

//consumer_key=ck_34efa34549443c3706b49f8525947961737748e5
//consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75
class CatController {
  List<Category> categories;
  Category category;

  List<Product> products;
  Product product;

  Stream<List<Product>> fetchProducts() async* {
    final int perPage = 100;
    int page = 1;
    bool flag = true;

    while (flag) {
      try {
        http.Response response = await http.get(consts.url +
            "/wc/v3/products?per_page=" +
            perPage.toString() +
            "&page=" +
            page.toString() +
            "&" +
            consts.ck +
            "&" +
            consts.cs);

        final List jsonData = await json.decode(response.body);
        // print(json.decode(response.body).length);
        if (jsonData.length == 0) {
          flag = false;
          print(flag);
          return;
        }

        products = List<Product>();
        jsonData.map((data) {
          products.add(Product.fromJson(data));
        });

        yield products;
        page++;
      } catch (e) {
        print(e);
      }
    }
  }

  Future<dynamic> fetchCats() async {
    try {
      http.Response response = await http.get(consts.url +
          "/wc/v3/products/categories?per_page=100" +
          "&" +
          consts.ck +
          "&" +
          consts.cs);
      final List jsondata =
          await json.decode(response.body); //.cast<Map<String, dynamic>>()
      categories = new List<Category>();
      jsondata.forEach((data) {
        categories.add(Category.fromJson(data));
      });
    } catch (e) {
      return null;
    }
    return categories;
  }
}

Future<List> uniqueList(List list) async {
  // print('called');
  final List unique = [];
  for (var i = 0; i < list.length; i++) {
    if (!unique.contains(list[i]['categories'][0]['name'])) {
      unique.add(list[i]['categories'][0]['name']);
    }
    // print(list[i]['categories'][0]['name']);
  }

  return finalComp(unique, list);
}

Future<List> finalComp(List categories, List products) async {
  List masterData = [];
  final List temp = [];
  for (int i = 0; i < categories.length; i++) {
    for (int j = 0; j < products.length; j++) {
      if (categories[i] == products[j]['categories'][0]['name']) {
        temp.add(products[j]);
      }
    }

    Map jsonMap = {categories[i]: temp};

    masterData.add(jsonMap);
  }

  return masterData;
}
