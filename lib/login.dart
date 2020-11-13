import 'package:blupv1/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:blupv1/colors.dart';
import 'dart:async';
import 'dart:io';
import 'package:blupv1/utils/util.dart';
import 'package:blupv1/bloc/cartProductsBloc.dart';

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
              Image.asset('assets/KlincLogo.png'),
              SizedBox(height: 24.0),
              Text(
                'Iniciar sesión',
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
          SizedBox(height: 32.0),
          Text(
            'Correo:',
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 4.0),
          AccentColorOverride (
            color: primaryDarkColor,
            child: TextField (
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'usuario@compañía.com',
              ),
            ),
          ),
          SizedBox(height: 24.0),
          Text(
            'Contraseña:',
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 4.0),
          AccentColorOverride (
            color: primaryDarkColor,
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
                labelText: '8 dígitos',
                //fillColor: primaryLightColor,
                //filled: true,
                suffixIcon: IconButton(
                  icon: Icon(
                      _passwordNoVisible ? Icons.visibility_off : Icons.visibility
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordNoVisible = ! _passwordNoVisible;
                    });
                  },
                ),
              ),
              obscureText: _passwordNoVisible,
            ),
          ),
          SizedBox(height: 24.0),
          Container (
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: SizedBox(
                      width: Checkbox.width,
                      height: Checkbox.width,
                      child: Container(
                        decoration: new BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                          ),
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        child: Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors.transparent,
                          ),
                          child: Checkbox(
                            value: _recordarContrasena,
                            onChanged: (bool newValue) {
                              setState(() {
                                _recordarContrasena = newValue;
                              });
                            },
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Recordar mi contraseña',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
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
                'Entrar',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white
                )
              ),
              height: 64,
            ),
            elevation: 8.0, // New
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
                    storage.delete(key: "jwt");
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
                    // Meto los productos para vender en el almacen
                    Map<String, dynamic> otroPayload;
                    otroPayload = json.decode(
                        utf8.decode(
                            base64.decode(base64.normalize(jwt['token'].split(".")[1]))
                        )
                    );
                    // Gravo en el espacio local la cantidad máxima que puedo retirar
                    print('Antes de escribir en el Storage el valor de max_permitido. Su valor es: ' + otroPayload['max_permitido'].toString());
                    storage.delete(key: "max_permitido");
                    storage.write(key: "max_permitido", value: otroPayload['max_permitido'].toString());
                    print('Escrito el valor de max_permitido');
                    var max_permitido = await storage.read(key: "max_permitido");
                    print('Leído de nuevo el valor de max_permitido: ' + max_permitido);
                    // Fin grabacion
                    var temp =  new List<Map<String, dynamic>>();
                    for (var i = 0; i< otroPayload['productsAvail'].length; i++) {
                      temp.add({
                        'product_id': otroPayload['productsAvail'][i]['PRODUCT_ID'],
                        'product_name': otroPayload['productsAvail'][i]['PRODUCT_NAME'],
                        'image': otroPayload['productsAvail'][i]['IMAGE'],
                        'avail': otroPayload['productsAvail'][i]['AVAIL'],
                        'product_price': otroPayload['productsAvail'][i]['PRODUCT_PRICE'],
                        'comission': otroPayload['productsAvail'][i]['COMISSION']
                      });
                      print ('Entro en el bucle');
                    };
                    print ('Después de cargar bloc');
                    bloc.removeAllFromCart();
                    bloc.set(temp);
                    for(var i= 0; i < bloc.allItems['shopItems'].length; i++) {
                      print (bloc.allItems['shopItems'][i]);
                    }
                    print ('Justo después de imprimir los elementos del almacen');
                    // Fin
                    //Navigator.pop(context);
                    Navigator.pushReplacement (
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
          SizedBox(height: 24.0),
          Container(
            child: Row(
              children: <Widget>[
                Text(
                    '¿Olvidaste tu contraseña?',
                    style: Theme.of(context).textTheme.caption,
                ),
                Text.rich(
                  TextSpan(
                      text: '. ',
                      style: Theme.of(context).textTheme.caption,
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Restablécela aquí',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0XFF4895F6),
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
          SizedBox(height: 115.0),
          Text(
            '¿Todavía no tines una cuenta?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 8.0),
          Center(
            child: Text.rich(
              TextSpan (
                text: 'Regístrate',
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0XFF4895F6),
                    decoration: TextDecoration.underline
                ),
                recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(
                    context,
                    'login/registry',
                    arguments: ScreenArguments(_usernameController.text),
                  );
                }
              )
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



