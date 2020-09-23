// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:blupv1/detalleCompra.dart';
import 'package:blupv1/saldo.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show NumberFormat hide TextDirection;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:blupv1/colors.dart';
import 'package:blupv1/utils/util.dart';
import 'package:blupv1/detalleRetiro.dart';
import 'package:blupv1/bloc/cartProductsBloc.dart';
import 'package:blupv1/model/purchasedProduct.dart';
import 'package:blupv1/perfil.dart';
import 'package:blupv1/cambioContraseña.dart';
import 'package:blupv1/cambioPIN.dart';
//import 'package:flutter_xlider/flutter_xlider.dart';
//import 'package:keyboard_actions/keyboard_actions.dart';

class HomePage extends StatefulWidget {
  HomePage(this.jwt, this.payload);
  factory HomePage.fromBase64(String jwt) =>
      HomePage(
          jwt,
          json.decode(
              utf8.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          )
      );
  final String jwt;
  final Map<String, dynamic> payload;
  //HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(this.jwt, this.payload);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.jwt, this.payload);
  final String jwt;
  final Map<String, dynamic> payload;
//  _UserOperationData _datosOperativaCliente;
  //Map _datosOperativaCliente;
  int _selectedIndex = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PleaseWaitWidget _pleaseWaitWidget =
  PleaseWaitWidget(key: ObjectKey("pleaseWaitWidget"));
  final GlobalKey<_CustomListItemState> _customListItemKey = GlobalKey<_CustomListItemState>();
  final GlobalKey<_CustomAmountPermitedDetrayState> _customAmountPermitedDetray = GlobalKey<_CustomAmountPermitedDetrayState>();
  final GlobalKey<_ProductsAvailState> _productAvailWidget = GlobalKey<_ProductsAvailState>();
  bool _pleaseWait = false;

  _showSnackBar(String content, {bool error = false}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text('${error ? "Ocurrió un error: " : ""}${content}'),
    ));
  }

  _showPleaseWait(bool b) {
    setState(() {
      _pleaseWait = b;
    });
  }

  Future<Map<String, dynamic>> _getDataOperation() async {
    final retorno = Map();
    //_showPleaseWait(true);
    try {
      final http.Response res = await http.post("$SERVER_IP/datosOperativa",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': jwt
          },
          body: jsonEncode(<String, String>{
            'persone_id': payload['persone_id']
          })
      );
      print('Estoy en getDataOperation');
      print('El appTokes es: ' + jwt);
      //_showPleaseWait(false);
      print(res.statusCode);
      //print(json.decode(res.body));
      //print(res.body);
//      print(res.toString());
//      print(res.contentLength);
      Map<String, dynamic> retorno = Map();
      if (res.statusCode == 200) {
        print('Devuelve un 200');
        //print(res.body);
        retorno['code'] = res.statusCode;
        //retorno['empleado_id'] = json.decode(res.body)['empleado_id'];
        //retorno['company_id'] = json.decode(res.body)['company_id'];
        retorno['persone_name'] = json.decode(res.body)['persone_name'];
        retorno['email'] = json.decode(res.body)['email'];
        //retorno['empresa'] = json.decode(res.body)['empresa'];
        //retorno['salario_acumulado'] = json.decode(res.body)['salario_acumulado'];
        //retorno['dias_nomina'] = json.decode(res.body)['dias_nomina'];
        //retorno['max_permitido'] = json.decode(res.body)['max_permitido'];
        //retorno['period_id'] = json.decode(res.body)['period_id'];
        //retorno['bank_account_id'] = json.decode(res.body)['bank_account_id'];
        //retorno['comision'] = json.decode(res.body)['comision'];
        //retorno['ban_bloqueo'] = json.decode(res.body)['ban_bloqueo'];
        //retorno['fch_desbloqueo'] = json.decode(res.body)['fch_desbloqueo'];
        //retorno['digitalnip'] = json.decode(res.body)['digitalnip'];
        //print('Imprimo');
        //print(retorno['token']);
      } else {
        // La password no es correcta
        retorno['code'] = res.statusCode;
        retorno['mensaje'] = json.decode(res.body)['message'];
      }
      return retorno;
    } catch (e) {
      //_showPleaseWait (false);
      _showSnackBar (e.toString(), error: false);
      retorno['code'] = 500;
      retorno['mensaje'] = e.toString();
      //return retorno;
      print('Ha habido un error dentro de _getDataOperation');
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    // Aqui hago la consulta para obtener los datos que voy a necesitar en la pantalla
    //var datosOperativaCliente = getDataOperation(personeId);
    //print (datosOperativaCliente);
    //Widget builder =
    //Widget bodyWidget = _pleaseWait
    //    ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, builder])
    //    : Stack(key: ObjectKey("stack"), children: [builder]);
    print('ESTOY EN HOME.dart');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
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
                    icon: Icon(
                      Icons.menu,
                      semanticLabel: 'menu',
                      color: Colors.black,
                    ),
                    onPressed: () { Scaffold.of(context).openDrawer(); },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              );
            }
        ),
        backgroundColor: colorCajasTexto,
        brightness: Brightness.light,
        title: Image.asset('assets/KlincLogoAppBar.png'),
        actions: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 32.0),
            child: IconButton(
              icon: Icon(
                Icons.add_alert,
                semanticLabel: 'filter',
                color: Colors.black,
              ),
              onPressed: () {
                print('Filter button');
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        children: <Widget>[
          SizedBox(height: 24.0),
          Card(
            elevation: 6,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _CustomListItem(
                        key: _customListItemKey,
                        user: payload['persone_name'],
                        saldoAcumulado: payload['salario_acumulado'],
                        puedesRetirar: payload['max_permitido'],
                        diasAlaNomina: payload['dias_nomina'],
                      ),
                    ],
                )
              ]
            ),
          ),
          SizedBox(height: 32),
          Card(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 _CustomAmountPermitedDetray(
                   key: _customAmountPermitedDetray,
                   puedesRetirar: payload['max_permitido'],
                   scafoldKey: _scaffoldKey,
                   customListItemKey: _customListItemKey,
                   productAvailWidget: _productAvailWidget,
                   banco: payload['bank'],
                   cuenta: payload['acct_no'],
                   cuota: payload['comision'],
                   jwt: jwt,
                   payload: payload,
                 ),
              ],
            ),
          ),
          //Card(
          //  clipBehavior: Clip.antiAlias,
          //  child: _ProductsAvailWidget(
          //    key: _productAvailWidget,
          //    payload: payload,
          //    scafoldKey: _scaffoldKey,
          //    customListItemKey: _customListItemKey,
          //    customAmountPermitedDetray: _customAmountPermitedDetray,
          //    banco: payload['bank'],
          //    cuenta: payload['acct_no'],
          //    jwt: jwt,
          //  ),
          //),
        ],
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
              leading: Icon(Icons.https),
              title: Text('Cambio PIN'),
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
      bottomNavigationBar: _BottonNavigationBar(jwt: jwt, payload: payload,),
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
                    setState(() {
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
                    });
                    print ('Paso por el click de Saldo');
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => Saldo(jwt, payload),
                    ));
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
class _ProductsAvailWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final GlobalKey<ScaffoldState> scafoldKey;
  final String banco;
  final String cuenta;
  final String jwt;
  final GlobalKey<_CustomListItemState> customListItemKey;
  final GlobalKey<_CustomAmountPermitedDetrayState> customAmountPermitedDetray;
  _ProductsAvailWidget({
    Key key,
    this.payload,
    this.scafoldKey,
    this.customListItemKey,
    this.customAmountPermitedDetray,
    this.banco,
    this.cuenta,
    this.jwt
  }): super (key : key);

  @override
  _ProductsAvailState createState() {
    return _ProductsAvailState(payload, scafoldKey, customListItemKey, customAmountPermitedDetray, banco, cuenta, jwt);
  }
}
class _ProductsAvailState extends State {
  final Map<String, dynamic> payload;
  final GlobalKey<ScaffoldState> scafoldKey;
  final String banco;
  final String cuenta;
  final String jwt;
  final GlobalKey<_CustomListItemState> customListItemKey;
  final GlobalKey<_CustomAmountPermitedDetrayState> customAmountPermitedDetray;
  @override
  _ProductsAvailState (this.payload, this.scafoldKey, this.customListItemKey, this.customAmountPermitedDetray, this.banco, this.cuenta, this.jwt);

