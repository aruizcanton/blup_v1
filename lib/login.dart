import 'package:blupv1/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'dart:async';
import 'dart:io';
import 'utils/util.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  // TODO: Add text editing controllers (101)
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _recordarContrasena=false;
  bool _passwordNoVisible=true;

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
  Future<String> passWordOrEmpty () async {
    var password = await storage.read(key: "password");
    if(password == null) return "";
    return password;
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
  Future<Map> attemptLogIn(String username, String password) async {
    _showPleaseWait(true);
    try {
      final http.Response res = await http.post("$SERVER_IP/login",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'user_name': username,
          'password': password,
          'gethash': 'true'
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
        retorno['token'] = json.decode(res.body)['message'];
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
          AccentColorOverride (
            color: secondaryDarkColor,
            child: TextField (
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
          AccentColorOverride (
            color: secondaryDarkColor,
            child: TextField(
              controller: _passwordController,
              onTap: () async {
                var password = await storage.read(key: _usernameController.text);
//                print ('&&&&& Si que estoy en el callback de onTap');
                if(password != null) {
                  print ('La password es: ' + password);
                  _passwordController.text = password;
                  setState(() {
                    _recordarContrasena= true;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Contraseña',
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
          // TODO: Add TextField widgets (101)
          // TODO: Add button bar (101)
          Container (
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: _recordarContrasena,
                  onChanged: (bool newValue) {
                    setState(() {
                      _recordarContrasena = newValue;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Recordar mi contraseña',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                    )
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
                child: Text('Registrarse'),
                elevation: 8.0, // New code
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      'login/registry',
                      arguments: ScreenArguments(_usernameController.text)
                  );
                },
              ),

              // TODO: Add an elevation to NEXT (103)
              // TODO: Add a beveled rectangular border to NEXT (103)
              RaisedButton(
                child: Text('ENTRAR'),
                elevation: 8.0, // New code
                onPressed: () async {
                  try {
                    if (_usernameController.text == '') {
                      _showSnackBar('Debe introducir un email.', error: false);
                    } else if (_passwordController.text == '') {
                      _showSnackBar(
                          'Debe introducir una password.', error: false);
                    } else if (!validateEmail(_usernameController.text)) {
                      _showSnackBar(
                          'Debe introducir un correo electrónico correcto.',
                          error: false);
                    } else {
                      var username = _usernameController.text;
                      var password = _passwordController.text;
                      var jwt = await attemptLogIn(username, password);
                      print('Hola estoy aquí');
                      print(jwt);
                      //                    if (jwt != null) {
                      if (jwt['code'] == 200) {
                        // Guardo el token de seguridad en local
                        storage.write(key: "jwt", value: jwt["token"]);
                        // Guardo el token de seguridad en la variable global appToken
                        print('Después de la decodificacion');
                        if (_recordarContrasena) {
                          storage.write(key: _usernameController.text,
                              value: _passwordController.text);
                          print('Paso por el recordar contraseña');
                          print('El usuario es: ' + _usernameController.text);
                          print(
                              'La password es: ' + _passwordController.text);
                        } else {
                          storage.delete(key: _usernameController.text);
                        }
                        //Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage.fromBase64(jwt['token']))
                        );
                      } else {
                        _showSnackBar(jwt['token'], error: false);
                        //                    displayDialog(context, "Error de acceso", "Error: " + jwt['token']);
                      }
                    }
                  }catch (e) {
                    _showSnackBar(e.toString(), error: false);
                    print('Error' + e.toString());
                  }
                  // TODO: Show the next page (101)
                },
              ),
            ],
          ),
          SizedBox(height: 55.0),
          Container(
            child: Row(
              children: <Widget>[
                Text(
                    '¿Olvidaste tu contraseña?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    )
                ),
                Text.rich(
                  TextSpan(
                      text: '. ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Restablécela aquí',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline
                            ),
                            recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context,
                                  '/login/restableceContraseña',
                                  arguments: ScreenArguments(_usernameController.text),
                              );
                            }
                        ),
                      ]
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    Widget bodyWidget = _pleaseWait
        ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, builder])
        : Stack(key: ObjectKey("stack"), children: [builder]);
    return Scaffold(
      key: _scaffoldKey,
      body: bodyWidget,
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



