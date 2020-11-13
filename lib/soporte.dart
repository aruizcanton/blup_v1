import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show NumberFormat hide TextDirection;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:blupv1/colors.dart';
import 'package:blupv1/utils/util.dart';

class Soporte extends StatefulWidget {
  Soporte(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;

  factory Soporte.fromBase64(String jwt) =>
      Soporte(
          jwt,
          json.decode(
              utf8.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          )
      );
  @override
  _SoporteState createState() => _SoporteState(this.jwt, this.payload);
}
class _SoporteState extends State<Soporte> {
  _SoporteState(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;

  // Variables de instancia
  final TextEditingController _mensaje = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PleaseWaitWidget _pleaseWaitWidget =
  PleaseWaitWidget (key: ObjectKey("pleaseWaitWidget"));
  bool _pleaseWait = false;
  // Fin variables de instancia

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pleaseWait = false;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
                    //Navigator.pop(context);
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              );
            }
        ),
        backgroundColor: colorCajasTexto,
        brightness: Brightness.light,
        title: Text(
          'Soporte',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: _body_builder(),
    );
  }
  _showPleaseWait(bool b) {
    setState(() {
      _pleaseWait = b;
    });
  }
  _showSnackBar(String content, {bool error = false}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text('${error ? "Ocurrió un error: " : ""}${content}'),
    ));
  }
  Future<Map> _envioMensaje (String email, String mensaje) async {
    _showPleaseWait(true);
    try {
      final http.Response res = await http.post("$SERVER_IP/envioMensaje",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': jwt
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'mensaje': mensaje,
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
        retorno['token'] = json.decode(res.body)['message'];
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

  Widget _body_builder () {
    Widget builder = SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 47.0),
          children: [
            SizedBox(height: 48.0),
            Text(
              'Mensaje:',
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
                controller: _mensaje,
                decoration: InputDecoration(
                  labelText: '',
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Text(
              'Déjanos un mensaje, nuestro equipo de soporte responderá en las siguientes 24 horas hábiles.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Helvetica Neue',
                fontWeight: FontWeight.w200,
              ),
              textAlign: TextAlign.center,
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
                  'Enviar',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white
                  ),
                ),
                height: 64,
              ),
              onPressed: () async {
                print('Estoy en el boton enviar');
                if (_mensaje.text == '') {
                  _showSnackBar('Debe introducir un mensaje en la caja de texto.',error: false);
                }else {
                  var mensaje = _mensaje.text;
                  var jwt = await _envioMensaje (payload['email'], mensaje);
                  assert(jwt != null);
                  print('Hola estoy aquí');
                  print(jwt);
                  if (jwt['code'] == 200) {
                    //                        print('Justo antes de llamar al apilar');
                    //Navigator.pushNamed(
                    //    context,
                    //    '/login/restableceContraseña/validate',
                    //    arguments: ScreenArguments(username)
                    //);
                    _showSnackBar('Su mensaje ha sido enviado. En breve se pondrá el departamento de soporte en contacto con usted.', error: false);
                  } else {
                    //                        displayDialog(context, "Error de registro", "Error: " + jwt['user_name']);
                    _showSnackBar(jwt['user_name'], error: false);
                  }
                }
              },
            ),
            SizedBox(height: 12.0),
          ],
        )
    );
    Widget bodyWidget = _pleaseWait
        ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, builder])
        : Stack(key: ObjectKey("stack"), children: [builder]);
    return bodyWidget;
  }

}