  //bool _visibleButttonAgr = true;
  var _visibleButttonAgr = List<bool>();
  var _amountItems = List<TextEditingController>();
  int _importeProductos;
  int _importeComision;
  int _importeTotal;
  bool _pleaseWait = false;
  bool _confirmaRetiro = false;
  bool expanded = false;
  final PleaseWaitBlueBackGroundDownWidget _pleaseWaitWidget =
  PleaseWaitBlueBackGroundDownWidget(key: ObjectKey("PleaseWaitBlueBackGroundDownWidget"));

  @override
  void initState() {
    super.initState();
    for (var i = 0; i< bloc.numberShopItems(); i++){
      _visibleButttonAgr.add(true);
      _amountItems.add(new TextEditingController());
    }
    _importeProductos = 0;
    _importeComision = 0;
    _importeTotal = 0;
    _confirmaRetiro = false;
    _pleaseWait = false;
    expanded = false;
  }

  @override
  void dispose () {
    for (var i = 0; i< bloc.numberShopItems(); i++){
      _amountItems[i].dispose();
    }
    super.dispose();
  }
  _showPleaseWait(bool b) {
    setState(() {
      _pleaseWait = b;
    });
  }
  _showSnackBar(String content, {bool error = false}) {
    scafoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text('${error ? "Ocurrió un error: " : ""}${content}'),
    ));
  }
  void _displayDialog (BuildContext context, String title, String banco, String cuenta, int cuota) => showDialog (
    context: context,
    builder: (context) =>
        AlertDialog (
          title: Text(
              'Compra: \$ ' + title,
              textAlign: TextAlign.center
          ),
          content: _DetallesExtraccion(
            banco: banco,
            cuenta: cuenta,
            cuota: cuota,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Confirmar',
              ),
              onPressed: () {
                setState(() {
                  _confirmaRetiro = true;
                });
                Navigator.of(context).pop();
              },
              color: Colors.blue,
            ),
            FlatButton(
              child: Text(
                'Cancelar',
              ),
              onPressed: (){
                setState(() {
                  _confirmaRetiro = false;
                });
                Navigator.of(context).pop();
              },
              color: Colors.blue,
            ),
          ],
          elevation: 24.0,
        ),
  );

  Widget _myListView (snapshot) {
    //print ('Entro donde debería. En la función _myListView: ' + payload['productsAvail'].length.toString());
    print ('Entro por donde debía: ' + payload['acct_no']);
    print ('Entro por donde debía: ' + '${payload}');
    print ('Dentro de _myListView');
    print (snapshot.data["shopItems"]);
    //_visibleButttonAgr = true;
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data["shopItems"].length,
        itemBuilder: (BuildContext context, index) {
          final shopList = snapshot.data["shopItems"];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Container(
                        height: 60,
                        child: AspectRatio(
                          aspectRatio: 3.0 / 2.0,
                          //child: Image.asset('assets/' + shopList[index]['image']),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => CircularProgressIndicator(),
                            imageUrl: SERVER_IP + '/image/products/' + shopList[index]['image'],
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Precio: \$ ' + (shopList[index]['product_price']).toString(),
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            children: <Widget>[
                              Text(
                                'Comisión: \$ ' + (shopList[index]['comission']).toString(),
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            children: <Widget>[
                              Text(
                                'Disponibles: ' + (shopList[index]['avail']).toString(),
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  //fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.0),
                          Row(
                            children: <Widget>[
                              Visibility(
                                visible: _visibleButttonAgr[index],
                                child: Column(
                                  children: <Widget>[
                                    FlatButton (
                                      color: primaryDarkColor,
                                      textColor: Colors.white,
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        setState(() {
                                          _visibleButttonAgr[index] = false;
                                          _amountItems[index].text = "0";
                                          expanded = true;
                                          customAmountPermitedDetray.currentState.setState(() {
                                            customAmountPermitedDetray.currentState.expandFlag = false;
                                          });
                                        });
                                      },
                                      disabledColor: secondaryLightColor,
                                      disabledTextColor: secondaryTextColor,
                                      splashColor: Colors.blueAccent,
                                      child: Text (
                                        'Agregar',
                                      ),
                                    ),
                                  ],
                                ),
                                replacement: Container(
                                  width: 100,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: FlatButton(
                                          color: primaryDarkColor,
                                          textColor: Colors.white,
                                          onPressed: (){
                                            if (int.parse(_amountItems[index].text) > 0) {
                                              setState(() {
                                                _importeProductos = _importeProductos - shopList[index]['product_price'];
                                                _importeComision = _importeComision - shopList[index]['comission'];
                                                _importeTotal = _importeProductos - _importeComision;
                                                shopList[index]['avail'] = shopList[index]['avail'] +1;
                                                if (int.parse(_amountItems[index].text) == 1) {
                                                  _visibleButttonAgr[index] = true;
                                                  var testigo = false;
                                                  for (var i = 0; i< _visibleButttonAgr.length; i++){
                                                    if (_visibleButttonAgr[i] == false) testigo = true;
                                                  }
                                                  if (testigo == false) expanded = false;
                                                }
                                              });
                                              _amountItems[index].text = (int.parse(_amountItems[index].text) - 1).toString();
                                              bloc.removeFromCart(shopList[index]);
                                            } else {
                                              setState(() {
                                                _visibleButttonAgr[index] = true;
                                                var testigo = false;
                                                for (var i = 0; i< _visibleButttonAgr.length; i++){
                                                  if (_visibleButttonAgr[i] == false) testigo = true;
                                                }
                                                if (testigo == false) expanded = false;
                                              });
                                            }
                                            customAmountPermitedDetray.currentState.setState(() {
                                              customAmountPermitedDetray.currentState.expandFlag = false;
                                            });
                                          },
                                          disabledColor: secondaryLightColor,
                                          child: Text(
                                            '-',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: FlatButton(
                                          color: primaryDarkColor,
                                          textColor: Colors.white,
                                          onPressed: (){
                                            //bloc.addToCart(index);
                                            if (int.parse(_amountItems[index].text) < shopList[index]['avail']) {
                                              print('Antes de hacer el incremento. Estoy dentro del botón +');
                                              _amountItems[index].text = (int.parse(_amountItems[index].text) + 1).toString();
                                              print('Después de hacer el incremento. Estoy dentro del botón +');
                                              setState(() {
                                                _importeProductos = _importeProductos + shopList[index]['product_price'];
                                                _importeComision = _importeComision + shopList[index]['comission'];
                                                _importeTotal = _importeProductos + _importeComision;
                                                shopList[index]['avail'] = shopList[index]['avail'] - 1;
                                              });

                                              bloc.addToCart(shopList[index]);
                                            }
                                            customAmountPermitedDetray.currentState.setState(() {
                                              customAmountPermitedDetray.currentState.expandFlag = false;
                                            });
                                          },
                                          disabledColor: secondaryLightColor,
                                          child: Text(
                                            '+',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                              alignment: Alignment.center,
                                              child:
                                              TextField (
                                                controller: _amountItems[index],
                                                textAlign: TextAlign.center,
                                                style: const TextStyle (
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
    );
  }
  Widget build(BuildContext context) {
    Widget builder = new Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 0.0, 5.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Center(
                            child: Container(
                              margin: EdgeInsets.all(5),
                              //padding: EdgeInsets.all(10),
                              //width: 300,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                //border: Border.all(color: Colors.black),
                              ),
                              child: StreamBuilder(
                                initialData: bloc.allItems,
                                stream: bloc.getStream,
                                builder: (context, snapshot) {
                                  return snapshot.data["shopItems"].length > 0
                                      ? _myListView(snapshot)
                                      : Center(child: Text("Productos agotados."));
                                },
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                  ExpandableContainer(
                      expanded: expanded,
                      expandedHeight: 140,
                      child: new Column(
                        children: <Widget>[
                          const Divider(
                            color: Colors.black,
                            height: 20,
                            thickness: 5,
                            indent: 20,
                            endIndent: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(_importeProductos),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                      'Productos',
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.black,
                                      )
                                  ),
                                ],
                              ),
                              _VerticalDivider(),
                              Column(
                                children: <Widget>[
                                  Text(
                                      new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(_importeComision),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22.0,
                                        color: Colors.black,
                                      )
                                  ),
                                  Text(
                                      'Comisión',
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.black,
                                      )
                                  ),
                                ],
                              ),
                              _VerticalDivider(),
                              Column(
                                children: <Widget>[
                                  Text(
                                      new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(_importeTotal),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22.0,
                                        color: Colors.black,
                                      )
                                  ),
                                  Text(
                                      'Total',
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.black,
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 20,
                            thickness: 5,
                            indent: 20,
                            endIndent: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(13, 5, 13, 5),
                                  child: FlatButton(
                                    color: primaryDarkColor,
                                    textColor: Colors.white,
                                    padding: EdgeInsets.all(8.0),
                                    onPressed: () async{
                                      try{
                                        if (_importeTotal <= customListItemKey.currentState.puedesRetirar) {
                                          await _displayDialog (context, _importeTotal.toString(), banco, cuenta, _importeComision);
                                          print ('El valor de _confirmaretiro es: ' + _confirmaRetiro.toString());
                                          if (_confirmaRetiro) {
                                            print('He confirmado el retiro');
                                            print('Justo antes de llamar a _showPleaseWait');
                                            print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                                            _showPleaseWait(true);
                                            print('Justo después de llamar a _showPleaseWait');
                                            print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                                            final http.Response res = await http.post("$SERVER_IP/savePurchasedProducts",
                                                headers: <String, String>{
                                                  'Content-Type': 'application/json; charset=UTF-8',
                                                  'Authorization': jwt
                                                },
                                                body: jsonEncode(<String, dynamic>{
                                                  'persone_id': payload['empleado_id'],
                                                  'company_id': payload['company_id'],
                                                  'period_id': payload['period_id'],
                                                  'bank_account_id': payload['bank_account_id'],
                                                  'payroll_day': payload['period_id'],
                                                  'salario_acumulado': payload['salario_acumulado'],
                                                  'max_permitido': customListItemKey.currentState.puedesRetirar,
                                                  'extracted_amount': _importeTotal,
                                                  'comission_amount': _importeComision,
                                                  'acct_no': payload['acct_no'],
                                                  'purchased_products': bloc.allItems['cartItems']
                                                })
                                            );
                                            if (res.statusCode == 200) {
                                              // He de variar la cantidad que puedes retirar de la pantalla
                                              print('Justo antes de llamar por segunda vez _showPleaseWait');
                                              print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                                              _showPleaseWait(false);
                                              print('Justo después de llamar a _showPleaseWait');
                                              print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                                              customListItemKey.currentState.setState(() {
                                                customListItemKey.currentState.puedesRetirar = customListItemKey.currentState.puedesRetirar - _importeTotal;
                                              });
                                              customAmountPermitedDetray.currentState.setState(() {
                                                customAmountPermitedDetray.currentState.amoutToDetray = customListItemKey.currentState.puedesRetirar - _importeTotal;
                                              });
                                              print('Después de el http.post');
                                              print(res.body);
                                              final data = json.decode(res.body)['data'];
                                              final parsed = json.decode(res.body)['data'].cast<Map<String, dynamic>>();
                                              final purchasedProducts = parsed.map<PurchasedProduct>((json) => PurchasedProduct.fomJson(json)).toList();
                                              final infoPurchased = Map<String, dynamic>();
                                              infoPurchased['total_amount'] = _importeTotal;
                                              infoPurchased['products_amount'] = _importeProductos;
                                              infoPurchased['comission_amount'] = _importeComision;
                                              print('El valor de importeTotal es: ' + _importeTotal.toString());
                                              print('El valor de products_amount es: ' + _importeProductos.toString());
                                              print('El valor de comission_amount es: ' + _importeComision.toString());
                                              print('Justo antes de llamar al push');
                                              for (var i = 0; i< purchasedProducts.length; i++){
                                                print(purchasedProducts[i].order_id);
                                              };
                                              Navigator.push (
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => DetalleCompra(jwt, payload, purchasedProducts, infoPurchased),
                                                    fullscreenDialog: false,
                                                  )
                                              );
                                              print('Después de regresar de la pantalla de información');
                                              // Regreso de la pantalla de información
                                              print ('La longitud de _allowItems es: ' + _amountItems.length.toString());
                                              for (var i = 0; i < _amountItems.length; i++){
                                                setState(() {
                                                  _visibleButttonAgr[i] = true;
                                                  _amountItems[i].text = "0";
                                                });
                                              }
                                              setState(() {
                                                _importeTotal = 0;
                                                _importeProductos = 0;
                                                _importeComision = 0;
                                                expanded = false;
                                              });
                                            } else if (res.statusCode == 404) {
                                              _showPleaseWait(false);
                                              // Como retorno que le token no es valido retorno a la página de Login
                                              Navigator.pop(context);
                                            } else {
                                              _showPleaseWait(false);
                                              _showSnackBar(json.decode(res.body)['message'], error: false);
                                            }
                                          }
                                        } else {
                                          _showSnackBar('El importe comprado no puede ser mayor a la cantidad disponible', error: false);
                                        }
                                      }catch (e) {
                                        _showPleaseWait(false);
                                        _showSnackBar(e.toString(), error: false);
                                        print('Error' + e.toString());
                                      }
                                    },
                                    disabledColor: secondaryLightColor,
                                    disabledTextColor: secondaryTextColor,
                                    splashColor: Colors.blueAccent,
                                    child: Text (
                                      'COMPRAR',
                                      style: TextStyle (fontSize: 20.0),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
    Widget bodyWidget = _pleaseWait
        ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, builder])
        : Stack(key: ObjectKey("stack"), children: [builder]);
    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: bodyWidget,
    );
  }
}
class _CustomAmountPermitedDetray extends StatefulWidget {
  final int puedesRetirar;
  final GlobalKey<ScaffoldState> scafoldKey;
  final GlobalKey<_CustomListItemState> customListItemKey;
  final GlobalKey<_ProductsAvailState> productAvailWidget;
  final String banco;
  final String cuenta;
  final int cuota;
  final String jwt;
  final Map<String, dynamic> payload;
  _CustomAmountPermitedDetray ({
      Key key,
      this.puedesRetirar,
      this.scafoldKey,
      this.customListItemKey,
      this.productAvailWidget,
      this.banco,
      this.cuenta,
      this.cuota,
      this.jwt,
      this.payload
  }): super(key: key);
  @override
  _CustomAmountPermitedDetrayState createState() {

    return _CustomAmountPermitedDetrayState (puedesRetirar, scafoldKey, customListItemKey, productAvailWidget ,banco, cuenta, cuota, jwt, payload);

  }
}
class _CustomAmountPermitedDetrayState extends State {
  @override
  _CustomAmountPermitedDetrayState (this.puedesRetirar, this.scafoldKey, this.customListItemKey, this.productAvailWidget, this.banco, this.cuenta, this.cuota, this.jwt, this.payload);
  final int puedesRetirar;
  final GlobalKey<ScaffoldState> scafoldKey;
  final GlobalKey<_CustomListItemState> customListItemKey;
  final GlobalKey<_ProductsAvailState> productAvailWidget;
  final String banco;
  final String cuenta;
  final int cuota;
  final String jwt;
  final Map<String, dynamic> payload;

  GlobalKey _sliderKey = GlobalKey();
  final PleaseWaitBlueBackGroundWidget _pleaseWaitWidget =
  PleaseWaitBlueBackGroundWidget(key: ObjectKey("pleaseWaitBlueBackGroundWidget"));
  bool _pleaseWait = false;
  int _rating = 200;
  TextEditingController _amountToDetray = TextEditingController();
  NumberFormat _f = new NumberFormat('#,###', 'en_US');
  bool _textFieldActivated = true;
  var _iconColor = secondaryTextColor;
  FocusNode _nodeTextAmountToRetrieve = FocusNode();
  bool _tecladoNumerico = true;
  bool expandFlag = false;
  int amoutToDetray;


  double _lowerValue = 0;
  double _upperValue = 0;
  bool _confirmaRetiro = false;

  @override
  void initState() {
    super.initState();
    _rating = 200;
    _amountToDetray.text = "0";
    _confirmaRetiro = false;
    _tecladoNumerico = true;
    expandFlag = false;
    amoutToDetray = this.puedesRetirar;
  }

  @override
  void dispose (){
    _amountToDetray.dispose();
    super.dispose();
  }
  _validateTextField (){

  }
  _showPleaseWait(bool b) {
    setState(() {
      _pleaseWait = b;
    });
  }
  _showSnackBar(String content, {bool error = false}) {
    scafoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text('${error ? "Ocurrió un error: " : ""}${content}'),
    ));
  }
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  void _displayDialog (BuildContext context, String title, String banco, String cuenta, int cuota) => showDialog (
    context: context,
    builder: (context) =>
        AlertDialog (
          title: Text(
            'Retiras: \$ ' + title,
            textAlign: TextAlign.center
          ),
          content: _DetallesExtraccion(
            banco: banco,
            cuenta: cuenta,
            cuota: cuota,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Confirmar',
              ),
              onPressed: () {
                setState(() {
                  _confirmaRetiro = true;
                });
                Navigator.of(context).pop();
              },
              color: Colors.blue,
            ),
            FlatButton(
              child: Text(
                'Cancelar',
              ),
              onPressed: (){
                setState(() {
                  _confirmaRetiro = false;
                });
                Navigator.of(context).pop();
              },
              color: Colors.blue,
            ),
          ],
          elevation: 24.0,
        ),
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final SliderThemeData _themeSlider = _theme.sliderTheme;
    Widget builder = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16.0),
              Text(
                '¿Cuánto desea retirar?',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.black,
                  fontFamily: 'SF Pro Display'
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded (
                flex: 6,
                child: AccentColorOverride (
                  color: primaryDarkColor,
                  child: TextFormField (
                    controller: _amountToDetray,
                    textInputAction: TextInputAction.done,
                    focusNode: _nodeTextAmountToRetrieve,
                    textAlign: TextAlign.center,
                    onTap: () {
                      _amountToDetray.text="";
                      setState(() {
                        expandFlag = true;
                      });
                      productAvailWidget.currentState.setState(() {
                        productAvailWidget.currentState.expanded = false;
                      });
                    },
                    //keyboardType: _tecladoNumerico ? TextInputType.number : TextInputType.emailAddress,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (text) {
                      //print('La cantidad que se ha escrito es: ' + _amountToDetray.text);
                      var importe = int.parse(text);
                      //print('La cantidad cruda es:' + _rating.toString());
                      //print('El maximo que puedes retirar es: ' + _puedesRetirar.toString());
                      if (amoutToDetray < 200) {
                        _showSnackBar('No puede realizar ningún retiro mas. Ha agotado su saldo.' , error: false);
                      } else if ((puedesRetirar == 0) && (customListItemKey.currentState.saldoAcumulado == 0)) {
                        _showSnackBar('No puede realizar ningún retiro. Estamos en la fecha de ajuste.', error: false);
                      }
                      else if (importe > amoutToDetray) {
                        _showSnackBar('El monto a retirar no puede ser mayor a ' + _f.format(puedesRetirar) + ' pesos.', error: false);
                      } else {
                        setState(() {
                          expandFlag = !expandFlag;
                        });
                        productAvailWidget.currentState.setState(() {
                          productAvailWidget.currentState.expanded = false;
                        });
                      }
                      //print('Después de llamar al _show');
                    },
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Avenir',
                    ),
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        iconSize: 40,
                        color: Colors.black,
                        icon: Icon(Icons.attach_money),
                        onPressed: (){},
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.keyboard),
                          onPressed: () {
                            setState(() {
                              print('Antes valor de _tecladoNumerico es: ' +_tecladoNumerico.toString());
                              _tecladoNumerico = ! _tecladoNumerico;
                              print('Despues valor de _tecladoNumerico es: ' +_tecladoNumerico.toString());
                            });
                          },
                          color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 48.0),
          Row (
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                    child: new SliderTheme(
                      data: _themeSlider.copyWith(
                          thumbShape: _RoundedRectangleThumbShape(
                            thumbRadius: 12,
                            roundness: 2,
                            thickness: 12,
                          ),
                          valueIndicatorShape: _CircularValueShape(
                              _rating.toDouble(),
                              radius: 2,
                              borderThickness: 2
                          ),
                          //overlayShape: RoundSliderOverlayShape(overlayRadius: 6),
                          inactiveTrackColor: Colors.grey.shade200,
                          activeTrackColor: Color(0xFF4895F6),
                          thumbColor: Colors.red,
                          showValueIndicator: ShowValueIndicator.always
                      ),
                      child: Slider (
                        key: _sliderKey,
                        value: _rating.toDouble(),
                        min: 200,
                        max: amoutToDetray.toDouble(),
                        activeColor: Color(0xFF4895F6),
                        inactiveColor: Color(0xFF9C9EB7),
                        onChanged: (double newValue){
                          setState(() {
                            _rating = newValue.round().toInt();
                            //_amountToDetray.text = _f.format(_rating.toInt());
                            _amountToDetray.text = _rating.toString();
                          });
                        },
                        onChangeStart: (valor) {
                          setState(() {
                            _textFieldActivated = false;
                            _iconColor = secondaryTextColor;
                          });
                          productAvailWidget.currentState.setState(() {
                            productAvailWidget.currentState.expanded = false;
                          });
                        },
                        semanticFormatterCallback: (double newValue) {
                          return '${newValue.round()} dollars';
                        },
                      ),
                    ),
                  )
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '\$ 200',
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(amoutToDetray),
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.right,
                )
              )
            ],
          ),
          SizedBox(height: 32),
          Row (
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded (
                  child: RaisedButton (
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    elevation: 8.0,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration (
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color (0xFFA007EB),
                              Color (0XFF567DF4),
                              Color (0xFF04FFFE)
                            ],
                          )
                      ),
                      //padding: const EdgeInsets.fromLTRB(145.0, 20.0, 145.0, 20.0),
                      child: const Text(
                          'Retirar',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white
                          )
                      ),
                      height: 64,
                    ),
                    onPressed: () async {
                      try {
                        if (int.parse(_amountToDetray.text) > 0) {
                          if ((int.parse(_amountToDetray.text)+cuota) <= (customListItemKey.currentState.puedesRetirar)) {
                            await _displayDialog (context, _amountToDetray.text, banco, cuenta, cuota);
                            print ('El valor de _confirmaretiro es: ' + _confirmaRetiro.toString());
                            if (_confirmaRetiro) {
                              print('He confirmado el retiro');
                              print('Justo antes de llamar a _showPleaseWait');
                              print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                              _showPleaseWait(true);
                              print('Justo después de llamar a _showPleaseWait');
                              print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                              final http.Response res = await http.post("$SERVER_IP/saveTransaction",
                                  headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                    'Authorization': jwt
                                  },
                                  body: jsonEncode(<String, dynamic>{
                                    'company_id': payload['company_id'],
                                    'persone_id': payload['empleado_id'],
                                    'period_id': payload['period_id'],
                                    'bank_account_id': payload['bank_account_id'],
                                    'salario_acumulado': payload['salario_acumulado'],
                                    //'salario_acumulado': customListItemKey.currentState.puedesRetirar,
                                    'max_permitido': customListItemKey.currentState.puedesRetirar,
                                    'extracted_amount': _amountToDetray.text,
                                    'comision': payload['comision'],
                                    'acct_no': payload['acct_no'],
                                    'persone_name': payload['persone_name'],
                                    'email': payload['email']
                                  })
                              );
                              if (res.statusCode == 200) {
                                // He de variar la cantidad que puedes retirar de la pantalla
                                print('Justo antes de llamar por segunda vez _showPleaseWait');
                                print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                                _showPleaseWait(false);
                                print('Justo después de llamar a _showPleaseWait');
                                print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                                print('El retiro ha sido hecho con retorno 200');
                                customListItemKey.currentState.setState(() {
                                  customListItemKey.currentState.puedesRetirar = customListItemKey.currentState.puedesRetirar - (int.parse(_amountToDetray.text)+cuota);
                                });
                                setState(() {
                                  amoutToDetray = amoutToDetray - (int.parse(_amountToDetray.text)+cuota);
                                  payload['max_permitido'] = amoutToDetray;
                                  expandFlag = false;

                                });
                                _amountToDetray.text = "0";
                                print('Después de el http.post');
                                final retorno = Map();
                                retorno['day'] = json.decode(res.body)['day'];
                                retorno['extracted_amount'] = json.decode(res.body)['extracted_amount'];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetalleRetiro.fromBase64(jwt, json.decode(res.body)),
                                      fullscreenDialog: false,
                                    )
                                );
                              } else if (res.statusCode == 404) {
                                _showPleaseWait(false);
                                // Como retorno que le token no es valido retorno a la página de Login
                                Navigator.pop(context);
                                //_showSnackBar(json.decode(res.body)['message'], error: false);
                              } else {
                                _showPleaseWait(false);
                                _showSnackBar(json.decode(res.body)['message'], error: false);
                              }
                            }
                          } else {
                            _showPleaseWait(false);
                            _showSnackBar('El retiro no puede ser superior a ' + customListItemKey.currentState.puedesRetirar.toString() + '.', error: false);
                          }
                        } else {
                          _showPleaseWait(false);
                          _showSnackBar('El retiro ha de ser superior a 0.', error: false);
                        }
                      } catch (e) {
                        _showPleaseWait(false);
                        _showSnackBar(e.toString(), error: false);
                        print('Error' + e.toString());
                      }
                    },
                  )
              ),
            ],
          ),
          SizedBox(height: 24.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  child: Text (
                    'Borrar',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: (){
                    setState(() {
                      _rating = 200;
                      //_amountToDetray.text = _f.format(_rating.toInt());
                      _amountToDetray.text = '0';
                    });
                  },
                )
              ),
            ],
          ),
          SizedBox(height: 24.0),
        ]
    );
    Widget bodyWidget = _pleaseWait
        ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, builder])
        : Stack(key: ObjectKey("stack"), children: [builder]);
    print ('Paso por el build de después de _pleaseWait. El valor de _pleaseWait es: ' + _pleaseWait.toString());
    return new Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0),
                child: bodyWidget,
            );
  }
}
class _CustomListItem extends StatefulWidget {
  _CustomListItem({
    Key key,
    this.user,
    this.saldoAcumulado,
    this.puedesRetirar,
    this.diasAlaNomina,
  }): super (key: key);
  final String user;
  final int saldoAcumulado;
  int puedesRetirar;
  final int diasAlaNomina;
  @override
  _CustomListItemState createState(){
    return _CustomListItemState (user, saldoAcumulado, puedesRetirar, diasAlaNomina);
  }
}
class _CustomListItemState extends State {
  _CustomListItemState(
    this.user,
    this.saldoAcumulado,
    this.puedesRetirar,
    this.diasAlaNomina
  );
  final String user;
  final int saldoAcumulado;
  int puedesRetirar;
  final int diasAlaNomina;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(4.0),
                gradient: LinearGradient(
                    colors: <Color>[
                      //Color (0xFFA007EB),
                      //Color (0XFF567DF4),
                      //Color (0xFF04FFFE)
                      Color (0xFFAD87EF),
                      Color (0xFF7D3EEF),
                      Color (0xFF5F6FF3),
                      Color (0xFF3FA2F7),
                      Color (0xFF13E9FC),
                      Color (0xFF08F8FD)
                    ]
                )
            ),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 32.0),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text (
                            user,
                            style: const TextStyle(
                              fontSize: 32.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ),
                      ]
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text (
                        'Nombre de la empresa',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 24.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(4.0),
                          gradient: LinearGradient(
                              colors: <Color>[
                                //Color (0XFFA007EB),
                                //Color (0xFFAB53F1),
                                //Color (0XFF5354F1),
                                //Color (0xFF7E3DEF),

                                //Color (0XFF567DF4),
                                //Color (0XFF567DF4),
                                //Color (0XFF8BABFB),
                                //Color (0xFF04FFFE),
                                //
                                //Color (0xFF923DE4),
                                Color (0xFF5900d9),
                                Color (0xFF5901DA),
                                Color (0xFF430ADF),
                                Color (0xFF0F64EE),
                                Color (0xFF03ADF5),
                                Color (0xFF01D0F9)
                              ]
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Row (
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(height: 16.0),
                                Text(
                                  new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoAcumulado),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                    color: Colors.white,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                                SizedBox(height: 13.0),
                                Text(
                                    'Saldo acumulado',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SF Pro Display',
                                    )
                                ),
                              ],
                            ),
                            //_VerticalDivider(),
                            Column(
                              children: <Widget>[
                                SizedBox(height: 16.0),
                                Text(
                                  new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(puedesRetirar),
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                                SizedBox(height: 13.0),
                                Text(
                                    'Puedes Retirar',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SF Pro Display',
                                    )
                                ),
                              ],
                            ),
                            //_VerticalDivider(),
                            Column(
                              children: <Widget>[
                                SizedBox(height: 16.0),
                                Text.rich(
                                    TextSpan(
                                        text: diasAlaNomina.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0,
                                          color: Colors.white,
                                          fontFamily: 'SF Pro Display',
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: ' días',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.0,
                                                color: Colors.white,
                                                fontFamily: 'SF Pro Display',
                                              )
                                          )
                                        ]
                                    )
                                ),
                                SizedBox(height: 13.0),
                                Text(
                                      'a la nómina',
                                      style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.w500,
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
class _UserDescription extends StatefulWidget {
  _UserDescription({
    this.user,
    this.saldoAcumulado,
    this.puedesRetirar,
    this.diasAlaNomina,
  });

  final String user;
  final int saldoAcumulado;
  int puedesRetirar;
  final int diasAlaNomina;

  @override
  _UserDescriptionState createState() {
    return _UserDescriptionState(
        user, saldoAcumulado, puedesRetirar, diasAlaNomina);
  }
}
class _UserDescriptionState extends State {
  _UserDescriptionState (
      this.user,
      this.saldoAcumulado,
      this.puedesRetirar,
      this.diasAlaNomina,
  );

  final String user;
  final int saldoAcumulado;
  int puedesRetirar;
  final int diasAlaNomina;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                user,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 26.0,
                    color: Colors.black
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
            height: 20,
            thickness: 5,
            indent: 20,
            endIndent: 0,
          ),
          Row(
//              crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(saldoAcumulado),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                      'Saldo acuuumulado',
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                      )
                  ),
                ],
              ),
              _VerticalDivider(),
              Column(
                children: <Widget>[
                  Text(
                    new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(puedesRetirar),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                      'Puedes Retirar',
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                      )
                  ),
                ],
              ),
              _VerticalDivider(),
              Column(
                children: <Widget>[
                  Text.rich(
                      TextSpan(
                          text: diasAlaNomina.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' días',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10.0,
                                  color: Colors.black,
                                )
                            )
                          ]
                      )
                  ),
                  Text(
                      'a la nómina',
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                      )
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetallesExtraccion extends StatelessWidget{
  const _DetallesExtraccion({
    this.banco,
    this.cuenta,
    this.cuota
  });
  final String banco;
  final String cuenta;
  final int cuota;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1200,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.account_balance,
                      color: Colors.black,
                    ),
                    onPressed: null,
                  )
              ),
              Expanded(
                  child: Text(
                      'Banco'
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    banco,
                  ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.closed_caption,
                      color: Colors.black,
                    ),
                    onPressed: null,
                  )
              ),
              Expanded(
                  child: Text(
                      'Cuenta'
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    cuenta,
                  )
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.loop,
                      color: Colors.black,
                    ),
                    onPressed: null,
                  )
              ),
              Expanded(
                  child: Text(
                      'Cuota'
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    cuota == 0 ? 'GRATUITA' : new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(cuota),
                  )
              ),
            ],
          )
        ],
      ),
    );
  }
}
class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 30.0,
      width: 23.0,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}
