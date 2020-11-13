import 'package:flutter/foundation.dart';

class ProductComprado {
  const ProductComprado({
    @required this.product_id,
    @required this.order_id,
    @required this.product_name,
    @required this.product_description,
    @required this.product_type,
    @required this.brand,
    @required this.image,
    @required this.avail,
    @required this.product_price,
    @required this.comission,
    @required this.remark
  })  : assert(product_id != null),
        assert(order_id != null),
        assert(product_name != null),
        assert(product_description != null),
        assert(product_type != null),
        assert(brand != null),
        assert(image != null),
        assert(avail != null),
        assert(product_price != null),
        assert(comission != null);

  final int product_id;
  final String order_id;
  final String product_name;
  final String product_description;
  final String product_type;
  final String brand;
  final String image;
  final int avail;
  final int product_price;
  final int comission;
  final String remark;

  factory ProductComprado.fomJson(Map<String, dynamic> json) {
    return ProductComprado(
        product_id: int.parse(json['PRODUCT_ID']),
        order_id: json['ORDER_ID'],
        product_name : json['PRODUCT_NAME'],
        product_description : json['PRODUCT_DESCRIPTION'],
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