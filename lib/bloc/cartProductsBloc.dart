import 'dart:async';

import 'package:blupv1/model/productComprado.dart';

class CartProductsBloc {
  /// The [cartStreamController] is an object of the StreamController class
  /// .broadcast enables the stream to be read in multiple screens of our app
  final cartStreamController = new StreamController.broadcast();
  /// The [getStream] getter would be used to expose our stream to other classes
  Stream get getStream => cartStreamController.stream;

  set (List<Map<String, dynamic>> shopItems) {
    print('Entro en el set');
    allItems['shopItems'].clear();
    allItems['cartItems'].clear();
    print('Después de borrar');
    print('Imprimo los elementos de la lista');
    print (allItems['shopItems']);
    print('Los he imprimido');
    for (var i = 0; i< shopItems.length; i++){
      allItems['shopItems'].add({
        'product_id': int.parse(shopItems[i]['product_id']),
        'product_name': shopItems[i]['product_name'].toString(),
        'image': shopItems[i]['image'].toString(),
        'avail': int.parse(shopItems[i]['avail']),
        'product_price': int.parse(shopItems[i]['product_price']),
        'comission': int.parse(shopItems[i]['comission'])
      });
      //allItems['cartItems'].add({
      //  'product_id': shopItems[i]['product_id'],
      //  'product_name': shopItems[i]['product_name'],
      //  'image': shopItems[i]['image'],
      //  'avail': 0,
      //  'product_price': shopItems[i]['product_price'],
      //  'comission': shopItems[i]['comission']
      //});
      print ('Entro en el bucle dentro de cartProductsBloc');
      print (shopItems[i]);
    };
    print (allItems['shopItems']);
    cartStreamController.sink.add(allItems);
    //shopItems.map((item) => allItems['shopItems'].add(item)).toList();
    //shopItems.map((item) => _itemsParaVender.add(item)).toList();
  }

  Map allItems = {
    //'shopItems' : [{'product_id':1, 'product_name':'AMAZON', 'image':'amazon.png', 'avail':5, 'product_price':500, 'comission':10}],
    'shopItems' : List<Map<String, dynamic>>(),
    'cartItems' : List<ProductComprado>()
  };

  void addToCart(item) {
    //allItems['cartItems'].add(item);
    print('Ya dentro de addToCart.');
    print(item);
    //item['avail'] = item['avail']+1;
    allItems['cartItems'].add(item);
    print('Ya dentro de addToCart. Después de haber hecho el incremento de index');
    print(allItems['cartItems']);
    //allItems['shopItems'].remove(item);
    cartStreamController.sink.add(allItems);
  }

  void removeFromCart(item) {
    print ('Estoy en el Remove');
    print('Antes de borrar un elemento');
    print(allItems['cartItems']);
    allItems['cartItems'].remove(item);
    print('Después de haber borrado un elemento');
    print(allItems['cartItems']);
    //allItems['cartItems'][index]['avail'] = (int.parse(allItems['cartItems'][index]['avail'])-1).toString();
    //allItems['shopItems'].add(item);
    cartStreamController.sink.add(allItems);
  }

  void removeAllFromCart(){
    allItems['shopItems'].clear();
    allItems['cartItems'].clear();
    cartStreamController.sink.add(allItems);
  }

  int numberShopItems() {
    return allItems['shopItems'].length;
  }
  /// The [dispose] method is used
  /// to automatically close the stream when the widget is removed from the widget tree
  void dispose() {
    cartStreamController.close(); // close our StreamController
  }
}

final bloc = CartProductsBloc();
