import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'home.dart';
import 'colors.dart';
import 'dart:async';
import 'dart:io';
import 'utils/util.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class validateRegistryPage extends StatefulWidget {
  final String user_name;
  validateRegistryPage(this.user_name);
  @override
  _validateRegistryPageState createState() => _validateRegistryPageState(this.user_name);
}
class _validateRegistryPageState extends State<validateRegistryPage> {
  // TODO: Add text editing controllers (101)
  _validateRegistryPageState(this.user_name);
  final String user_name;

  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmaPassController = TextEditingController();

  bool _passwordNoVisible=true;
  bool _confirmaPassNoVisible=true;
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
  Future<Map> attemptLogIn(String user_name, String password, String pin) async {
    _showPleaseWait(true);
    try {
      print ('El user_name es: ' + user_name);
      print ('La password es: ' + password);
      print ('El pin es: ' + pin);
      final http.Response res = await http.post("$SERVER_IP/validacion",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'user_name': user_name,
            'password': password,
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
        retorno['token'] = json.decode(res.body)['token'];
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
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          SizedBox(height: 80.0),
          Column(
            children: <Widget>[
              Image.asset('assets/KlincLogo.png'),
              SizedBox(height: 32.0),
              Text(
                'Valida tu registro',
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          SizedBox(height: 32.0),
          Text(
              'Código invitación enviado a tu correo:',
              style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 4.0),
          AccentColorOverride(
            color: primaryDarkColor,
            child: TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: '6 dígitos',
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
          // [Password]
          Text(
              'Contraseña:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              )
          ),
          SizedBox(height: 4.0),
          AccentColorOverride(
            color: primaryDarkColor,
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: '8 dígitos',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _passwordNoVisible ? Icons.visibility_off : Icons.visibility
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordNoVisible = ! _passwordNoVisible;
                      });
                    },
                  )
              ),
              obscureText: _passwordNoVisible,
            ),
          ),
          SizedBox(height: 24.0),
          Text(
              'Repite la contraseña:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              )
          ),
          SizedBox(height: 4.0),
          AccentColorOverride(
            color: primaryDarkColor,
            child: TextField(
              controller: _confirmaPassController,
              decoration: InputDecoration(
                  labelText: '8 dígitos',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _confirmaPassNoVisible ? Icons.visibility_off : Icons.visibility
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmaPassNoVisible = ! _confirmaPassNoVisible;
                      });
                    },
                  )
              ),
              obscureText: _confirmaPassNoVisible,
            ),
          ),
          SizedBox(height: 72.0),
          RaisedButton(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
                  'Empezar ahora',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white
                  )
              ),
              height: 64,
            ),
            elevation: 8.0, // New code
            onPressed: () async {
              var pin = _pinController.text;
              var password = _passwordController.text;
              var confirmaPassword = _confirmaPassController.text;
              if (password == confirmaPassword) {
                var jwt = await attemptLogIn(user_name, password, pin);
                print ('El valor de user_name es: ' + user_name);
                print ('Hola estoy aquí');
                print (jwt);
//                    if (jwt != null) {
                if (jwt['code'] == 200) {
                  storage.write(key: "jwt", value: jwt["token"]);
                  //Navigator.pop(context);
                  //Navigator.pop(context);
                  //Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage.fromBase64(jwt['token']))
                  );
                } else {
                  _showSnackBar(jwt['user_name'], error: false);
                  //displayDialog(context, "Error de acceso", "Error: " + jwt['code'] + ": " + jwt['token']);
                }
              } else {
                _showSnackBar('La contraseña y su confirmación deben ser idénticas', error: false);
              }
            },
          ),
          SizedBox(height: 120.0),
          Center(
            child: Text(
              '¿Ya tienes una cuenta?',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Center(
            child: Text.rich(
              TextSpan(
                  text: 'Entrar aquí',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0XFF4895F6),
                      decoration: TextDecoration.underline
                  ),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pop(context);
                    }
              ),
            ),
          )
        ],
      ),
    );
    Widget bodyWidget = _pleaseWait
        ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, builder])
        : Stack(key: ObjectKey("stack"), children: [builder]);

    return Scaffold(
      key: _scaffoldKey,
      body: bodyWidget
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