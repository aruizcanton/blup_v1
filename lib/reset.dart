import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'colors.dart';
import 'utils/util.dart';

class ResetPage extends StatefulWidget {
  final String user_name;
  ResetPage(this.user_name);
  @override
  _ResetPageState createState() => _ResetPageState(user_name);
}
class _ResetPageState extends State<ResetPage> {
  // TODO: Add text editing controllers (101)
  final String user_name;
  _ResetPageState(this.user_name);
  final TextEditingController _usernameController = TextEditingController();

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
  Future<Map> attemptReset(String username) async {
    _showPleaseWait(true);
    try {
      final http.Response res = await http.post('$SERVER_IP/resetPassword',
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
      print(res.body);
      print(res.toString());
      print(res.contentLength);
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
        padding: EdgeInsets.symmetric(horizontal: 47.0),
        children: <Widget>[
          SizedBox(height: 48.0),
          Text(
            'Correo:',
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
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'usuario@compañia.com',
              ),
            ),
          ),
          SizedBox(height: 40.0),
          Text(
            'Recuerda que tu correo debe estar ya previamente registrado en nuestra plataforma.',
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
              if (_usernameController.text == '') {
                _showSnackBar('Debe introducir un correo.',error: false);
              } else if (! validateEmail(_usernameController.text)) {
                _showSnackBar('Debe introducir un correo correcto.',error: false);
              }else {
                var username = _usernameController.text;
                var jwt = await attemptReset(username);
                assert(jwt != null);
                print('Hola estoy aquí');
                print(jwt);
                if (jwt['code'] == 200) {
                  //                        print('Justo antes de llamar al apilar');
                  Navigator.pushNamed(
                      context,
                      '/login/restableceContraseña/validate',
                      arguments: ScreenArguments(username)
                  );
                } else {
                  //                        displayDialog(context, "Error de registro", "Error: " + jwt['user_name']);
                  _showSnackBar(jwt['user_name'], error: false);
                }
              }
            },
          ),
          SizedBox(height: 12.0),
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
            'Restablecer contraseña',
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

