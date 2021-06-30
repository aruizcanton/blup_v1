import 'package:flutter/material.dart';
import 'colors.dart';
import 'dart:async';
import 'dart:io';
import 'utils/util.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class validateResetPage extends StatefulWidget {
  final String user_name;
  validateResetPage(this.user_name);
  @override
  _validateResetPageState createState() => _validateResetPageState(this.user_name);
}

class _validateResetPageState extends State<validateResetPage> {
  // TODO: Add text editing controllers (101)
  final String user_name;
  _validateResetPageState(this.user_name);
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmaPassController = TextEditingController();
  bool _recordarContrasena=false;
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
      final http.Response res = await http.post("$SERVER_IP/validacionPassword",
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
      _showSnackBar(e.toString(), error: false);
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
          Text(
            'Introduce tu PIN :',
            style: const TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 16.0,
                fontWeight: FontWeight.normal
            ),
          ),
          SizedBox(height: 4.0),
          AccentColorOverride(
            color: primaryDarkColor,
            child: TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: '4 dígitos',
                suffixIcon: IconButton(
                  icon: Icon(
                      _pinNoVisible ? Icons.visibility_off : Icons.visibility
                  ),
                  onPressed: () {
                    setState(() {
                      _pinNoVisible = ! _pinNoVisible;
                    });
                  },
                )
              ),
              obscureText: _pinNoVisible,
            ),
          ),
          SizedBox(height: 24.0),
          Text(
            'Nueva contraseña:',
            style: const TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 16.0,
                fontWeight: FontWeight.normal
            ),
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
            'Confirmar nueva contraseña:',
            style: const TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 16.0,
                fontWeight: FontWeight.normal
            ),
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
          SizedBox(height: 40.0),
          Text(
            'Recuerda que tu contraseña ha de tener al menos 6 caracteres.',
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
                'Cambiar contraseña',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white
                ),
              ),
              height: 64,
            ),
            onPressed: () async {
              var pin = _pinController.text;
              var password = _passwordController.text;
              var confirmaPassword = _confirmaPassController.text;
              // Comprobamos que la contraseña y su confirmacion son iguales
              if (password == confirmaPassword) {
                var jwt = await attemptLogIn(user_name, password, pin);
                print ('El valor de user_name es: ' + user_name);
                print ('Hola estoy aquí');
                print (jwt);
//                    if (jwt != null) {
                if (jwt['code'] == 200) {
                  Navigator.pop(context);
                  Navigator.pop(context);
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => HomePage())
//                      );
                } else {
                  //displayDialog(context, "Error de acceso", "Error: " + jwt['code'] + ": " + jwt['token']);
                  _showSnackBar(jwt['user_name'], error: false);
                }
              } else {
                _showSnackBar('La contraseña y su confirmación deben ser idénticas', error: false);
              }
            },
          ),
        ],
      ),
    );
    Widget bodyWidget = _pleaseWait
        ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, builder])
        : Stack(key: ObjectKey("stack"), children: [builder]);
    return Scaffold(
        key: _scaffoldKey,
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
            'Cambiar contraseña',
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
        body: bodyWidget
    );
  }
}
