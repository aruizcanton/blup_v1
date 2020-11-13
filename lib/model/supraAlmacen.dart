import 'package:blupv1/model/product.dart';
import 'package:blupv1/model/productComprado.dart';

class SupraAlmacen {
  final List<Product> itemsProductosDisponibles;
  final List<ProductComprado> itemsProductosComprados;

  SupraAlmacen ({this.itemsProductosDisponibles, this.itemsProductosComprados});

  factory SupraAlmacen.fomJson(List<Map<String, dynamic>> jsonProdDisponibles, List<Map<String, dynamic>> jsonProdComprados) {
    //final parsedItems = json.cast<Map<String, dynamic>>();
    final parsedItems = jsonProdDisponibles;
    final List<Product> almacenDetalleList = parsedItems.map<Product>((json) => Product.fomJson(json)).toList();

    final parsedItemsProdComprados = jsonProdComprados;
    final List<ProductComprado> almacenDetalleListComprados = parsedItemsProdComprados.map<ProductComprado>((json) => ProductComprado.fomJson(json)).toList();

    return SupraAlmacen(
      itemsProductosDisponibles: almacenDetalleList,
      itemsProductosComprados: almacenDetalleListComprados
    );
  }
}