class _CircularValueShape extends SliderComponentShape{
  //The radius of the value indicator
  final double radius;
  //The border thickness of the value indicator
  final double borderThickness;
  //the value of the slider
  final double _value;

  const _CircularValueShape(this._value, {this.radius = 6.0, this.borderThickness = 2});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }
  @override
  void paint
    (
      PaintingContext context,
      Offset center,
      {
        Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        TextPainter labelPainter,
        RenderBox parentBox,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value,
        double textScaleFactor,
        Size sizeWithOverflow
      }
    )
  {
    final Canvas canvas = context.canvas;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      //..color = sliderTheme.thumbColor
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    //creating the textStyle
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
    //creating the text span
    final textSpan = TextSpan(
      //text: _value.toInt().toString(),
      text: 'Hola',
      style: textStyle,
    );
    //creating the text painter
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 50,
    );

    //creating the tooltip position
    Offset toolTipOffset = Offset(center.dx, center.dy - radius - 30);

    //creating the text position
    Offset textOffset =
    Offset(toolTipOffset.dx - textPainter.width / 2, toolTipOffset.dy - 10);

    canvas.drawCircle(toolTipOffset, radius, fillPaint);
    canvas.drawCircle(toolTipOffset, radius, borderPaint);

    //painting the text
    textPainter.paint(canvas, textOffset);

  }
}
class _RoundedRectangleThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final double thickness;
  final double roundness;

  const _RoundedRectangleThumbShape(
      {this.thumbRadius = 6.0, this.thickness = 2, this.roundness = 6.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        TextPainter labelPainter,
        RenderBox parentBox,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value,
        double textScaleFactor,
        Size sizeWithOverflow
      }) {
    final Canvas canvas = context.canvas;

    final rect = Rect.fromCircle(center: center, radius: thumbRadius);

    final roundedRectangle = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(rect.left - 1, rect.top),
        Offset(rect.right + 1, rect.bottom),
      ),
      Radius.circular(roundness),
    );

    final fillPaint = Paint()
      //..color = Color(0xFF4895F6)
      //..color = Color(0xFF5900d9)
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      //      ..color = sliderTheme.thumbColor
      //..color = Colors.white
      ..color = Color(0xFF5900d9)
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(roundedRectangle, fillPaint);
    canvas.drawRRect(roundedRectangle, borderPaint);
  }
}