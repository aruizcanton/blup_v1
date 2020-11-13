import 'package:blupv1/model/product.dart';
class Almacen {
  final List<Product> items;

  Almacen ({this.items});

  factory Almacen.fomJson(List<Map<String, dynamic>> json) {
    //final parsedItems = json.cast<Map<String, dynamic>>();
    final parsedItems = json;
    final List<Product> almacenDetalleList = parsedItems.map<Product>((json) => Product.fomJson(json)).toList();
    return Almacen(
      items: almacenDetalleList
    );
  }
}