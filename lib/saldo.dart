import 'package:blupv1/model/FechaCorte.dart';
import 'package:blupv1/model/SaldoHistoDetalleList.dart';
import 'package:blupv1/model/SaldoHistorico.dart';
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
    Tab(text: 'SALDO ACTUAL'),
    Tab(text: 'HISTORIAL'),
  ];
  TabController _tabController;
  final PleaseWaitBlueBackGroundLittelDownWidget _pleaseWaitWidget =
  PleaseWaitBlueBackGroundLittelDownWidget (key: ObjectKey("pleaseWaitWidget"));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<SaldoActual> _saldoActual;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<SaldoHistoDetalle> _saldoHistoDetalleList;
  String _currentPeriodId;
  bool _pleaseWait = false;
  bool _periodIdElegido = false;
  SaldoHistorico _saldoHistorico;
  bool _visible = false;
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
    _saldoHistorico= new SaldoHistorico(
      totalDescontado: 0,
      totalRetirado: 0,
      totalFolios: 0,
      totalCuotas: 0
    );
    _visible = false;
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
      children: [
        Card(
            clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Saldo',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 25
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoActual.totalDescontado),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 25
                        ),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Card (
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Monto total retirado',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoActual.totalRetirado),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(
                  color: kBlupIndigo50,
                  height: 20,
                  thickness: 1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Monto total folios',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoActual.totalFolios),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(
                  color: kBlupIndigo50,
                  height: 20,
                  thickness: 1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Monto total cuotas',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoActual.totalCuotas),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card (
          color: lBlupBackgroundPreWhite,
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding (
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                child: Text(
                  'Detalle:',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5.0),
                height: 300,
                child: saldoActual.detalle.length == 0
                    ? ListView(
                        children: [
                          Center(
                            child: Text(
                              'No existen elementos.',
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            ),
                          )]
                      )
                    : ListView.builder(
                    itemCount: saldoActual.detalle.length,
                    itemBuilder: (BuildContext context, int index){
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Column(
                            children: [
                              Text(
                                DateFormat('dd', 'es_MX').format(saldoActual.detalle[index].create_date),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                DateFormat('MMM', 'es_MX').format(saldoActual.detalle[index].create_date),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                DateFormat('HH:mm', 'es_MX').format(saldoActual.detalle[index].create_date),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            saldoActual.detalle[index].description,
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
                                      text: saldoActual.detalle[index].transaction_id.toString(),
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
                                      text: DateFormat('dd/MM/yy', 'es_MX').format(saldoActual.detalle[index].exp_date) == '01/01/00' ? 'No aplica' : DateFormat('dd/MM/yy', 'es_MX').format(saldoActual.detalle[index].exp_date),
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
                                NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoActual.detalle[index].extracted_amount),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'Cuota: ' + NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoActual.detalle[index].comission_amount),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                saldoActual.detalle[index].tipo,
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabHistorial (BuildContext context, Tab tab, SaldoActual saldoActual) {
    final String label = tab.text.toLowerCase();
    List<DropdownMenuItem<String>> items = new List();

    print ('Estoy en _tabHistorial');
    return Builder(
      builder: (context) {
        Widget myBuilder = new Padding(
          padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
          child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    hint: Text(
                      'Elije una fecha de corte',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    elevation: 16,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors
                              .white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        )
                    ),
                    iconEnabledColor: Colors.black,
                    value: _currentPeriodId,
                    onChanged: (String newValue) {
                      setState(() {
                        _currentPeriodId = newValue;
                        _periodIdElegido = true;
                      });
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
                  SizedBox(height: 12.0),
                  FlatButton(
                    color: primaryDarkColor,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(94, 8, 94, 8),
                    child: Text(
                      'RECUPERAR HISTÓRICO',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    disabledColor: secondaryLightColor,
                    disabledTextColor: secondaryTextColor,
                    splashColor: Colors.blueAccent,
                    onPressed: () async {
                      if (_periodIdElegido) {
                        _showPleaseWait(true);
                        try {
                          //_showPleaseWait(true);
                          print('Entro en el RECUPERAR HISTORICO');
                          final String cadena = "$SERVER_IP/getSaldoHistorico/" +
                              payload['empleado_id'].toString() + "/" +
                              _currentPeriodId;
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
                            setState(() {
                              _saldoHistorico = new SaldoHistorico(
                                totalDescontado: totalDescontado,
                                totalRetirado: totalRetirado,
                                totalFolios: totalFolios,
                                totalCuotas: totalCuotas
                              );
                            });
                            print(_saldoHistorico);
                            print ('Antes de retornar');


                            ///////////
                            final parsedSaldoHistoDetalle = json.decode(res.body)['detalle'].cast<Map<String, dynamic>>();
                            //var saldoHistoDetalleList = context.read<SaldoHistoDetalleList>();
                            //saldoHistoDetalleList.removeAll();
                            setState(() {
                              _saldoHistoDetalleList = parsedSaldoHistoDetalle.map<SaldoHistoDetalle>((json) => SaldoHistoDetalle.fomJson(json)).toList();
                            });
                            _visible = true;
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
                      } else {
                        _showSnackBar('Debe elegir una fecha de corte.', error: false);
                      }
                    },
                  ),
                ],
              )
          ),
        );
        Widget bodyWidget = _pleaseWait
            ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, myBuilder])
            : Stack(key: ObjectKey("stack"), children: [myBuilder]);
        return ListView(
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(height: 5.0),
            Card(
                child: bodyWidget
            ),
            ExpandableContainer(
              expanded: _visible,
              child: Column(
                children: <Widget>[
                  Card (
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Monto descontado',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(_saldoHistorico.totalDescontado),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            color: kBlupIndigo50,
                            height: 20,
                            thickness: 1,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Monto total retirado',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(_saldoHistorico.totalRetirado),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Monto total folios',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(_saldoHistorico.totalFolios),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Monto total cuotas',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(_saldoHistorico.totalCuotas),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: lBlupBackgroundPreWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              8.0, 0.0, 8.0, 0.0),
                          child: Text(
                            'Detalle:',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2.0),
                          //height: 265,
                          height: 159,
                          child: _saldoHistoDetalleList.length == 0
                              ? ListView(
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
                                )
                              : ListView.builder(
                                itemCount: _saldoHistoDetalleList.length,
                                itemBuilder: (BuildContext context, int index){
                                var mysaldoHistoDetalleList = _saldoHistoDetalleList;
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ),
            ),
          ],
        );
      }
    );
  }

  _showSnackBar(String content, {bool error = false}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text('${error ? "Ocurrió un error: " : ""}${content}'),
    ));
  }
  Future<SaldoActual> _obtenerSaldoActual () async{
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
        leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  semanticLabel: 'menu',
                  color: Colors.white,
                ),
                onPressed: () { Scaffold.of(context).openDrawer(); },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            }
        ),
        backgroundColor: primaryDarkColor,
//        textTheme: ,
        title: Text('BLUP',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
          labelColor: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_alert,
              semanticLabel: 'filter',
              color: Colors.white,
            ),
            onPressed: () {
              print('Filter button');
            },
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
                  child: Text(
                    'BLUP',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: primaryColor
                  )
              ),
            ),
            ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Perfil'),
                onTap: () {
                  Navigator.push (
                      context,
                      MaterialPageRoute(
                        builder: (context) => Perfil(jwt, payload),
                      )
                  );
                }
            ),
            ListTile(
              leading: Icon(Icons.vpn_key),
              title: Text('Cambio contraseña'),
            ),
            ListTile(
              leading: Icon(Icons.https),
              title: Text('Cambio PIN'),
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('Soporte'),
            ),
            ListTile(
              leading: Icon(Icons.live_help),
              title: Text('Preguntas frecuentes'),
            ),
            ListTile(
              leading: Icon(Icons.error),
              title: Text('Términos y condiciones'),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text(
              'Perfil',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            title: Text('Retiro'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
//            icon: Icon(Icons.format_list_bulleted),
            title: Text('Saldo'),
          ),
        ],
        currentIndex: 0,
//        selectedItemColor: Colors.amber[800],
        selectedItemColor: kBlupErrorRed,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Perfil(jwt, payload),
                )
            );
          }
          if (index == 1) {
            Navigator.pop(context);
          }
        },
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