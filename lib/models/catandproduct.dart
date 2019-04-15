import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CatAndProduct {
  int id;
  String name;
  List<Product> products;
  CatAndProduct({this.id, this.products, this.name});

  factory CatAndProduct.formJson(Map<String, dynamic> jsonData) {
    List<Product> productList;

    Future getProducts(int id) async {
      var client = new http.Client();
      try {
        var res = await client.get(
            "https://bookabook.co.za/wp-json/wc/v3/products?category="+id.toString()+"&per_page=100&consumer_key=ck_34efa34549443c3706b49f8525947961737748e5&consumer_secret=cs_5a3a24bff0ed2e8c66c8d685cb73680090a44f75&page=1");
        var data = json.decode(res.body);
        var list = data as List;
        productList = list.map<Product>((i) => Product.fromJson(i)).toList();
      } catch (e) {} finally {
        client.close();
      }
    }

    getProducts(jsonData['id']);

    return CatAndProduct(
        id: jsonData['id'], name: jsonData['name'], products: productList);
  }
}

class Product {
  int id;
  String name;
  String stockStatus;
  String price;
  String priceHtml;
  List<Images> images;
  List htmlTags;

  Product(
      {this.id,
      this.name,
      this.stockStatus,
      this.price,
      this.images,
      this.priceHtml});

  factory Product.fromJson(Map<String, dynamic> json) {
    var list = json['images'] as List;
    List<Images> imagesList = list.map((i) => Images.fromJson(i)).toList();

    return Product(
        id: json['id'],
        name: json['name'],
        stockStatus: json['stock_status'],
        price: json['price'],
        images: imagesList);
  }
}

class Images {
  String src;
  Images({this.src});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(src: json['src']);
  }
}
