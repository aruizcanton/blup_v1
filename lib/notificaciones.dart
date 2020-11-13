import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show NumberFormat hide TextDirection;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:blupv1/colors.dart';
import 'package:blupv1/utils/util.dart';
import 'package:blupv1/model/ListaNotificaciones.dart';

class Notificaciones extends StatefulWidget {
  Notificaciones(this.jwt, this.payload);

  factory Notificaciones.fromBase64(String jwt) =>
      Notificaciones(
          jwt,
          json.decode(
              utf8.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          )
      );
  final String jwt;
  final Map<String, dynamic> payload;
  @override
  NotificacionesState createState() => NotificacionesState(this.jwt, this.payload);
}
class NotificacionesState extends State<Notificaciones> with SingleTickerProviderStateMixin {
  final String jwt;
  final Map<String, dynamic> payload;
  NotificacionesState(this.jwt, this.payload);

  // var de instancia
  final PleaseWaitWidget _pleaseWaitWidget =
  PleaseWaitWidget (key: ObjectKey("pleaseWaitWidget"));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _pleaseWait = false;
  Future<ListaNotificaciones> _listaNotificaciones;
  // Fin var de instancia
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pleaseWait = false;
    _listaNotificaciones = _obtenerNotificaciones();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: colorCajasTexto,
        brightness: Brightness.light,
        title: Text(
          'Notificaciones',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: FutureBuilder<ListaNotificaciones>(
        future: _listaNotificaciones,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Hemos obtenido los datos
            if (snapshot.data.items.length > 0){
              return ListView.builder(
                  itemCount: snapshot.data.items.length,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                        alignment: Alignment(0.0, 0.0),
                        padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFD8D8D8)),
                            //bottom: BorderSide(color: Color(0xFFD8D8D8))
                          ),
                        ),
                        child: ListTile(
                          leading: (snapshot.data.items[index].description == 'Compra folio exitosa')
                              ? Container(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            alignment: Alignment.center,
                            width: 50.0,
                            //height: 120.0,
                            child: AspectRatio(
                                aspectRatio: 3.0 / 2.0,
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  imageUrl: SERVER_IP + '/image/products/' + snapshot.data.items[index].image,
                                )
                            ),
                          )
                              : Image.asset(
                            'assets/notificacionKlincLogo.png',
                            width: 50.0,
                          ),
                          title: (snapshot.data.items[index].description == 'Retiro exitoso')
                              ? Text(
                            'Trasferencia exitosa',
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : (snapshot.data.items[index].description == 'Compra folio exitosa')
                              ? Text(
                            'Compra por ' + NumberFormat.currency(locale:'en_US', symbol: '\$', decimalDigits:0).format(snapshot.data.items[index].extracted_amount),
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : Text(
                            'Un problema con tu trasferencia',
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: (snapshot.data.items[index].description == 'Retiro exitoso')
                              ? Text(
                            'Tu trasferencia por ' + NumberFormat.currency(locale:'en_US', symbol: '\$', decimalDigits:0).format(snapshot.data.items[index].extracted_amount) +
                                ' se realizó de manera exitosa. Ya puedes consultar tu saldo en tu cuenta ' +
                                '**** **** **** **' + snapshot.data.items[index].acct_no.substring(snapshot.data.items[index].acct_no.length - 4),
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic
                            ),
                            textAlign: TextAlign.justify,
                          )
                              : (snapshot.data.items[index].description == 'Compra folio exitosa')
                              ? Text(
                            'Se ha cargado de forma exitosa el monto de ' + NumberFormat.currency(locale:'en_US', symbol: '\$', decimalDigits:0).format(snapshot.data.items[index].extracted_amount) +
                                ' por la compra de ' + snapshot.data.items[index].tipo + '. Serán restados de tu próximo pago de quincena.',
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic
                            ),
                            textAlign: TextAlign.justify,
                          )
                              : Text(
                            'Detectamos un error por parte de tu banco y la trasferencia por ' + NumberFormat.currency(locale:'en_US', symbol: '\$', decimalDigits:0).format(snapshot.data.items[index].extracted_amount) +
                                ' no se pudo realizar, inténtelo de nuevo más tarde.',
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                    );
                  }
              );
            }  else {
              return ListView(
                padding: EdgeInsets.only(left: 15, right: 15.0, top: 64),
                children: [
                  Container(
                    decoration: BoxDecoration (
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFE0E4EE),
                            offset: Offset(4.0,4.0),
                            spreadRadius: 1.0,
                            blurRadius: 15.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4.0, -4.0),
                            spreadRadius: 1.0,
                            blurRadius: 15.0,
                          ),
                        ]
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      color: colorFondo,
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          Image.asset('assets/detalleSaldoFactura.png'),
                          SizedBox(height: 40),
                          Text(
                            'Todavía no hay notificaciones',
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.w700,
                                fontSize: 25
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox (height: 16,),
                          Text(
                            'Aquí podrás ver el resumen de las ',
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                fontStyle: FontStyle.italic
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'tranacciones realizadas ',
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'del período de tu nómina actual',
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          } else {
            return _pleaseWaitWidget;
          }
        },
      ),
    );
  }

  Future<ListaNotificaciones> _obtenerNotificaciones() async {
    try {
      final String cadena = "$SERVER_IP/getNotificaciones/" +
      payload['empleado_id'].toString() + "/" +
      payload['period_id'].toString();
      print ('La cadena es: ' + cadena);
      final http.Response res = await http.get(
          cadena,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': jwt
          }
      );
      if (res.statusCode == 200){
        // Hemos obtenido las notificaciones
        print('Antes de imprimir el body');
        print(res.body);
        print('Despues de imprimir el body');
        final parsedListNotificaciones = json.decode(res.body).cast<Map<String, dynamic>>();
        return ListaNotificaciones.fomJson(parsedListNotificaciones);
      } else if (res.statusCode == 404) {
        print('Paso por el token caducado');
        Navigator.pushReplacementNamed(context, '/login');
        //throw Exception('Token caducado.');
      } else {
        throw Exception(res.statusCode.toString() + ": " + json.decode(res.body)['message'].toString());
      }
    }
    catch (e){
      throw Exception(e);
    }
  }
}