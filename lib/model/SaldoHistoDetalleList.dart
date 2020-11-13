import 'package:flutter/foundation.dart';

import 'package:blupv1/model/SaldoHistoDetalle.dart';

class SaldoHistoDetalleList {
  final List<SaldoHistoDetalle> _items = [];

  /// List of items in the List.
  List<SaldoHistoDetalle> get items => _items.map((item) => item).toList();

  /// The current total number of items
  int get numElements => _items.length;

  /// Adds [item] to List.
  void add(SaldoHistoDetalle item) {
    _items.add(item);
  }

  /// Remove [item] to from List.
  void removeAll(){
    _items.clear();
  }
}