import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'colors.dart';
import 'utils/util.dart';

class RegistryPage extends StatefulWidget {
  final String user_name;
  RegistryPage(this.user_name);
  @override
  _RegistryPageState createState() => _RegistryPageState(user_name);
}

class _RegistryPageState extends State<RegistryPage> {
  // TODO: Add text editing controllers (101)
  final String user_name;
  _RegistryPageState(this.user_name);
  TextEditingController _usernameController = TextEditingController();
  //TextEditingController _usernameController = TextEditingController();
  bool _aceptoTerminosYcondiciones=false;
  bool _aceptoPoliticaDePrivacidad=false;

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
  @override
  void initState(){
    super.initState();
    _usernameController.text = user_name;
  }
  @override
  void dispose (){
    _usernameController.dispose();
    super.dispose();
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
  Future<Map> attemptRegistry(String username) async {
    _showPleaseWait(true);
    try {
      final http.Response res = await http.post('$SERVER_IP/registro',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{
            'user_name': username
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
        retorno['user_name'] = json.decode(res.body)['user_name'];
        print('Imprimo');
        print(retorno['user_name']);
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
                  'Crea una cuenta',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
            SizedBox(height: 140.0),
            Text('Correo:'),
            SizedBox(height: 4.0),
            // [Name]
            AccentColorOverride(
              color: primaryDarkColor,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'usuario@compañía.com',
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Container(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: _aceptoTerminosYcondiciones,
                    onChanged: (bool newValue) {
                      setState(() {
                        _aceptoTerminosYcondiciones = newValue;
                      });
                    },
                  ),
                  Expanded(
                    child: Text.rich(
                        TextSpan(
                            text: 'Acepto los',
                            style: Theme.of(context).textTheme.caption,
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' Términos, Condiciones y la Política de Privacidad',
                                  style: Theme.of(context).textTheme.caption,
                              )
                            ]
                        )
                    ),
                  ),
                ],
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
              elevation: 8.0,
              onPressed: () async {
                if (_usernameController.text == '') {
                  _showSnackBar('Debe introducir un email.',error: false);
                } else if (! validateEmail(_usernameController.text)) {
                  _showSnackBar('Debe introducir un correo electrónico correcto.',error: false);
                }else {
                  // Compruebo que se han aceptados los terminos y condiciones asi como la politica de privacidad
                  if (_aceptoTerminosYcondiciones) {
                    var username = _usernameController.text;
                    var jwt = await attemptRegistry(username);
                    assert(jwt != null);
                    print('Hola estoy aquí');
                    print(jwt);
                    if (jwt['code'] == 200) {
                      //                        print('Justo antes de llamar al apilar');
                      Navigator.pushNamed(
                          context,
                          'login/registry/validate',
                          arguments: ScreenArguments(username)
                      );
                    } else {
                      //                        displayDialog(context, "Error de registro", "Error: " + jwt['user_name']);
                      _showSnackBar(jwt['user_name'], error: false);
                    }
                  } else {
                    _showSnackBar(
                        "Debe aceptar los términos y condiciones así como la política de privacidad.", error: false);
                  }
                }
                // TODO: Show the next page (101)
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