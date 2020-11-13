import 'package:blupv1/model/SaldoHistoDetalleList.dart';
import 'package:blupv1/model/SaldoHistorico.dart';
import 'package:flutter/material.dart';
import 'package:blupv1/colors.dart';
import 'dart:convert';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


import 'package:blupv1/model/SaldoActual.dart';
import 'package:blupv1/model/SaldoActualDetalle.dart';

class DetalleSaldoHistorico extends StatelessWidget {
  final SaldoHistorico saldoHistorico;
  final int origenDeLaLLamada;  // 0: se hace la llamada desde la Tab de saldo actual. 1: se hace la llamada desde la Tab de saldo histórico.
  DetalleSaldoHistorico(this.saldoHistorico, this.origenDeLaLLamada);
  @override
  Widget build(BuildContext context) {
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
        ),
        body: saldoHistorico.detalle.length > 0
            ? Container (
          child: ListView.builder(
              padding: EdgeInsets.only(left: 15, right: 15.0, top: 24),
              itemCount: saldoHistorico.detalle.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Column(
                      children: [
                        Text(
                          DateFormat('dd', 'es_MX').format(saldoHistorico.detalle[index].create_date),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          DateFormat('MMM', 'es_MX').format(saldoHistorico.detalle[index].create_date),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm', 'es_MX').format(saldoHistorico.detalle[index].create_date),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      saldoHistorico.detalle[index].description,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: 'Folio: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: saldoHistorico.detalle[index].transaction_id.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                              ]
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                              text: 'Vigencia: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: DateFormat('dd/MM/yy', 'es_MX').format(saldoHistorico.detalle[index].exp_date) == '01/01/00' ? 'No aplica' : DateFormat('dd/MM/yy', 'es_MX').format(saldoHistorico.detalle[index].exp_date),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )
                                )
                              ]
                          ),
                        )
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoHistorico.detalle[index].extracted_amount),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Cuota: ' + NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoHistorico.detalle[index].comission_amount),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          saldoHistorico.detalle[index].tipo,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          ),
        )
            : Container(
          child: ListView(
            padding: EdgeInsets.only(left: 15, right: 15.0, top: 24),
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                color: colorFondo,
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Image.asset('assets/detalleSaldoFactura.png'),
                    SizedBox(height: 40),
                    Text(
                      origenDeLaLLamada == 0 ? 'Todavía no hay movimientos' : 'No hay movimientos en el histórico',
                      style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          fontSize: 25
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox (height: 16,),
                    Text(
                      'Aquí podrás ver el resumen de los retiros',
                      style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          fontStyle: FontStyle.italic
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'hechos y saldos ',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      origenDeLaLLamada == 0 ? 'del período de tu nómina actual' : 'del histórico elegido de tu nómina',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}