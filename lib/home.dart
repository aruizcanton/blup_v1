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
import 'package:flutter/material.dart';
import 'colors.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'utils/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


final storage = FlutterSecureStorage();

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
  bool _pleaseWait = false;
  int _empleado_id;
  int _company_id;
  String _persone_name;
  String _email;
  String _empresa;
  int _salario_acumulado;
  int _dias_nomina;
  int _max_permitido;
  int _periodo_id;
  int _bank_account_id;
  int _comision;
  int _ban_bloqueo;
  int _fch_desbloqueo;
  int _digitalnip;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PleaseWaitWidget _pleaseWaitWidget =
  PleaseWaitWidget(key: ObjectKey("pleaseWaitWidget"));


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
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  // TODO: Make a collection of cards (102)
  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
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
      // TODO: Add app bar (102)
      appBar: AppBar(
        backgroundColor: primaryDarkColor,
//        textTheme: ,
        // TODO: Add buttons and title (102)
        title: Text('BLUP',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            semanticLabel: 'menu',
            color: Colors.white,
          ),
          onPressed: () {
            print('Menu button');
          },
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
      // TODO: Add a grid view (102)
      body: ListView(
        padding: EdgeInsets.all(2.0),
        // TODO: Build a grid of cards (102)
        children: <Widget>[
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 12.0, 16.0, 8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _CustomListItem(
                            user: payload['persone_name'],
                            saldoAcumulado: payload['salario_acumulado'],
                            puedesRetirar: payload['max_permitido'],
                            diasAlaNomina: payload['dias_nomina'],
                          ),
                        ],
                    )
                )
              ]
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 _CustomAmountPermitedDetray(payload['max_permitido'], _scaffoldKey),
              ],
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: Container(
                      margin: EdgeInsets.all(30),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        "Folios",
                        style: TextStyle(
                          fontSize: 50.0,
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
        ],
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
        currentIndex: _selectedIndex,
//        selectedItemColor: Colors.amber[800],
        selectedItemColor: kBlupErrorRed,
        onTap: _onItemTapped,
      ),
      // TODO: Set resizeToAvoidBottomInset (101)
    );

  }
}
class _CustomAmountPermitedDetray extends StatefulWidget{
  final int puedesRetirar;
  final GlobalKey<ScaffoldState> scafoldKey;
  _CustomAmountPermitedDetray (this.puedesRetirar, this.scafoldKey);
  @override
  _SliderAmountPermitedDetrayState createState() {

    return _SliderAmountPermitedDetrayState(puedesRetirar, scafoldKey);

  }
}
class _SliderAmountPermitedDetrayState extends State {

  _SliderAmountPermitedDetrayState(this.puedesRetirar, this.scafoldKey);
  final int puedesRetirar;
  final GlobalKey<ScaffoldState> scafoldKey;

  int _rating = 0;
  TextEditingController _amountToDetray = TextEditingController();
  NumberFormat _f = new NumberFormat('#,###', 'en_US');
  bool _textFieldActivated = true;
  var _iconColor = secondaryTextColor;

  @override
  void initState(){
    super.initState();
    _amountToDetray.text = "0";
  }

