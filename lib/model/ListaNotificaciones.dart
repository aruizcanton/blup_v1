import 'package:flutter/foundation.dart';

import 'package:blupv1/model/Notificacion.dart';

class ListaNotificaciones {
  //final List<Notificacion> _items = [];
  final List<Notificacion> items;

  ListaNotificaciones({this.items});

  factory ListaNotificaciones.fomJson(List<Map<String, dynamic>> json) {

    final parsedListaNotificaciones = json;
    final List<Notificacion> items_temp = json.map<Notificacion>((json) => Notificacion.fomJson(json)).toList();
    return new ListaNotificaciones(
        items: items_temp
    );
  }
}