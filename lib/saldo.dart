import 'package:blupv1/model/FechaCorte.dart';
import 'package:blupv1/model/SaldoHistoDetalleList.dart';
import 'package:blupv1/model/SaldoHistorico.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:blupv1/colors.dart';
import 'package:blupv1/perfil.dart';
import 'package:blupv1/model/SaldoActual.dart';
import 'package:blupv1/model/SaldoActualDetalle.dart';
import 'package:blupv1/model/SaldoHistoDetalle.dart';
import 'package:blupv1/model/SaldoHistoDetalleList.dart';
import 'package:blupv1/utils/util.dart';
import 'package:blupv1/home.dart';
import 'package:blupv1/detalleSaldo.dart';
import 'package:blupv1/detalleSaldoHistorico.dart';
import 'package:blupv1/tienda.dart';
import 'package:blupv1/cambioContraseña.dart';
import 'package:blupv1/cambioPIN.dart';

class Saldo extends StatefulWidget {
  Saldo(this.jwt, this.payload);
  factory Saldo.fromBase64(String jwt) =>
      Saldo(
          jwt,
          json.decode(
              utf8.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          )
      );
  final String jwt;
  final Map<String, dynamic> payload;
  @override
  SaldoState createState() => SaldoState(this.jwt, this.payload);
}
class SaldoState extends State<Saldo> with SingleTickerProviderStateMixin {
  final String jwt;
  final Map<String, dynamic> payload;
  SaldoState(this.jwt, this.payload);

  // Atributos privados
  final List<Tab> myTabs = <Tab>[
    Tab(
      text: 'Saldo actual',
    ),
    Tab(text: 'Historial'),
  ];
  TabController _tabController;
  final PleaseWaitWidget _pleaseWaitWidget =
  PleaseWaitWidget (key: ObjectKey("pleaseWaitWidget"));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<SaldoActual> _saldoActual;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<SaldoHistoDetalle> _saldoHistoDetalleList;
  String _currentPeriodId;
  bool _pleaseWait = false;
  bool _periodIdElegido = false;
  SaldoHistorico _saldoHistorico;
  //bool _visible = false;
  bool _estaCargadaInfo = false;

  _showPleaseWait(bool b) {
    setState(() {
      _pleaseWait = b;
    });
  }

  @override
  void initState(){
    super.initState();
    initializeDateFormatting('es_MX', null);
    _tabController = TabController(vsync: this, length: myTabs.length);
    _saldoActual = _obtenerSaldoActual();
    _pleaseWait = false;
    _saldoHistoDetalleList = new List<SaldoHistoDetalle>();
    _periodIdElegido = false;
    _saldoHistorico = new SaldoHistorico (
      totalDescontado: 0,
      totalRetirado: 0,
      totalFolios: 0,
      totalCuotas: 0
    );
    //_visible = false;
    print('Estoy en el init');
    //print(_saldoActual);
  }

  @override
  void dispose (){
    _tabController.dispose();
    super.dispose();
  }

