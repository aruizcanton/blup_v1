import 'package:flutter/material.dart';
import 'colors.dart';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

const SERVER_IP = 'http://192.168.2.104:9000/server';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  // TODO: Add text editing controllers (101)
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool valor=false;

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
  Future<Map> attemptLogIn(String username, String password) async {
    try {
      final http.Response res = await http.post("http://192.168.2.104:9000/server/login",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'user_name': username,
          'password': password,
          'gethash': 'true'
        })
      );
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
        retorno['token'] = json.decode(res.body)['message'];
      }
      return retorno;
    } catch (e) {
      print('Ha habido un error');
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/outline_monetization_on_black_48.png'),
                SizedBox(height: 16.0),
                Text(
                  'Bienvenido a BLUP',
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),
            SizedBox(height: 120.0),
            // TODO: Wrap Username with AccentColorOverride (103)
            // [Name]
            AccentColorOverride(
              color: secondaryDarkColor,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
              ),
            ),
            SizedBox(height: 12.0),
            // TODO: Remove filled: true values (103)
            // TODO: Wrap Password with AccentColorOverride (103)
            // [Password]
            AccentColorOverride(
              color: secondaryDarkColor,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ),
            // TODO: Add TextField widgets (101)
            // TODO: Add button bar (101)
            Container(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: valor,
                    onChanged: (bool newValue) {
                      valor = newValue;
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Recordar mi contraseña',
                    ),
                  ),
                ],
              ),
            ),
            ButtonBar(
              // TODO: Add a beveled rectangular border to CANCEL (103)
              children: <Widget>[
                // TODO: Add buttons (101)
                RaisedButton(
                  child: Text('Cancelar'),
                  elevation: 8.0, // New code
                  onPressed: () {
                    // TODO: Show the next page (101)
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),

                // TODO: Add an elevation to NEXT (103)
                // TODO: Add a beveled rectangular border to NEXT (103)
                RaisedButton(
                  child: Text('ENTRAR'),
                  elevation: 8.0, // New code
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var jwt = await attemptLogIn(username, password);
                    print ('Hola estoy aquí');
                    print (jwt);
                    if (jwt != null) {
//                    if (jwt['code'] == 200) {
                      Navigator.pop(context);
                    } else {
                      displayDialog(context, "Error de acceso", "No existe ninguna cuenta que corresponda a ese usuario y password.");
                    }
                    // TODO: Show the next page (101)
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// TODO: Add AccentColorOverride (103)
class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
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
class _MensajeRetorno {
  final int error;
  final _Token token;
  final String mensaje;

  _MensajeRetorno(this.error, this.token, this.mensaje);
}