  @override
  void dispose (){
    _amountToDetray.dispose();
    super.dispose();
  }
  _validateTextField (){

  }
  _showSnackBar(String content, {bool error = false}) {
    scafoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text('${error ? "Ocurrió un error: " : ""}${content}'),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '¿Cuánto desea retirar?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: AccentColorOverride (
                      color: kBlupBackgroundWhite,
                      child: TextField(
                        controller: _amountToDetray,
                        textAlign: TextAlign.center,
                        enabled: _textFieldActivated,
                        onTap: () => {_amountToDetray.text=""},
                        onChanged: (text) {
                          _rating = int.parse(text);
                          if (_rating > puedesRetirar) {
                            _showSnackBar('La cantidad a retirar no puede ser mayor a ' + _f.format(puedesRetirar), error: false);
                          }
                        },
                        onSubmitted: (text) {
                          _amountToDetray.text = _f.format(int.parse(text));
                          print('La cantidad que se ha escrito es: ' + _amountToDetray.text);
                          _rating = int.parse(text);
                          print('La cantidad cruda es:' + _rating.toString());
                          print('El maximo que puedes retirar es: ' + puedesRetirar.toString());
                          if (_rating > puedesRetirar) {
                            _showSnackBar('La cantidad a retirar no puede ser mayor a ' + _f.format(puedesRetirar), error: false);
                          }
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: IconButton(
                        icon: Icon(Icons.keyboard),
                        color: _iconColor,
                        onPressed: () {
                          setState(() {
                            _textFieldActivated = ! _textFieldActivated;
                            if (_iconColor == secondaryTextColor) _iconColor = primaryTextColor;
                            else _iconColor = secondaryTextColor;
                          });
                        },
                      ),
                  )
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child:
                      Slider(
                          value: _rating.toDouble(),
                          min: 0,
                          max: puedesRetirar.toDouble(),
                          activeColor: Colors.white,
                          inactiveColor: Colors.black,
                          label: 'Set a value',
                          onChanged: (double newValue){
                            setState(() {
                              _rating = newValue.round().toInt();
                              _amountToDetray.text = _f.format(_rating.toInt());
                            });
                          },
                          onChangeStart: (valor) {
                            setState(() {
                              _textFieldActivated = false;
                            });
                          },
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()} dollars';
                          },
                      )
                  )
                ],
              ),
            ]
        )
    );
  }
}
class _CustomListItem extends StatelessWidget {
  const _CustomListItem({
    this.user,
    this.saldoAcumulado,
    this.puedesRetirar,
    this.diasAlaNomina,
  });

  final String user;
  final int saldoAcumulado;
  final int puedesRetirar;
  final int diasAlaNomina;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: _UserDescription(
              user: user,
              saldoAcumulado: saldoAcumulado,
              puedesRetirar: puedesRetirar,
              diasAlaNomina: diasAlaNomina,
            ),
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}
class _UserDescription extends StatelessWidget {
  const _UserDescription({
    Key key,
    this.user,
    this.saldoAcumulado,
    this.puedesRetirar,
    this.diasAlaNomina,
  }) : super(key: key);

  final String user;
  final int saldoAcumulado;
  final int puedesRetirar;
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
                        'Saldo acumulado',
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                        )
                    ),
                  ],
                ),
                VerticalDivider(),
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
                VerticalDivider(),
                Column(
                  children: <Widget>[
                    Text(
                      diasAlaNomina.toString(),
                      style: const TextStyle (
                        fontWeight: FontWeight.w500,
                        fontSize: 22.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                        'A la nómina',
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
class VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 30.0,
      width: 1.0,
      color: Colors.black,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}
class _UserOperationData {
  int empleado_id;
  int company_id;
  String persone_name;
  String email;
  String empresa;
  int salario_acumulado;
  int dias_nomina;
  int max_permitido;
  int periodo_id;
  int bank_account_id;
  int comision;
  int ban_bloqueo;
  int fch_desbloqueo;
  int digitalnip;
  int status;
  String mensaje;
  _UserOperationData ({this.empleado_id, this.company_id, this.persone_name, this.email, this.empresa,
      this.salario_acumulado, this.dias_nomina, this.max_permitido, this.periodo_id, this.bank_account_id,
      this.comision, this.ban_bloqueo, this.fch_desbloqueo, this.digitalnip, this.status, this.mensaje});
  // ignore: missing_return
  factory _UserOperationData.fromJson(Map<String, dynamic> json) {
    return _UserOperationData(
      empleado_id: json['empleado_id'],
      company_id: json['company_id'],
      persone_name: json['persone_name'],
      email: json['email'],
      empresa: json['empresa'],
      salario_acumulado: json['salario_acumulado'],
      dias_nomina: json['dias_nomina'],
      max_permitido: json['max_permitido'],
      periodo_id: json['periodo_id'],
      bank_account_id: json['bank_account_id'],
      comision: json['comision'],
      ban_bloqueo: json['ban_bloqueo'],
      fch_desbloqueo: json['fch_desbloqueo'],
      digitalnip: json['digitalnip']
    );
  }
}
