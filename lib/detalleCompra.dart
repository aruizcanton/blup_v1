import 'package:blupv1/model/purchasedProduct.dart';
import 'package:flutter/material.dart';
import 'package:blupv1/colors.dart';
import 'package:intl/intl.dart' show NumberFormat hide TextDirection;
import 'dart:convert';

class DetalleCompra extends StatelessWidget{
  final String jwt;
  final List<PurchasedProduct> listPurchasedProducts;
  final Map<String, dynamic> payload;
  final Map<String, dynamic> infoPurchased;
  DetalleCompra(this.jwt, this.payload, this.listPurchasedProducts, this.infoPurchased);
  factory DetalleCompra.fromBase64(String jwt, List<PurchasedProduct> listPurchasedProducts, Map<String, dynamic>infoPurchased) =>
      DetalleCompra(
          jwt,
          json.decode(
              utf8.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          ),
          listPurchasedProducts,
          infoPurchased
      );
  @override
  Widget build(BuildContext context) {
    print('Comienzo detalleCompra');
    print('El numero de valores que tiene purchasedProducts es: ${listPurchasedProducts.length.toString()}');
    //print('El numero de elementos de listPur: ' + listPurchasedProducts.length.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lBlupBackgroundPreWhite,
        title: Text(
          'Gracias por usar BLUP',
          style: TextStyle(
            color: secondaryTextColor,
          ),
        ),
      ),
      body: Container(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        child: Text('Hola ' + payload['persone_name'].toString().split(' ')[0] + ','),
                      )
                  )
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('Monto Comprado '),
                      )
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(infoPurchased['products_amount']),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      )
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('Monto Comisión'),
                      )
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(infoPurchased['comission_amount']),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      )
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: const Divider(
                  color: kBlupIndigo50,
                  height: 20,
                  thickness: 1,
                  indent: 25,
                  endIndent: 25,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('Total'),
                      )
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(infoPurchased['total_amount']),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      )
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('Fecha en la que se realizará el descuento'),
                      )
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          payload['period_id'].toString().substring(6) + '/' + payload['period_id'].toString().substring(4,6) + '/' + payload['period_id'].toString().substring(0,4),
                          textAlign: TextAlign.right,
                        ),
                      )
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        child: Text(
                          'DETALLES',
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text('Orden')),
                    Expanded(flex: 3,child: Text('Descripción Prod.')),
                    Expanded(child: Text('Coste')),
                    Expanded(child: Text('Comisi.'))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: const Divider(
                  color: kBlupIndigo50,
                  height: 20,
                  thickness: 1,
                  indent: 25,
                  endIndent: 25,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 30),
                child: Container (
                  height: 320,
                  child: ListView.builder(
                    itemCount: listPurchasedProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new PurchaseDetail (listPurchasedProducts[index]);
                    },
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PurchaseDetail extends StatelessWidget {
  final PurchasedProduct purchasedProduct;
  PurchaseDetail (this.purchasedProduct);
  Widget build (BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(5),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: Text(
                purchasedProduct.order_id.toString()
              ),
          ),
          new Expanded(
              flex: 3,
              child: Text(
                  purchasedProduct.product_description
              )
          ),
          new Expanded(
              child: Text(
                  new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(int.parse(purchasedProduct.extracted_amount)),
                  //purchasedProduct.extracted_amount
              )
          ),
          new Expanded(
              child: Text(
                  new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(int.parse(purchasedProduct.comission_amount))
              )
          ),
        ],
      ),
    );
  }
}