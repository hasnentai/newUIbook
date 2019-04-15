import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class ProductService {
  int id;
  String name;
  String stockStatus;
  String price;
  String priceHtml;
  String status;
  int totalSales;
  List<Images> images;

  ProductService(
      {this.id,
      this.name,
      this.stockStatus,
      this.price,
      this.images,
      this.priceHtml,
      this.totalSales,
      this.status});

  factory ProductService.fromJson(Map<String, dynamic> json) {
    var list = json['images'] as List;
    List<Images> imagesList = list.map((i) => Images.fromJson(i)).toList();

    var document = parse(json['price_html']);
    var priceElement = document.getElementsByClassName("amount");
    var bookPrice;
    if (priceElement.length > 1) {
      print(priceElement[0].text + " - " + priceElement[1].text);
      bookPrice =priceElement[0].text + " - " + priceElement[1].text;
    } else {
      bookPrice ="N/A";
    }
    // print(priceElement[0].text + " - "+ priceElement[1].text);

    return ProductService(
      id: json['id'],
      name: json['name'],
      stockStatus: json['stock_status'],
      price: json['price'],
      images: imagesList,
      totalSales: json['total_sales'],
      status: json['status'],
      priceHtml: bookPrice
    );
  }
}

class Images {
  String src;
  Images({this.src});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(src: json['src']);
  }
}

class Attributes {
  String id;
}
