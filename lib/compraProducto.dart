import 'package:blupv1/bloc/cartProductsBloc.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show NumberFormat hide TextDirection;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:blupv1/colors.dart';
import 'package:blupv1/model/product.dart';
import 'package:blupv1/model/purchasedProduct.dart';
import 'package:blupv1/model/productComprado.dart';
import 'package:blupv1/utils/util.dart';

class CompraProducto extends StatefulWidget {
  CompraProducto(this.jwt, this.payload, this.productoAComprar);
  factory CompraProducto.fromBase64(String jwt, productoAComprar) =>
      CompraProducto(
          jwt,
          json.decode(
              utf8.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          ),
          productoAComprar
      );
  final String jwt;
  final Map<String, dynamic> payload;
  final Product productoAComprar;
  @override
  CompraProductoState createState() => CompraProductoState(this.jwt, this.payload, productoAComprar);
}
class CompraProductoState extends State<CompraProducto> with SingleTickerProviderStateMixin {
  CompraProductoState(this.jwt, this.payload, this.productoAComprar);

  final String jwt;
  final Map<String, dynamic> payload;
  final Product productoAComprar;

  final PleaseWaitWidget _pleaseWaitWidget =
  PleaseWaitWidget (key: ObjectKey("pleaseWaitWidget"));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _importeProductos;          // Importe total de los productos comprados
  int _importeComision;           // Importe total de la comisión de los productos comprados
  int _importeTotal;              // Importe total = Importe productos comprados + Importe de la comisión de los pro. comprados
  bool _confirmaRetiro = false;   // switch para saber si el usuario confirma el retiro o no
  bool _pleaseWait = false;       // Switch para mostrar la animación cuando se está esperando una acción
  List <Product> _productosComprados = [];    //Almaceno los productos que el usuario ha comprado pulsando las teclas + y -
  //List <ProductComprado> _productosCompradosRetornados = [];   // Almaceno los productos que devuelve el Backend que realmente se han comprado
  int _numUnidades = 1;           // Número de unidades que se van a comprar
  int _puedesRetirar;