  Widget _tabSaldoActual (BuildContext context, Tab tab, SaldoActual saldoActual) {
    final String label = tab.text.toLowerCase();

    return ListView (
      padding: EdgeInsets.only(left: 15, right: 15.0, top: 24),
      children: [
        SizedBox(height: 50.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [

              BoxShadow(
                color: Color(0xFFE0E4EE),
                offset: Offset(4.0,4.0),
                spreadRadius: 1.0,
                blurRadius: 15.0,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-4.0, -4.0),
                spreadRadius: 1.0,
                blurRadius: 15.0,
              ),


            ]
          ),
          child: saldoActual.detalle.length > 0
          ? Card(
            clipBehavior: Clip.antiAlias,
            color: colorFondo,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Color(0xFFE5E6ED),
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFD8D9E3),
                        width: 1.0,
                      )
                    )
                  ),
                  //color: Color(0xFF979797),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Total descontado',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Helvetica Neue'
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoActual.totalDescontado),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              fontFamily: 'Helvetica Neue',
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                      color: colorFondo,
                      border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFD8D9E3),
                            width: 1.0,
                          )
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Monto total retirado',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              fontFamily: 'Helvetica Neue',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoActual.totalRetirado),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Helvetica Neue',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                      color: colorFondo,
                      border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFD8D9E3),
                            width: 1.0,
                          )
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Monto total folios',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              fontFamily: 'Helvetica Neue',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoActual.totalFolios),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Helvetica Neue',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                      color: colorFondo,
                      border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFD8D9E3),
                            width: 1.0,
                          )
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Monto total cuotas',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              fontFamily: 'Helvetica Neue',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoActual.totalCuotas),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Helvetica Neue',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 64.5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => DetalleSaldo(saldoActual, 0),     // 0 porque lo llamo desde la tab de saldo actual
                              ));
                            },
                            child: Text(
                              'Ver retiros realizados',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Helvetica Neue',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
          : Card(
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
                  'Todavía no hay movimientos',
                  style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w700,
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
                  'del período de tu nómina actual',
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
          )
          ,
        ),
      ],
    );
  }

  Widget _tabHistorial (BuildContext context, Tab tab, SaldoActual saldoActual) {
    final String label = tab.text.toLowerCase();
    List<DropdownMenuItem<String>> items = new List();

    print ('Estoy en _tabHistorial');
    Widget myBuilder = Builder(
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(height: 24),
                Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownButtonFormField(
                          hint: Text(
                            'Elije una fecha de corte',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              fontFamily: 'SF Pro Display',
                            ),
                            textAlign: TextAlign.right,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'SF Pro Display',
                          ),
                          elevation: 16,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black54,
                                ),
                              ),
                              hintStyle: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                          iconEnabledColor: Colors.black,
                          value: _currentPeriodId,
                          onChanged: (String newValue) async{

                            _showPleaseWait(true);
                            try {
                              //_showPleaseWait(true);
                              print('Entro en el RECUPERAR HISTORICO');
                              final String cadena = "$SERVER_IP/getSaldoHistorico/" +
                                  payload['empleado_id'].toString() + "/" +
                                  newValue;
                              print('La cadena es: ' + cadena);
                              final http.Response res = await http.get(
                                  cadena,
                                  headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                    'Authorization': jwt
                                  }
                              );
                              if (res.statusCode == 200) {
                                // Todo ha ido bien
                                _showPleaseWait(false);
                                print('Antes de imprimir el body');
                                print(res.body);
                                print('Despues de imprimir el body');
                                //////////

                                final int totalDescontado = int.parse(json.decode(res.body)['totalDescontado'].toString());
                                print('El totalDescontado es: ' + totalDescontado.toString());
                                final int totalCuotas = int.parse(json.decode(res.body)['totalCuotas'].toString());
                                print('El totalCuotas es: ' + totalDescontado.toString());
                                final int totalRetirado = int.parse(json.decode(res.body)['totalRetirado'].toString());
                                print('El totalRetirado es: ' + totalDescontado.toString());
                                final int totalFolios = int.parse(json.decode(res.body)['totalFolios']);
                                print('El totalFolios es: ' + totalDescontado.toString());
                                print('Antes de crear el objeto SaldoActual');
                                print ('Antes de retornar');
                                ///////////
                                final parsedSaldoHistoDetalle = json.decode(res.body)['detalle'].cast<Map<String, dynamic>>();
                                //var saldoHistoDetalleList = context.read<SaldoHistoDetalleList>();
                                //saldoHistoDetalleList.removeAll();
                                setState(() {
                                  _saldoHistoDetalleList = parsedSaldoHistoDetalle.map<SaldoHistoDetalle>((json) => SaldoHistoDetalle.fomJson(json)).toList();
                                  _saldoHistorico = new SaldoHistorico(
                                      totalDescontado: totalDescontado,
                                      totalRetirado: totalRetirado,
                                      totalFolios: totalFolios,
                                      totalCuotas: totalCuotas,
                                      detalle: _saldoHistoDetalleList
                                  );
                                  _periodIdElegido = true;
                                });
                                //_visible = true;
                                //for (var i = 0; i< _saldoHistoDetalleList.length; i++){
                                //  saldoHistoDetalleList.add(_saldoHistoDetalleList[i]);
                                //}
                                //_saldoHistoDetalleList.map((item) => saldoHistoDetalleList.add(item));
                              } else if (res.statusCode == 404) {
                                _showPleaseWait(false);
                                print('Paso por el token caducado');
                                //Navigator.pop(context);
                                Navigator.pushNamed(context, '/login');
                              } else {
                                _showPleaseWait(false);
                                print('Error ' + res.statusCode.toString() + ':' + json.decode(res.body)['message'].toString());
                                _showSnackBar(res.statusCode.toString() + ': ' +
                                    json.decode(res.body)['message'].toString(),
                                    error: false);
                              }
                            } catch (e) {
                              _showPleaseWait(false);
                              print(e.toString());
                              _showSnackBar(e.toString(), error: false);
                            }
                          },
                          items: saldoActual.fechaCortes.map<DropdownMenuItem<String>>((FechaCorte e) {
                            return DropdownMenuItem<String>(
                              value: e.periodoId,
                              child: Text(e.periodoId.substring(6, 8) + '/' +
                                  e.periodoId.substring(4, 6) + '/' +
                                  e.periodoId.substring(0, 4)),
                            );
                          }).toList(),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 24.0),
                Container(
                  child: _periodIdElegido
                  ? Card(
                    clipBehavior: Clip.antiAlias,
                    color: colorFondo,
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                              color: Color(0xFFE5E6ED),
                              border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFD8D9E3),
                                    width: 1.0,
                                  )
                              )
                          ),
                          //color: Color(0xFF979797),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Total descontado',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Helvetica Neue'
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(_saldoHistorico.totalDescontado),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Helvetica Neue',
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                              color: colorFondo,
                              border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFD8D9E3),
                                    width: 1.0,
                                  )
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Monto total retirado',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      fontFamily: 'Helvetica Neue',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(_saldoHistorico.totalRetirado),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Helvetica Neue',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                              color: colorFondo,
                              border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFD8D9E3),
                                    width: 1.0,
                                  )
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Monto total folios',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      fontFamily: 'Helvetica Neue',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(_saldoHistorico.totalFolios),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Helvetica Neue',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                              color: colorFondo,
                              border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFD8D9E3),
                                    width: 1.0,
                                  )
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Monto total cuotas',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      fontFamily: 'Helvetica Neue',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(_saldoHistorico.totalCuotas),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Helvetica Neue',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 64.5,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => DetalleSaldoHistorico(_saldoHistorico, 1), // 1 porque lo llamo desde la tab de histórico
                                      ));
                                    },
                                    child: Text(
                                      'Ver retiros realizados',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Helvetica Neue',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [

                          BoxShadow(
                            color: Color(0xFFE0E4EE),
                            offset: Offset(4.0,4.0),
                            spreadRadius: 1.0,
                            blurRadius: 15.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4.0, -4.0),
                            spreadRadius: 1.0,
                            blurRadius: 15.0,
                          ),


                        ]
                    ),
                    child: Card(
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
                            'Todavía no hay movimientos',
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.w700,
                                fontSize: 24
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox (height: 16,),
                          Text(
                            'Elije una fecha de pago de la nómina.',
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                fontStyle: FontStyle.italic
                            ),
                            textAlign: TextAlign.center,
                          ),
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
                            'del período de tu nómina elegido',
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
                  )
                ),
                SizedBox(height: 24.0),
              ],
            ),
          );
        }
    );
    Widget bodyWidget = _pleaseWait
        ? Stack(key: ObjectKey("stack"), children: [myBuilder, _pleaseWaitWidget])
        : Stack(key: ObjectKey("stack"), children: [myBuilder]);
    return bodyWidget;
  }

  _showSnackBar(String content, {bool error = false}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text('${error ? "Ocurrió un error: " : ""}${content}'),
    ));
  }
  Future<SaldoActual> _obtenerSaldoActual () async {
    try {
      //_showPleaseWait(true);
      final String cadena = "$SERVER_IP/getSaldoActual/" +
          payload['empleado_id'].toString() + "/" +
          payload['period_id'].toString();
      print ('La cadena es: ' + cadena);
      final http.Response res = await http.get(
          cadena,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': jwt
          }
      );
      if (res.statusCode == 200) {
        // Todo ha ido bien
        //_showPleaseWait(false);
        print('Antes de imprimir el body');
        print(res.body);
        print('Despues de imprimir el body');
        final int totalDescontado = int.parse(json.decode(res.body)['totalDescontado'].toString()) as int;
        print('El totalDescontado es: ' + totalDescontado.toString());
        final int totalCuotas = int.parse(json.decode(res.body)['totalCuotas'].toString()) as int;
        print('El totalCuotas es: ' + totalDescontado.toString());
        final int totalRetirado = int.parse(json.decode(res.body)['totalRetirado'].toString()) as int;
        print('El totalRetirado es: ' + totalDescontado.toString());
        final int totalFolios = int.parse(json.decode(res.body)['totalFolios']) as int;
        print('El totalFolios es: ' + totalDescontado.toString());
        final parsedSaldoActualDetalle = json.decode(res.body)['detalle'].cast<Map<String, dynamic>>();
        print('Un paso más');
        final List<SaldoActualDetalle> saldoActualDetalleList = parsedSaldoActualDetalle.map<SaldoActualDetalle>((json) => SaldoActualDetalle.fomJson(json)).toList();
        print('Dos pasos más');
        final parsedFechaCortes = json.decode(res.body)['fechaCortes'].cast<Map<String, dynamic>>();
        final List<FechaCorte> fechaCortesList = parsedFechaCortes.map<FechaCorte>((json) => FechaCorte.fomJson(json)).toList();
        print(cadena);
        print(res.body);
        print('Antes de crear el objeto SaldoActual');
        var saldoActual = new SaldoActual(
            totalDescontado: totalDescontado,
            totalCuotas: totalCuotas,
            totalRetirado: totalRetirado,
            totalFolios: totalFolios,
            detalle: saldoActualDetalleList,
            fechaCortes: fechaCortesList
        );
        print(saldoActual);
        print(saldoActual.totalRetirado.toString());
        print(saldoActual.totalDescontado.toString());
        print(saldoActual.totalCuotas.toString());
        print(saldoActual.totalFolios.toString());
        print ('Antes de retornar');
        return saldoActual;
      } else if (res.statusCode == 404) {
        print ('Paso por el token caducado');
        Navigator.pushNamed(context, '/login');
        //throw Exception('Token caducado.');
      } else {
        throw Exception(res.statusCode.toString() + ": " + json.decode(res.body)['message'].toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 48),
              child: Container(
                alignment: Alignment.center,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                    ),
                    BoxShadow(
                        color: colorCajasTexto,
                        spreadRadius: -2.0,
                        blurRadius: 3
                    )
                  ],
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            )
          ],
        ),
        leading: Builder(
            builder: (BuildContext context){
              return Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left: 32.0),
                child: IconButton(
                  padding: EdgeInsets.all(0.0),
                  color: Colors.black,
                  icon: Image.asset('assets/menuAppBar.png'),
                  onPressed: () { Scaffold.of(context).openDrawer(); },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              );
            }
        ),
        backgroundColor: colorCajasTexto,
        brightness: Brightness.light,
