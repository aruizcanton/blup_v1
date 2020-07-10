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
import 'utils/util.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart' show NumberFormat hide TextDirection;
import 'detalleRetiro.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
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
        // TODO: Add buttons and title (102)
        title: Text('BLUP',
          style: TextStyle(
            color: Colors.white,
          ),
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
                            key: _customListItemKey,
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
                 _CustomAmountPermitedDetray(payload['max_permitido'], _scaffoldKey, _customListItemKey, payload['bank'], payload['acct_no'], payload['comision'], jwt, payload),
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
            ),
            ListTile(
              leading: Icon(Icons.vpn_key),
              title: Text('Contraseña y PIN'),
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
  int puedesRetirar;
  final GlobalKey<ScaffoldState> scafoldKey;
  GlobalKey<_CustomListItemState> customListItemKey;
  final String banco;
  final String cuenta;
  final int cuota;
  final String jwt;
  final Map<String, dynamic> payload;
  _CustomAmountPermitedDetray (this.puedesRetirar, this.scafoldKey, this.customListItemKey, this.banco, this.cuenta, this.cuota, this.jwt, this.payload);
  @override
  _SliderAmountPermitedDetrayState createState() {

    return _SliderAmountPermitedDetrayState (puedesRetirar, scafoldKey, customListItemKey, banco, cuenta, cuota, jwt, payload);

  }
}
class _SliderAmountPermitedDetrayState extends State {

  _SliderAmountPermitedDetrayState (this.puedesRetirar, this.scafoldKey, this.customListItemKey, this.banco, this.cuenta, this.cuota, this.jwt, this.payload);
  int puedesRetirar;
  final GlobalKey<ScaffoldState> scafoldKey;
  final GlobalKey<_CustomListItemState> customListItemKey;
  final String banco;
  final String cuenta;
  final int cuota;
  final String jwt;
  final Map<String, dynamic> payload;

  GlobalKey _sliderKey = GlobalKey();
  final PleaseWaitBlueBackGroundWidget _pleaseWaitWidget =
  PleaseWaitBlueBackGroundWidget(key: ObjectKey("pleaseWaitBlueBackGroundWidget"));
  bool _pleaseWait = false;
  int _puedesRetirar;
  int _rating = 0;
  TextEditingController _amountToDetray = TextEditingController();
  NumberFormat _f = new NumberFormat('#,###', 'en_US');
  bool _textFieldActivated = true;
  var _iconColor = secondaryTextColor;
  FocusNode _nodeTextAmountToRetrieve = FocusNode();
  bool _tecladoNumerico = true;
  bool _expandFlag = false;


  double _lowerValue = 0;
  double _upperValue = 0;
  bool _confirmaRetiro = false;

  @override
  void initState(){
    super.initState();
    _amountToDetray.text = "0";
    _confirmaRetiro = false;
    _puedesRetirar = puedesRetirar;
    _tecladoNumerico = true;
    _expandFlag = false;
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
              Expanded (
                flex: 6,
                child: AccentColorOverride (
                  color: kBlupBackgroundWhite,
                  child: TextFormField (
                    controller: _amountToDetray,
                    textInputAction: TextInputAction.done,
                    focusNode: _nodeTextAmountToRetrieve,
                    textAlign: TextAlign.center,
                    onTap: () {
                      _amountToDetray.text="";
                      setState(() {
                        _expandFlag = true;
                      });
                    },
                    enabled: true,
                    //keyboardType: _tecladoNumerico ? TextInputType.number : TextInputType.emailAddress,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (text) {
                      print('La cantidad que se ha escrito es: ' + _amountToDetray.text);
                      var importe = int.parse(text);
                      print('La cantidad cruda es:' + _rating.toString());
                      print('El maximo que puedes retirar es: ' + _puedesRetirar.toString());
                      if (importe > _puedesRetirar) {
                        _showSnackBar('El monto a retirar no puede ser mayor a ' + _f.format(_puedesRetirar) + ' pesos.', error: false);
                      }
                      print('Después de llamar al _show');
                      setState(() {
                        _expandFlag = !_expandFlag;
                      });
                    },
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.attach_money),
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
          SizedBox(height: 2.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: new SliderTheme(
                      data: _themeSlider.copyWith(
                          thumbShape: _RoundedRectangleThumbShape(
                            thumbRadius: 12,
                            roundness: 5,
                            thickness: 12,
                          ),
                          valueIndicatorShape: _CircularValueShape(
                              _rating.toDouble(),
                              radius: 2,
                              borderThickness: 2
                          ),
                          //overlayShape: RoundSliderOverlayShape(overlayRadius: 6),
                          inactiveTrackColor: Colors.grey.shade200,
                          activeTrackColor: Colors.black,
                          thumbColor: Colors.red,
                          showValueIndicator: ShowValueIndicator.always
                      ),
                      child: Slider(
                        key: _sliderKey,
                        value: _rating.toDouble(),
                        min: 0,
                        max: _puedesRetirar.toDouble(),
                        activeColor: Colors.white,
                        inactiveColor: Colors.black,
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
                        },
                        semanticFormatterCallback: (double newValue) {
                          return '${newValue.round()} dollars';
                        },
                      ),
                    ),
                  )
              )
            ],
          ),
          ExpandableContainer(
            expanded: _expandFlag,
            expandedHeight: 100,
            child: new Column(
              children: <Widget>[
                Container (
                  margin: EdgeInsets.only(top: 5),
                  child: const Divider(
                    color: kBlupIndigo50,
                    height: 20,
                    thickness: 1,
                    indent: 25,
                    endIndent: 25,
                  ),
                ),
                Row (
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                          child: Text('Cuota por retiro'),
                        )
                    ),
                    Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            cuota == 0 ? 'GRATUITA' : new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(cuota),
                            //'GRATUITA'
                          ),
                        )
                    ),
                  ],
                ),
                Row (
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded (
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          child:FlatButton (
                            color: primaryDarkColor,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () async {
                              try {
                                if (int.parse(_amountToDetray.text) > 0) {
                                  if (int.parse(_amountToDetray.text) <= customListItemKey.currentState.puedesRetirar) {
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
                                            'max_permitido': payload['max_permitido'],
                                            'extracted_amount': _amountToDetray.text,
                                            'comision': payload['comision'],
                                            'acct_no': payload['acct_no']
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
                                          customListItemKey.currentState.puedesRetirar = customListItemKey.currentState.puedesRetirar - int.parse(_amountToDetray.text);
                                        });
                                        setState(() {
                                          _puedesRetirar = customListItemKey.currentState.puedesRetirar;
                                          payload['max_permitido'] = _puedesRetirar;
                                          _expandFlag = false;
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
                            disabledColor: secondaryLightColor,
                            disabledTextColor: secondaryTextColor,
                            splashColor: Colors.blueAccent,
                            child: Text (
                              'RETIRAR',
                              style: TextStyle (fontSize: 20.0),
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ],
            ),
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Padding(
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
        double value
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
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      //      ..color = sliderTheme.thumbColor
      ..color = Colors.white
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(roundedRectangle, fillPaint);
    canvas.drawRRect(roundedRectangle, borderPaint);
  }
}