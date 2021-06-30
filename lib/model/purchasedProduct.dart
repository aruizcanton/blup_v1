import 'dart:convert';

import 'package:flutter/foundation.dart';

class PurchasedProduct {
  final String order_id;
  final int day;
  final String hour;
  final String period_id;
  final String acct_no;
  final int agr_salary;
  final String max_salary;
  final String extracted_amount;
  final String comission_amount;
  final int product_id;
  final String product_name;
  final String product_code;
  final String product_description;
  final String product_type;
  final String brand;
  final String image;
  final String avail;
  final String product_price;
  final String comission;
  final String remark;
  PurchasedProduct({this.order_id, this.day, this.hour, this.period_id, this.acct_no, this.agr_salary, this.max_salary, this.extracted_amount,
      this.comission_amount, this.product_id, this.product_name, this.product_code, this.product_description, this.product_type, this.brand, this.image,
      this.avail, this.product_price, this.comission, this.remark});
  factory PurchasedProduct.fomJson(Map<String, dynamic> json) {
    return PurchasedProduct(
      order_id: json['ORDER_ID'] as String,
      day: json['DAY'] as int,
      hour: json['HOUR'] as String,
      period_id: json['PERIOD_ID'] as String,
      acct_no: json['ACCT_NO'] as String,
      agr_salary: json['AGR_SALARY'] as int,
      max_salary: json['MAX_SALARY'] as String,
      extracted_amount: json['EXTRACTED_AMOUNT'] as String,
      comission_amount: json['COMISSION_AMOUNT'] as String,
      product_id: json['PRODUCT_ID'] as int,
      product_name: json['PRODUCT_NAME'] as String,
      product_code: json['PRODUCT_CODE'] as String,
      product_description: json['PRODUCT_DESCRIPTION'] as String,
      product_type: json['PRODUCT_TYPE'] as String,
      brand: json['BRAND'] as String,
      image: json['IMAGE'] as String,
      avail: json['AVAIL'] as String,
      product_price: json['PRODUCT_PRICE'] as String,
      comission: json['COMISSION'] as String,
      remark: json['REMARK'] as String,
    );
  }
}