//        textTheme: ,
        title: Image.asset ('assets/KlincLogoAppBar.png'),
        bottom: TabBar (
          controller: _tabController,
          tabs: myTabs,
          indicatorWeight: 2.0,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(0),
          indicatorColor: Color(0xFF8E23EF),
          labelStyle: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 32.0),
            child: IconButton(
              padding: EdgeInsets.all(0.0),
              icon: Image.asset('assets/campanaAppBar.png'),
              color: Colors.black,
              onPressed: () {
                print('Filter button');
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<SaldoActual>(
        future: _saldoActual,
        builder: (context, snapshot) {
          try {
            if (snapshot.hasData) {
              return new TabBarView (
                controller: _tabController,
                children: [
                  _tabSaldoActual(context, myTabs[0], snapshot.data),
                  _tabHistorial(context, myTabs[1], snapshot.data)
                  //new Center(
                  //  child: Text('Hola'),
                  //)
                ],
              );
            } else if (snapshot.hasError) {
              //if (snapshot.error.toString() == "Token caducado.") {
              //_showSnackBar(snapshot.error.toString(), error: false);
              //Navigator.pop(context);
              //Navigator.pushNamed(context, '/login');
              //} else {
              //  _showSnackBar(snapshot.error.toString(), error: false);
              //}
              print('Hay un error. El error es: ' + "${snapshot.error}");
            } else {
              return _pleaseWaitWidget;
            }
          } catch(e){
            _showSnackBar(snapshot.error.toString(), error: false);
            //Navigator.pop(context);
            Navigator.pushNamed(context, '/login');
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 80.0,
              child:DrawerHeader(
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(0.0),
                  child: Container(
                    //padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                    //height: 48.0,
                    child: Image.asset('assets/KlinkLogoDrawMenu.png'),
                  )
              ),
            ),
            ListTile(
                leading: Image.asset('assets/perfilNombreUsuario.png'),
                title: Text(
                  'Perfil',
                  style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal
                  ),
                ),
                shape: Border(bottom: BorderSide(color: Color(0xFFD8D9E3))),
                onTap: () {
                  Navigator.pushReplacement (
                      context,
                      MaterialPageRoute(
                        builder: (context) => Perfil(jwt, payload),
                      )
                  );
                }
            ),
            ListTile(
                leading: Image.asset('assets/candadoDrawer.png'),
                title: Text(
                  'Cambio contraseña',
                  style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal
                  ),
                ),
                shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
                onTap: () {
                  Navigator.push (
                      context,
                      MaterialPageRoute(
                        builder: (context) => CambioContrasenya(payload['email']),
                      )
                  );
                }
            ),
            ListTile(
                leading: Image.asset('assets/candadoDrawer.png'),
                title: Text(
                  'Cambio PIN',
                  style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal
                  ),
                ),
                shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
                onTap: () {
                  Navigator.push (
                      context,
                      MaterialPageRoute(
                        builder: (context) => CambioPin(payload['email']),
                      )
                  );
                }
            ),
            ListTile(
              leading: Image.asset('assets/soporteDrawer.png'),
              title: Text(
                'Soporte',
                style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal
                ),
              ),
              shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
            ),
            // ListTile(
            //   leading: Image.asset('assets/ganaRetirosDrawer.png'),
            //   title: Text(
            //     'Gana Retiros',
            //     style: TextStyle(
            //         fontFamily: 'Helvetica Neue',
            //         fontSize: 16,
            //         fontStyle: FontStyle.normal,
            //         fontWeight: FontWeight.normal
            //     ),
            //   ),
            //   shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
            // ),
            ListTile(
              leading: Image.asset('assets/preguntasFreqDrawer.png'),
              title: Text(
                'Preguntas frecuentes',
                style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal
                ),
              ),
              shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
            ),
            ListTile(
              leading: Image.asset('assets/terminosYCondiDrawer.png'),
              title: Text(
                'Términos y condiciones',
                style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal
                ),
              ),
              shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
            )
          ],
        ),
      ),
      bottomNavigationBar: _BottonNavigationBar(jwt: jwt, payload: payload),
    );
  }
}
class _BottonNavigationBar extends StatefulWidget {
  final String jwt;
  final Map<String, dynamic> payload;
  _BottonNavigationBar({this.jwt, this.payload});

