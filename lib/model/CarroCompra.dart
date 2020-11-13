import 'package:flutter/foundation.dart';

import 'package:blupv1/model/productComprado.dart';
//import 'package:blupv1/model/SaldoHistoDetalle.dart';

class CarroCompra extends ChangeNotifier {
  final List<ProductComprado> _items = [];

  /// List of items in the List.
  List<ProductComprado> get items => _items.map((item) => item).toList();

  /// The current total number of items
  int get numElements => _items.length;

  /// Adds [item] to List.
  void add(ProductComprado item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAll(){
    _items.clear();
    notifyListeners();
  }

}