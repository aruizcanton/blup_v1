import 'package:flutter/material.dart';
import 'package:blupv1/colors.dart';
import 'dart:convert';
import 'package:intl/intl.dart' show NumberFormat hide TextDirection;

class DetalleRetiro extends StatelessWidget {
  DetalleRetiro(this.jwt, this.datosRetiro, this.payload);
  factory DetalleRetiro.fromBase64(String jwt, Map<String, dynamic> datosRetiro) =>
      DetalleRetiro(
          jwt,
          datosRetiro,
          json.decode(
              utf8.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          )
      );
  final String jwt;
  final Map<String, dynamic> datosRetiro;
  final Map<String, dynamic> payload;
  @override
  Widget build(BuildContext context) {
    print('Comienzo detalleRetiro');
    print(datosRetiro);
    print('Después de imprimir le detalle');
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: Builder (
              builder: (BuildContext context){
                return Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(left: 32.0),
                  child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    color: Colors.black,
                    icon: Image.asset('assets/flecha-izquierda.png'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                );
              }
          ),
          backgroundColor: colorCajasTexto,
          brightness: Brightness.light,
          title: Text(
            'Gracias por usar KLINC',
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 40.0),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                        child: RichText(
                          text: TextSpan(
                            text: 'Hola ',
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: payload['user_firstname'].toString().split(' ')[0],
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: ',',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black
                                ),
                              ),
                            ]
                          ),
                        ),
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
                        child: Text(
                          'Monto Retirado ',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            color: Colors.black
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(datosRetiro['extracted_amount']),
                          style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              color: Colors.black
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
                        child: Text(
                          'Cuota por retiro',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            color: Colors.black
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(datosRetiro['comission_amount']),
                          style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              color: Colors.black
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
                        child: Text(
                          'Total',
                          style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              color: Colors.black
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(datosRetiro['extracted_amount'] + datosRetiro['comission_amount']),
                          style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              color: Colors.black
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
                        child: Text(
                          'DETALLES',
                          style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black
                          ),
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
                        child: Text('Fecha de retiro'),
                      )
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          datosRetiro['day'].toString().substring(6) + '/' + datosRetiro['day'].toString().substring(4,6) + '/' + datosRetiro['day'].toString().substring(0,4) + ' ' + datosRetiro['hour'],
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
                          datosRetiro['payroll_day'].toString().substring(6) + '/' + datosRetiro['payroll_day'].toString().substring(4,6) + '/' + datosRetiro['payroll_day'].toString().substring(0,4),
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
                        child: Text('Tu cuenta'),
                      )
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          payload['acct_no'],
                          textAlign: TextAlign.right,
                        ),
                      )
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  Expanded (
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('Folio'),
                      )
                  ),
                  Expanded (
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          datosRetiro['transaction_id'].toString(),
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
                          'Gracias.',
                          style: const TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            color: Colors.black,
                          ),
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
                        child: RichText(
                          text: TextSpan(
                              text: 'El equipo de ',
                              style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'KLINC',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro Display',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ]
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}