  @override
  _BottonNavigationBarState createState() {
    return _BottonNavigationBarState(this.jwt, this.payload);
  }
}
class _BottonNavigationBarState extends State<_BottonNavigationBar>{
  final String jwt;
  final Map<String, dynamic> payload;
  @override
  _BottonNavigationBarState(this.jwt, this.payload);
  Widget _iconRetiroOn = Image.asset('assets/retiroOnBottonNavBar.png');
  Widget _iconRetiroOff = Image.asset('assets/retiroOffBottonNavBar.png');
  Widget _iconTiendaOn = Image.asset('assets/tiendaOnBottonNavBar.png');
  Widget _iconTiendaOff = Image.asset('assets/tiendaOffBottonNavBar.png');
  Widget _iconSaldoOn = Image.asset('assets/saldoOnBottonNavBar.png');
  Widget _iconSaldoOff = Image.asset('assets/saldoOffBottonNavBar.png');
  Widget _iconPerfilOn = Image.asset('assets/perfilOnBottonNavBar.png');
  Widget _iconPerfilOff = Image.asset('assets/perfilOffBottonNavBar.png');
  Widget _iconRetiro;
  Widget _iconTienda;
  Widget _iconSaldo;
  Widget _iconPerfil;
  Color _textRetiroOn = Color(0xFF4895F6);
  Color _textRetiroOff = Color(0xFFADB0C7);
  Color _textTiendaOn = Color(0xFF4895F6);
  Color _textTiendaOff = Color(0xFFADB0C7);
  Color _textSaldoOn = Color(0xFF4895F6);
  Color _textSaldoOff = Color(0xFFADB0C7);
  Color _textPerfilOn = Color(0xFF4895F6);
  Color _textPerfilOff = Color(0xFFADB0C7);
  Color _textRetiro = Color(0xFF4895F6);
  Color _textTienda = Color(0xFFADB0C7);
  Color _textSaldo = Color(0xFFADB0C7);
  Color _textPerfil = Color(0xFFADB0C7);
  FontWeight _fontOn = FontWeight.bold;
  FontWeight _fontOff = FontWeight.normal;
  FontWeight _fontWeightRetiro;
  FontWeight _fontWeightTienda;
  FontWeight _fontWeightSaldo;
  FontWeight _fontWeightPerfil;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _iconRetiro = _iconRetiroOff;
    _textRetiro = _textRetiroOff;
    _fontWeightRetiro = _fontOff;
    _iconTienda = _iconTiendaOff;
    _textTienda = _textTiendaOff;
    _fontWeightTienda = _fontOff;
    _iconSaldo = _iconSaldoOn;
    _textSaldo = _textSaldoOn;
    _fontWeightSaldo = _fontOn;
    _iconPerfil = _iconPerfilOff;
    _textPerfil = _textPerfilOff;
    _fontWeightPerfil = _fontOff;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
          height: 70,
          padding: EdgeInsets.only(top: 2, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton (
                    icon: _iconRetiro,
                    onPressed: () {
                      setState(() {
                        _iconRetiro = _iconRetiroOn;
                        _textRetiro = _textRetiroOn;
                        _fontWeightRetiro = _fontOn;
                        _iconTienda = _iconTiendaOff;
                        _textTienda = _textTiendaOff;
                        _fontWeightTienda = _fontOff;
                        _iconSaldo = _iconSaldoOff;
                        _textSaldo = _textSaldoOff;
                        _fontWeightSaldo = _fontOff;
                        _iconPerfil = _iconPerfilOff;
                        _textPerfil = _textPerfilOff;
                        _fontWeightPerfil = _fontOff;

                        print ('Paso por el click de Retiro');
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => HomePage(jwt, payload),
                        ));
                      });
                    },
                    padding: EdgeInsets.all(0.0),
                    constraints: BoxConstraints(maxWidth: 24.0, maxHeight: 24.0),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 2.0),
                  Text(
                      'Retiro',
                      style: TextStyle(
                        color: _textRetiro,
                        fontFamily: 'Helvetica Neue',
                        fontWeight: _fontWeightRetiro,
                        fontSize: 16,
                      )
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton (
                    icon: _iconTienda,
                    onPressed: () {
                      setState(() {
                        _iconRetiro = _iconRetiroOff;
                        _textRetiro = _textRetiroOff;
                        _fontWeightRetiro = _fontOff;
                        _iconTienda = _iconTiendaOn;
                        _textTienda = _textTiendaOn;
                        _fontWeightTienda = _fontOn;
                        _iconSaldo = _iconSaldoOff;
                        _textSaldo = _textSaldoOff;
                        _fontWeightSaldo = _fontOff;
                        _iconPerfil = _iconPerfilOff;
                        _textPerfil = _textPerfilOff;
                        _fontWeightPerfil = _fontOff;
                        print('Paso por el Click de Tienda');
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => Tienda(jwt, payload),
                        ));
                      });
                    },
                    padding: EdgeInsets.all(0.0),
                    constraints: BoxConstraints(maxWidth: 29.0, maxHeight: 24.0),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 2.0),
                  Text(
                      'Tienda',
                      style: TextStyle(
                        color: _textTienda,
                        fontFamily: 'Helvetica Neue',
                        fontWeight: _fontWeightTienda,
                        fontSize: 16,
                      )
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton (
                    icon: _iconSaldo,
                    onPressed: (){
                    },
                    padding: EdgeInsets.all(0.0),
                    constraints: BoxConstraints(maxWidth: 24.0, maxHeight: 20.0),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 2.0),
                  Text(
                      'Saldo',
                      style: TextStyle(
                        color: _textSaldo,
                        fontFamily: 'Helvetica Neue',
                        fontWeight: _fontWeightTienda,
                        fontSize: 16,
                      )
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton (
                    icon: _iconPerfil,
                    onPressed: (){
                      setState(() {
                        _iconRetiro = _iconRetiroOff;
                        _textRetiro = _textRetiroOff;
                        _fontWeightRetiro = _fontOff;
                        _iconTienda = _iconTiendaOff;
                        _textTienda = _textTiendaOff;
                        _fontWeightTienda = _fontOff;
                        _iconSaldo = _iconSaldoOff;
                        _textSaldo = _textSaldoOff;
                        _fontWeightSaldo = _fontOff;
                        _iconPerfil = _iconPerfilOn;
                        _textPerfil = _textPerfilOn;
                        _fontWeightPerfil = _fontOn;
                      });
                      print ('Paso por el click de Perfil');
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Perfil(jwt, payload),
                      ));
                    },
                    padding: EdgeInsets.only(bottom: 0.0),
                    constraints: BoxConstraints(maxWidth: 22.0, maxHeight: 22.0),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 2.0),
                  Text(
                      'Perfil',
                      style: TextStyle(
                        color: _textPerfil,
                        fontFamily: 'Helvetica Neue',
                        fontWeight: _fontWeightPerfil,
                        fontSize: 16,
                      )
                  ),
                ],
              )
            ],
          )
      ),
    );
  }
}
class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This gets the current state of SaldoHistoDetalleList and also tells Flutter
    // to rebuild this widget when SaldoHistoDetalleList notifies listeners (in other words,
    // when it changes).
    var saldoHistoDetalleList = context.watch<SaldoHistoDetalleList>();
    if (saldoHistoDetalleList.numElements == 0) {
      //No existe historico
      return ListView(
        children: [
          Center(
            child: Text(
              'No existen elementos.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

          )
        ],
      );
    } else {
      return ListView.builder(
          itemCount: saldoHistoDetalleList.numElements,
          itemBuilder: (BuildContext context, int index){
            var mysaldoHistoDetalleList = saldoHistoDetalleList.items;
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: Column(
                  children: [
                    Text(
                      DateFormat('dd', 'es_MX').format(mysaldoHistoDetalleList[index].create_date),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      DateFormat('MMM', 'es_MX').format(mysaldoHistoDetalleList[index].create_date),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm', 'es_MX').format(mysaldoHistoDetalleList[index].create_date),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  mysaldoHistoDetalleList[index].description,
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
                                text: mysaldoHistoDetalleList[index].transaction_id.toString(),
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
                                text: DateFormat('dd/MM/yy', 'es_MX').format(mysaldoHistoDetalleList[index].exp_date),
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
                      NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(mysaldoHistoDetalleList[index].extracted_amount),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Cuota: ' + NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(mysaldoHistoDetalleList[index].comission_amount),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      mysaldoHistoDetalleList[index].tipo,
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
      );
    }
  }
}