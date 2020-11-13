import 'package:flutter/foundation.dart';

class Product {
  const Product({
    @required this.product_id,
    @required this.poduct_name,
    @required this.poduct_description,
    @required this.product_type,
    @required this.brand,
    @required this.image,
    @required this.avail,
    @required this.product_price,
    @required this.comission,
    @required this.remark
  })  : assert(product_id != null),
        assert(poduct_name != null),
        assert(poduct_description != null),
        assert(product_type != null),
        assert(brand != null),
        assert(image != null),
        assert(avail != null),
        assert(product_price != null),
        assert(comission != null);

  final int product_id;
  final String poduct_name;
  final String poduct_description;
  final String product_type;
  final String brand;
  final String image;
  final int avail;
  final int product_price;
  final int comission;
  final String remark;

  factory Product.fomJson(Map<String, dynamic> json) {
    return Product(
      product_id: int.parse(json['PRODUCT_ID']),
      poduct_name : json['PRODUCT_NAME'],
      poduct_description : json['PRODUCT_DESCRIPTION'],
      product_type: json['PRODUCT_TYPE'],
      brand: json['BRAND'],
      image: json['IMAGE'],
      avail: int.parse(json['AVAIL']),
      product_price: int.parse(json['PRODUCT_PRICE']),
      comission: int.parse(json['COMISSION']),
      remark: json['REMARK']
    );
  }
}