  //////////////////////////////////////////////////////////
  // Función que construye la ventana
  //////////////////////////////////////////////////////////
  Widget pantalla (BuildContext context, Product productoAComprar) {
    return LayoutBuilder(
        builder: (context, constraints){
          print ('Comienzo la compra ...');
          print ('El ancho de la pantalla es: ' + constraints.maxWidth.toString());
          double anchoImagen = constraints.maxWidth * 0.998;  // Constante que determino = 0,475
          print ('El ancho de la foto es: ' + anchoImagen.toString());
          Widget builder = SafeArea (
            child: ListView (
              children: [
                Row (
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
                      alignment: Alignment.center,
                      width: anchoImagen,
                      child: AspectRatio(
                        aspectRatio: 3.0 / 2.0,
                        child: CachedNetworkImage(
                          placeholder: (context, url) => CircularProgressIndicator(),
                          imageUrl: SERVER_IP + '/image/products/' + productoAComprar.image,
                          //imageUrl: SERVER_IP + '/image/products/cinemex_compra.png',
                          //imageUrl: SERVER_IP + '/image/products/cinemex.png',
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Image.asset('assets/compraProductoBolsaCaudal.png'),
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text(
                            new NumberFormat.currency(locale:'en_US', symbol: '\$', decimalDigits:0).format(int.parse(productoAComprar.product_price.toString())),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 40.0,
                              fontFamily: 'SF Pro Display',
                            ),
                            textAlign: TextAlign.start
                        ),
                      ),
                      Text(
                          productoAComprar.poduct_description,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 32.0,
                            fontFamily: 'SF Pro Display',
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF36B0F8),
                          ),
                          textAlign: TextAlign.start

                      )
                    ],
                  ),
                ),
                SizedBox(height: 4.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                          productoAComprar.poduct_name,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'SF Pro Display',
                            fontStyle: FontStyle.normal,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.start
                      ),
                    )
                  ],
                ),
                SizedBox(height: 2.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                          productoAComprar.product_type,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 24.0,
                            fontFamily: 'SF Pro Display',
                            fontStyle: FontStyle.normal,
                            color: Color(0xFF36B0F8),
                          ),
                          textAlign: TextAlign.start
                      ),
                    )

                  ],
                ),
                SizedBox(height: 2.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                          productoAComprar.brand,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 24.0,
                            fontFamily: 'SF Pro Display',
                            fontStyle: FontStyle.normal,
                            color: Color(0xFF6C6D77),
                          ),
                          textAlign: TextAlign.start
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 17),
                  child: Center(
                      child: Text(
                        productoAComprar.remark,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0,
                          fontFamily: 'SF Pro Display',
                          fontStyle: FontStyle.normal,
                          color: Color(0xFF6C6D77),
                        ),
                      )
                  ),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: Text(
                    'Cantidad',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 24.0,
                      fontFamily: 'SF Pro Display',
                      fontStyle: FontStyle.normal,
                      color: Color(0xFF6C6D77),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        onPressed: () {
                          print('Estoy en el boton -');
                          print('El numero de unidades existentes es: ' + productoAComprar.avail.toString());
                          if (_numUnidades > 1) {
                            setState(() {
                              _importeProductos = _importeProductos - productoAComprar.product_price;
                              _importeComision = _importeComision - productoAComprar.comission;
                              _importeTotal = _importeProductos + _importeComision;
                              _productosComprados.remove(productoAComprar);
                              _numUnidades = _numUnidades - 1;
                            });
                          }
                          print('el numero de unidades es: ' + _numUnidades.toString());
                          print('El _importeProductos es: ' + _importeProductos.toString());
                          print('El _importeComision es: ' + _importeComision.toString());
                          print('El _importeTotal es: ' + _importeTotal.toString());
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: colorFondo,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF6C6D77),
                              width: 1,
                            ),
                          ),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            alignment: Alignment.center,
                            child: Text(
                              '-',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 24.0,
                                fontFamily: 'SF Pro Display',
                                fontStyle: FontStyle.normal,
                                color: Color(0xFF6C6D77),
                              ),
                            ),
                          ),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        _numUnidades.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.0,
                          fontFamily: 'SF Pro Display',
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    FlatButton(
                        onPressed: () {
                          print('Estoy en el boton +');
                          print('El numero de unidades existentes es: ' + productoAComprar.avail.toString());
                          if (_numUnidades < productoAComprar.avail) {
                            setState(() {
                              _importeProductos = _importeProductos + productoAComprar.product_price;
                              _importeComision = _importeComision + productoAComprar.comission;
                              _importeTotal = _importeProductos + _importeComision;
                              _productosComprados.add(productoAComprar);
                              _numUnidades = _numUnidades +1;
                            });
                            print('el numero de unidades es: ' + _numUnidades.toString());
                            print('El _importeProductos es: ' + _importeProductos.toString());
                            print('El _importeComision es: ' + _importeComision.toString());
                            print('El _importeTotal es: ' + _importeTotal.toString());
                          } else {
                            print('Ya se ha llegado al máximo de unidades disponibles');
                            _showSnackBar('El máximo disponible de este producto es: ' + productoAComprar.avail.toString());
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: colorFondo,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF6C6D77),
                              width: 1,
                            ),
                          ),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            alignment: Alignment.center,
                            child: Text(
                              '+',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 24.0,
                                fontFamily: 'SF Pro Display',
                                fontStyle: FontStyle.normal,
                                color: Color(0xFF6C6D77),
                              ),
                            ),
                          ),
                        )
                    )
                  ],
                ),
                SizedBox(height: 35.0),
                Padding(
                  padding: const EdgeInsets.only(left: 17.0, right: 17.0),
                  child: RaisedButton(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration (
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color (0xFFA007EB),
                              Color (0XFF567DF4),
                              Color (0xFF04FFFE)
                            ],
                          )
                      ),
                      //padding: const EdgeInsets.fromLTRB(145.0, 20.0, 145.0, 20.0),
                      child: const Text(
                          'Comprar',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white
                          )
                      ),
                      height: 64,

                    ),
                    elevation: 8.0, // New
                    onPressed: () async {
                      try{
                        print ('El importe total es: ' + _importeTotal.toString());
                        print ('El valor de puedesRetirar es: ' + _puedesRetirar.toString());
                        if (_importeTotal <= _puedesRetirar) {
                          await _displayDialog (context, _importeProductos.toString(), productoAComprar.poduct_name, _importeComision);
                          print ('El valor de _confirmaretiro es: ' + _confirmaRetiro.toString());
                          if (_confirmaRetiro) {
                            print('He confirmado el retiro');
                            print('Justo antes de llamar a _showPleaseWait');
                            print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                            _showPleaseWait(true);
                            print('Justo después de llamar a _showPleaseWait');
                            print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                            print('Imprimo _productosComprados');
                            for (var i = 0; i< _productosComprados.length; i++) {
                              print ('El product_name es: ' + _productosComprados[i].poduct_name);
                            }
                            final http.Response res = await http.post("$SERVER_IP/savePurchasedProducts",
                                headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': jwt
                                },
                                body: jsonEncode(<String, dynamic>{
                                  'persone_id': payload['empleado_id'],
                                  'company_id': payload['company_id'],
                                  'period_id': payload['period_id'],
                                  'bank_account_id': payload['bank_account_id'],
                                  'payroll_day': payload['period_id'],
                                  'salario_acumulado': payload['salario_acumulado'],
                                  'max_permitido': _puedesRetirar,
                                  'extracted_amount': _importeTotal,
                                  'comission_amount': _importeComision,
                                  'acct_no': payload['acct_no'],
                                  'purchased_products': _productosComprados.map<Map<String, dynamic>>((e) {
                                    return {
                                      'product_id': e.product_id,
                                      'product_name': e.poduct_name,
                                      'image': e.image,
                                      'product_price': e.product_price,
                                      'comission': e.comission
                                    };
                                  } ).toList()
                                })
                            );
                            if (res.statusCode == 200) {
                              // He de variar la cantidad que puedes retirar de la pantalla
                              print('Justo antes de llamar por segunda vez _showPleaseWait');
                              print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                              _showPleaseWait(false);
                              print('Justo después de llamar a _showPleaseWait');
                              print('El valor de pleaseWait es: ' + _pleaseWait.toString());
                              print(res.body);  // Me retorna los productos que acabo de comprar
                              final parsed = json.decode(res.body)['data'].cast<Map<String, dynamic>>();    // parseo aquellos productos que acabo de comprar
                              final purchasedProducts = parsed.map<PurchasedProduct>((json) => PurchasedProduct.fomJson(json)).toList();  // los combierto en una lista de productos
                              //Me recorro la lista para meterlos en mi lista de productos comprados
                              for (var i = 0; i< purchasedProducts.length; i++) {
                                print(purchasedProducts[i].product_id.toString());
                                print(purchasedProducts[i].order_id.toString());
                                print(purchasedProducts[i].product_name);
                                print(purchasedProducts[i].product_description);
                                print(purchasedProducts[i].product_type.toString());
                                print(purchasedProducts[i].brand);
                                print(purchasedProducts[i].image);
                                print(purchasedProducts[i].avail.toString());
                                print(purchasedProducts[i].product_price.toString());
                                print(purchasedProducts[i].comission.toString());
                                print(purchasedProducts[i].remark);
                                print('Justo antes de hacer el new ProductComprado');
                                final producto = new ProductComprado(
                                    product_id: purchasedProducts[i].product_id,
                                    order_id: purchasedProducts[i].order_id,
                                    product_name: purchasedProducts[i].product_name,
                                    product_description: purchasedProducts[i].product_description,
                                    product_type: purchasedProducts[i].product_type,
                                    brand: purchasedProducts[i].brand,
                                    image: purchasedProducts[i].image,
                                    avail: int.parse(purchasedProducts[i].avail),
                                    product_price: int.parse(purchasedProducts[i].product_price),
                                    comission: int.parse(purchasedProducts[i].comission),
                                    remark: purchasedProducts[i].remark
                                );
                                print('He pasado el new ProductoComprado');
                                print(producto.product_id.toString());
                                print(producto.order_id);
                                print(producto.product_name);
                                print(producto.product_description);
                                print(producto.product_type);
                                print(producto.brand);
                                print(producto.image);
                                print(producto.avail.toString());
                                print(producto.product_price.toString());
                                print(producto.comission);
                                print(producto.remark);
                                //_productosCompradosRetornados.add(producto);
                                bloc.addToCart(producto);
                                print('Después de añadir a bloc');
                              }
                              //customListItemKey.currentState.setState(() {
                              //  customListItemKey.currentState._puedesRetirar = customListItemKey.currentState._puedesRetirar - _importeTotal;
                              //});
                              //customAmountPermitedDetray.currentState.setState(() {
                              //  customAmountPermitedDetray.currentState.amoutToDetray = customListItemKey.currentState._puedesRetirar - _importeTotal;
                              //});
                              print('Después de el http.post');
                              _puedesRetirar = _puedesRetirar - _importeTotal;
                              _importeTotal = 0;
                              _importeProductos = 0;
                              _importeComision = 0;
                              payload['max_permitido'] = _puedesRetirar;
                              var storage = FlutterSecureStorage();
                              storage.delete(key: "max_permitido");
                              print ('Antes de escribir el max_permitido. el valor es: ' + _puedesRetirar.toString());
                              storage.write(key: "max_permitido", value: _puedesRetirar.toString());
                              var max_permitido = await storage.read (key: "max_permitido");
                              print('Después de leer max_permitido. Su valor es: ' + max_permitido);
                              Navigator.pop(context);
                            } else if (res.statusCode == 404) {
                              _showPleaseWait(false);
                              print ('Me voy por el que el Token esta caducado');
                              // Como retorno que le token no es valido retorno a la página de Login
                              Navigator.pushReplacementNamed(context, '/login');
                            } else {
                              _showPleaseWait(false);
                              _showSnackBar(json.decode(res.body)['message'], error: false);
                            }
                          }
                        } else {
                          _showSnackBar('El importe comprado no puede ser mayor a la cantidad disponible', error: false);
                        }
                      } catch (e) {
                        _showPleaseWait(false);
                        _showSnackBar(e.toString(), error: false);
                        print('Error' + e.toString());
                      }
                    },
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          );
          Widget bodyWidget = _pleaseWait
              ? Stack(key: ObjectKey("stack"), children: [_pleaseWaitWidget, builder])
              : Stack(key: ObjectKey("stack"), children: [builder]);
          return bodyWidget;
        }
    );
  }
  //////////////////////////////////////////////////////////
  // Fin Función que construye la ventana
  //////////////////////////////////////////////////////////

  _showPleaseWait(bool b) {
    setState(() {
      _pleaseWait = b;
    });
  }
  Future<void> _displayDialog (BuildContext context, String title, String descripcionProducto, int cuota) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return SimpleDialog (
            titlePadding: EdgeInsets.zero,
            title: Container(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(0.0),
                    //width: 96.0,
                    //height: 96.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      color: Colors.white,
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
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      width: 96.0,
                      height: 96.0,
                      child: Image.asset(
                          'assets/titleDialogBox.png'
                        //'assets/Group8.png'
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0,),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Text(
                      'Estas por comprar ' + descripcionProducto + ' por:',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(int.parse(title)),
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    ],
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'El monto será retirado de tu próximo',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'pago de quincena',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  SizedBox(height: 40.0,),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(

              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: RaisedButton(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration (
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color (0xFFA007EB),
                            Color (0XFF567DF4),
                            Color (0xFF04FFFE)
                          ],
                        )
                    ),
                    //padding: const EdgeInsets.fromLTRB(145.0, 20.0, 145.0, 20.0),
                    child: const Text(
                        'Confirmar',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white
                        )
                    ),
                    height: 64,
                  ),
                  elevation: 8.0, // New
                  onPressed: () async {
                    setState(() {
                      _confirmaRetiro = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: GestureDetector(
                        child: Text (
                          'Cancelar',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onTap: (){
                          setState(() {
                            _confirmaRetiro = false;
                          });
                          Navigator.of(context).pop();
                        },
                      )
                  ),
                ],
              ),
              SizedBox(height: 24.0),
            ],
            elevation: 24.0,
          );
        }
    );
  }
  _showSnackBar(String content, {bool error = false}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text('${error ? "Ocurrió un error: " : ""}${content}'),
    ));
  }
  Future<int> _obtenerMaximoPermitido() async {
    var storage = FlutterSecureStorage();
    var max_permitido = await storage.read(key: "max_permitido");
    if (max_permitido == null) return 0;

    return int.parse(max_permitido);
  }
  @override
  void initState() {
    super.initState();
    _importeProductos = productoAComprar.product_price;
    _importeComision = productoAComprar.comission;
    _importeTotal = _importeProductos + _importeComision;
    _confirmaRetiro = false;
    _pleaseWait = false;
    _numUnidades = 1;
    _productosComprados.add(productoAComprar);
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    //print('El valor de puedes retirar es: ' + _puedesRetirar.toString());
    //_puedesRetirar = payload['max_permitido'];
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
        backgroundColor: colorCajasTexto,
        brightness: Brightness.light,
        title: Text(
            productoAComprar.poduct_name,
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
      ),
      body: FutureBuilder<int>(
        future: _obtenerMaximoPermitido(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _pleaseWaitWidget;
          } else {
              _puedesRetirar = snapshot.data;
            return pantalla(context, productoAComprar);
          }
        }
      ),
    );
  }
}