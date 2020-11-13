import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

import 'package:blupv1/colors.dart';
import 'package:blupv1/utils/util.dart';
import 'package:blupv1/home.dart';

final storage = FlutterSecureStorage();

class CambioPin extends StatefulWidget {
  final String user_name;
  CambioPin(this.user_name);
  @override
  _CambioPinState createState() => _CambioPinState(this.user_name);
}
class _CambioPinState extends State<CambioPin> {
  // TODO: Add text editing controllers (101)
  _CambioPinState(this.user_name);
  final String user_name;

  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmaPinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordNoVisible=true;
  bool _confirmaPinNoVisible=true;
  bool _pinNoVisible=true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PleaseWaitWidget _pleaseWaitWidget =
  PleaseWaitWidget(key: ObjectKey("pleaseWaitWidget"));
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

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
                children: <Widget>[
                  Text(text),
                ]
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
              ),
              onPressed: (){
                Navigator.of(context).pop();
              },
              color: Colors.blue,
            ),
          ],
          elevation: 24.0,
        ),
  );
  Future<Map> attemptLogIn(String user_name, String pin) async {
    _showPleaseWait(true);
    try {
      print ('El user_name es: ' + user_name);
      print ('El pin es: ' + pin);
      final http.Response res = await http.post("$SERVER_IP/cambioPin",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'user_name': user_name,
            'pin': pin
          })
      );
      _showPleaseWait(false);
      print(res.statusCode);
      //print(json.decode(res.body));
//      print(res.body);
//      print(res.toString());
//      print(res.contentLength);
      final retorno = Map();
      if (res.statusCode == 200) {
        print('Devuelve un 200');
        print(res.body);
        retorno['code'] = res.statusCode;
        //retorno['token'] = json.decode(res.body)['token'];
        retorno['token'] = '';  // En este caso no necesito devolver el token
        print('Imprimo');
        print(retorno['token']);
      } else {
        // La password no es correcta
        retorno['code'] = res.statusCode;
        retorno['user_name'] = json.decode(res.body)['message'];
      }
      return retorno;
    } catch (e) {
      _showPleaseWait(false);
      _showSnackBar(e.toString(), error: true);
      print('Ha habido un error');
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget builder = SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 47.0),
        children: <Widget>[
          SizedBox(height: 48.0),
          //Column(
            //children: <Widget>[
              //Image.asset('assets/outline_monetization_on_black_48.png'),
              //SizedBox(height: 16.0),
              //Text(
              //  'Cambio de su PIN de seguridad',
              //  style: TextStyle(
              //    fontFamily: 'Helvetica neue',
              //    fontSize: 24,
              //    fontStyle: FontStyle.normal,
              //    fontWeight: FontWeight.normal
              //  ),
              //),
            //],
          //),
          //SizedBox(height: 20.0),
          Text(
              'Nuevo PIN:',
              style: const TextStyle(
                fontFamily: 'Helvetica neue',
                fontSize: 16,
                fontWeight: FontWeight.normal,
              )
          ),
          SizedBox(height: 4.0),
          AccentColorOverride(
            color: primaryDarkColor,
            child: TextField(
              controller: _pinController,
              decoration: InputDecoration(
                  labelText: '4 dígitos',
                  suffixIcon: IconButton(
                      icon: Icon(_pinNoVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _pinNoVisible = ! _pinNoVisible;
                        });
                      }
                  )
              ),
              obscureText: _pinNoVisible,
            ),
          ),
          SizedBox(height: 24.0),
          Text(
              'Confirma el PIN:',
              style: const TextStyle(
                fontFamily: 'Helvetica neue',
                fontSize: 16,
                fontWeight: FontWeight.normal,
              )
          ),
          SizedBox(height: 4.0),
          AccentColorOverride(
            color: primaryDarkColor,
            child: TextField(
              controller: _confirmaPinController,
              decoration: InputDecoration(
                  labelText: '4 dígitos',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _confirmaPinNoVisible ? Icons.visibility_off : Icons.visibility
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmaPinNoVisible = ! _confirmaPinNoVisible;
                      });
                    },
                  )
              ),
              obscureText: _confirmaPinNoVisible,
            ),
          ),
          SizedBox(height: 40.0),
          Text(
            'Recuerda que tu pin ha de tener 4 dígitos',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Helvetica Neue',
              fontWeight: FontWeight.w200,
            ),
          ),
          SizedBox(height: 40.0),
          FlatButton(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration (
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0xFFADB0C7),
              ),
              child: const Text(
                  'Cambiar pin',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white
                  ),
              ),
              height: 64,
            ),
            onPressed: () async {
              var pin = _pinController.text;
              //var password = _passwordController.text;
              var confirmaPIN = _confirmaPinController.text;
              if (pin == confirmaPIN) {
                var jwt = await attemptLogIn(user_name, pin);
                print ('El valor de user_name es: ' + user_name);
                print ('Hola estoy aquí');
                print (jwt);
//                    if (jwt != null) {
                if (jwt['code'] == 200) {
                  //storage.write(key: "jwt", value: jwt["token"]);
                  _showSnackBar('Su pin se ha cambiado correctamente.', error: false);
                  Navigator.pop(context);
                  //Navigator.pop(context);
                  //Navigator.pop(context);
                  //Navigator.pushReplacement(
                  //    context,
                  //    MaterialPageRoute(builder: (context) => HomePage.fromBase64(jwt['token']))
                  //);
                } else {
                  _showSnackBar(jwt['user_name'], error: false);
                  //displayDialog(context, "Error de acceso", "Error: " + jwt['code'] + ": " + jwt['token']);
                }
              } else {
                _showSnackBar('El pin y su confirmación deben ser idénticos.', error: false);
              }
              // TODO: Show the next page (101)
            },
          ),
          SizedBox(height: 40.0),
        ],
      ),
    );
    Widget bodyWidget = _pleaseWait
        ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, builder])
        : Stack(key: ObjectKey("stack"), children: [builder]);

    return Scaffold (
      key: _scaffoldKey,
      body: bodyWidget,
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
        title: Text(
          'Configura el nuevo pin de seguridad',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: colorCajasTexto,
        brightness: Brightness.light,
      ),
    );
  }
}

class _Token {
  final String token;

  _Token({this.token});

  factory _Token.fromJson(Map<String, dynamic> json) {
    return _Token(
        token: json['token']
    );
  }
}
