import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show NumberFormat hide TextDirection;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:provider/provider.dart';



import 'package:blupv1/consultarProdComprado.dart';
import 'package:blupv1/model/almacen.dart';
import 'package:blupv1/model/supraAlmacen.dart';
import 'package:blupv1/colors.dart';
import 'package:blupv1/utils/util.dart';
import 'package:blupv1/perfil.dart';
import 'package:blupv1/home.dart';
import 'package:blupv1/compraProducto.dart';
//import 'package:blupv1/model/CarroCompra.dart';
import 'package:blupv1/saldo.dart';
import 'package:blupv1/cambioPIN.dart';
import 'package:blupv1/cambioContraseña.dart';
import 'package:blupv1/bloc/cartProductsBloc.dart';
import 'package:blupv1/notificaciones.dart';

class Tienda extends StatefulWidget {
  Tienda(this.jwt, this.payload);
  factory Tienda.fromBase64(String jwt) =>
      Tienda(
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
  TiendaState createState() => TiendaState(this.jwt, this.payload);
}
class TiendaState extends State<Tienda> with SingleTickerProviderStateMixin {
  TiendaState(this.jwt, this.payload);
  final String jwt;
  final Map<String, dynamic> payload;

  final List<Tab> _myTabs = <Tab>[
    Tab(
      text: 'Prod. disponibles',
    ),
    Tab(text: 'Comprados'),
  ];
  TabController _tabController;
  final PleaseWaitWidget _pleaseWaitWidget =
  PleaseWaitWidget (key: ObjectKey("pleaseWaitWidget"));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _pleaseWait = false;
  Future<SupraAlmacen> supraAlmacen;
  //Almacen _productosComprados;
  //Almacen _almacen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('es_MX', null);
    _tabController = TabController(vsync: this, length: _myTabs.length);
    _pleaseWait = false;
    supraAlmacen = _obtenerItemsParaSupraAlmacen();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  _showSnackBar(String content, {bool error = false}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text('${error ? "Ocurrió un error: " : ""}${content}'),
    ));
  }


  Future<SupraAlmacen> _obtenerItemsParaSupraAlmacen () async {
    try {
      //_showPleaseWait(true);
      // Lo que me traigo son todos los productos tanto aquellos que estan disponibles para la tienda
      // como aquellos que ya fueron comprados por el usuario
      final String cadena = "$SERVER_IP/getAllProducts/" +
          payload['company_id'].toString() + "/" +
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
      print('Despues de la llamada al http');
      if (res.statusCode == 200) {
        // Todo ha ido bien
        //_showPleaseWait(false);
        print('Antes de imprimir el body');
        print(res.body);
        print('Despues de imprimir el body');
        //final almacen = new Almacen.fomJson(json.decode(res.body).cast<Map<String, dynamic>>());
        final supraAlmacen = new SupraAlmacen.fomJson(json.decode(res.body)['productosDisponibles'].cast<Map<String, dynamic>>(), json.decode(res.body)['productosComprados'].cast<Map<String, dynamic>>());
        print ('El almacen es (viene despues)');
        print (supraAlmacen.itemsProductosDisponibles);
        print (supraAlmacen.itemsProductosComprados);
        //print(supraAlmacen);
        // Introduzco los productos comprados en el alamacen
        bloc.removeAllFromCart();
        for (var i = 0; i< supraAlmacen.itemsProductosComprados.length; i++) {
          bloc.addToCart(supraAlmacen.itemsProductosComprados[i]);
        }
        // Fin de la introduccion
        print('Un paso más');
        print ('Antes de retornar');
        return supraAlmacen;
      } else if (res.statusCode == 404) {
        print ('Paso por el token caducado');
        //Navigator.pushNamed(context, '/login');
        Navigator.pushReplacementNamed(context, '/login');
        //throw Exception('Token caducado.');
      } else {
        throw Exception(res.statusCode.toString() + ": " + json.decode(res.body)['message'].toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }


  Widget _tabHistorial (BuildContext context, Tab tab, SupraAlmacen almacen) {
  //Widget _tabHistorial (BuildContext context, Tab tab) {
    final String label = tab.text.toLowerCase();

    //_showPleaseWait(false);
    print ('Estoy en _tabHistorial');

    return LayoutBuilder (
      builder: (context, constraints){
        double anchoImagen = constraints.maxWidth * 0.30;  // Constante que determino = 0,475
        print ('El ancho de la pantalla es: ' + constraints.maxWidth.toString());
        print ('El ancho de la imagen es: ' + anchoImagen.toString());
        //var carro = context.watch<CarroCompra>();

        // Implemento el Streambuilder que se conecta con el almacen que tiene los productos comprados

        // Fin de la implementacion de Streambuilder

        return StreamBuilder(
          initialData: bloc.allItems,
          stream: bloc.getStream,
          builder: (context, snapshot) {
            return snapshot.data['cartItems'].length > 0
            ? ListView.builder(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 24),
              itemCount: snapshot.data['cartItems'].length,
              //itemCount: almacen.itemsProductosComprados.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  borderOnForeground: true,
                  clipBehavior: Clip.antiAlias,
                  color: colorFondo,
                  elevation: 1,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 15.0, right: 16.0, top: 20.0, bottom: 20.0),
                            alignment: Alignment.center,
                            width: anchoImagen.toDouble(),
                            //height: 120.0,
                            child: AspectRatio(
                                aspectRatio: 3.0 / 2.0,
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  //imageUrl: SERVER_IP + '/image/products/' + almacen.itemsProductosComprados[index].image,
                                  imageUrl: SERVER_IP + '/image/products/' + snapshot.data['cartItems'][index].image,
                                )
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                //almacen.itemsProductosComprados[index].product_name,
                                snapshot.data['cartItems'][index].product_name,
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16,
                                  color: Color(0xFF303034),
                                ),
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                //'Código digital',
                                //almacen.itemsProductosComprados[index].product_type,
                                snapshot.data['cartItems'][index].product_type,
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  color: Color(0xFF36B0F8),
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                //'Cinemex',
                                //almacen.itemsProductosComprados[index].brand,
                                snapshot.data['cartItems'][index].brand,
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  color: Color(0xFF6C6D77),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                            child: FlatButton(
                                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    //builder: (context) => ConsultarProdComprado(jwt, payload, almacen.itemsProductosComprados[index]),     // 0 porque lo llamo desde la tab de saldo actual
                                    builder: (context) => ConsultarProdComprado(jwt, payload, snapshot.data['cartItems'][index]),     // 0 porque lo llamo desde la tab de saldo actual
                                  ));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(2.0),
                                  decoration: BoxDecoration (
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(4.0),
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Color (0xFFA007EB),
                                          Color (0XFF567DF4),
                                          Color (0xFF04FFFE)
                                        ],
                                      )
                                  ),
                                  child: Container(
                                    //padding: EdgeInsets.all(3.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: colorFondo,
                                      //border: Border.all(color: Color(0xFF303034), width: 2.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                      child: Text (
                                        'Consultar',
                                        style: TextStyle (
                                          fontFamily: 'SF Pro Display',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF303034),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    //height: 38,
                                  ),
                                  height: 40,
                                )
                            ),
                          )

                        ],
                      ),
                    ],
                  ),
                );
              },
            )
            : Container(
              decoration: BoxDecoration(
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Image.asset('assets/detalleSaldoFactura.png'),
                      SizedBox(height: 40),
                      Text(
                        'Aún no tiene productos comprados',
                        style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w700,
                            fontSize: 24
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox (height: 16,),
                      Text(
                        'Aquí podrás ver los productos comprados',
                        style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            fontStyle: FontStyle.italic
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'del período de su nómina actual ',
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
            );
          }
        );
      },
    );
    //Widget bodyWidget = _pleaseWait
    //    ? Stack(key: ObjectKey("stack"), children: [myBuilder, _pleaseWaitWidget])
    //    : Stack(key: ObjectKey("stack"), children: [myBuilder]);
    //return bodyWidget;
  }

  Widget _tabProdDisponibles (BuildContext context, Tab tab, SupraAlmacen almacen) {
    final String label = tab.text.toLowerCase();
    print('Estoy en la tienda.');
    print('El valor del máximo que puedes retirar es: ' + payload['max_permitido'].toString());
    return LayoutBuilder(
      builder: (context, constraints){
        print ('El ancho de la pantalla es: ' + constraints.maxWidth.toString());
        double anchoImagen = constraints.maxWidth * 0.475;  // Constante que determino = 0,475
        print ('El ancho de la foto es: ' + anchoImagen.toString());
        return Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: GridView.builder(
              itemCount: almacen.itemsProductosDisponibles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 200.0/303.0,
              ),
              itemBuilder: (BuildContext context, int index){
                return Card(
                  clipBehavior: Clip.antiAlias,
                  color: colorFondo,
                  elevation: 1,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                            alignment: Alignment.center,
                            width: anchoImagen.toDouble(),
                            //height: 120.0,
                            child: AspectRatio(
                                aspectRatio: 3.0 / 2.0,
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  imageUrl: SERVER_IP + '/image/products/' + almacen.itemsProductosDisponibles[index].image,
                                )
                            ),
                          )
                        ],
                      ),
                      //SizedBox(height: 12,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Image.asset('assets/tiendaBolsaCaudal.png'),
                              padding: EdgeInsets.only(right: 8.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Text(
                                new NumberFormat.currency(locale:'en_US', symbol: '\$', decimalDigits:0).format(int.parse(almacen.itemsProductosDisponibles[index].product_price.toString())),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24.0,
                                    fontFamily: 'SF Pro Display',
                                ),
                                textAlign: TextAlign.start
                              ),
                            ),
                            Text(
                                almacen.itemsProductosDisponibles[index].poduct_description,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
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
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                                almacen.itemsProductosDisponibles[index].poduct_name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
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
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                                almacen.itemsProductosDisponibles[index].product_type,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0,
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
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                                almacen.itemsProductosDisponibles[index].brand,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0,
                                  fontFamily: 'SF Pro Display',
                                  fontStyle: FontStyle.normal,
                                  color: Color(0xFF6C6D77),
                                ),
                                textAlign: TextAlign.start
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 14.0),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: FlatButton(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          onPressed: () {
                            Navigator.push (context, MaterialPageRoute (
                              builder: (context) => CompraProducto(jwt, payload, almacen.itemsProductosDisponibles[index]),     // 0 porque lo llamo desde la tab de saldo actual
                            ));
                            //List <ProductComprado> _productosRealmenteComprados = [];
                            //print('Retorno de la pantalla de Compra');
                            //print('================================');
                            //print(productosRealmenteComprados);
                            //final productosRealmenteComprados =
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration (
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(4.0),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color (0xFFA007EB),
                                    Color (0XFF567DF4),
                                    Color (0xFF04FFFE)
                                  ],
                                )
                            ),
                            child: Container(
                              //padding: EdgeInsets.all(3.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(4.0),
                                color: colorFondo,
                              ),
                              child: Text (
                                'Comprar',
                                style: TextStyle (
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              //height: 38,
                            ),
                            height: 40,
                          )
                        ),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                );
              }
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    //_almacen = _obtenerItemsParaAlmacen();
    return Scaffold (
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 48),
              child: Container(
                alignment: Alignment.center,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                    ),
                    BoxShadow(
                        color: colorCajasTexto,
                        spreadRadius: -2.0,
                        blurRadius: 3
                    )
                  ],
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            )
          ],
        ),
        leading: Builder(
            builder: (BuildContext context){
              return Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left: 32.0),
                child: IconButton(
                  padding: EdgeInsets.all(0.0),
                  color: Colors.black,
                  icon: Image.asset('assets/menuAppBar.png'),
                  onPressed: () { Scaffold.of(context).openDrawer(); },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              );
            }
        ),
        backgroundColor: colorCajasTexto,
        brightness: Brightness.light,
//        textTheme: ,
        title: Image.asset ('assets/KlincLogoAppBar.png'),
        bottom: TabBar(
          tabs: _myTabs,
          controller: _tabController,
          indicatorWeight: 2.0,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(0),
          indicatorColor: Color(0xFF8E23EF),
          labelStyle: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(right: 32.0),
            child: IconButton(
              padding: EdgeInsets.all(0.0),
              icon: Image.asset('assets/campanaAppBar.png'),
              color: Colors.black,
              onPressed: () {
                print('Filter button');
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Notificaciones(jwt, payload), // 1 porque lo llamo desde la tab de histórico
                ));
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder <SupraAlmacen>(
          future: supraAlmacen,
          //future: _jwtOrEmpty(),
          builder: (context, snapshot){
            try {
              if (snapshot.hasData) {
                return new TabBarView(
                    controller: _tabController,
                    children: [
                      _tabProdDisponibles(context, _myTabs[0], snapshot.data),
                      _tabHistorial(context, _myTabs[1], snapshot.data)
                    ]
                );
              } else if (snapshot.hasError) {
                print('Hay un error. El error es: ' + "${snapshot.error}");
                Navigator.pushReplacementNamed(context, '/login');
              } else {
                return _pleaseWaitWidget;
              }
            } catch (e){
              _showSnackBar(snapshot.error.toString(), error: false);
              Navigator.pushReplacementNamed(context, '/login');
            }
          }
      ),
      drawer: Drawer(
        child: LayoutBuilder(
            builder: (context, constraints) {
              const int constanteAltoPantalla = 540;  // Siempre determino esta altura que hay que eliminar del menu para que la opcion quede a la altura adecuada
              print ('El alto de la pantalla es: ' + constraints.minHeight.toString());
              double posicionOpcionCerrarSesion = constraints.minHeight - (constanteAltoPantalla) - 72; //El ancho de cada opción del menú es de 72 puntos. 540
              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 103.0,
                    child:DrawerHeader(
                        margin: EdgeInsets.all(0.0),
                        padding: EdgeInsets.only(bottom: 10),
                        child: Container(
                          //padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                          //height: 48.0,
                          child: Image.asset('assets/KlinkLogoDrawMenu.png'),
                        )
                    ),
                  ),
                  Container(
                    alignment: Alignment(0.0, 0.0),
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xFFD8D8D8))
                      ),
                    ),
                    child: ListTile(
                        leading: Image.asset('assets/perfilNombreUsuario.png'),
                        title: Text(
                          'Perfil',
                          style: TextStyle(
                              fontFamily: 'Helvetica Neue',
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal
                          ),
                        ),
                        onTap: () {
                          Navigator.pushReplacement (
                              context,
                              MaterialPageRoute(
                                builder: (context) => Perfil(jwt, payload),
                              )
                          );
                        }
                    ),
                  ),
                  Container(
                    alignment: Alignment(0.0, 0.0),
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xFFD8D8D8))
                      ),
                    ),
                    child: ListTile(
                        leading: Image.asset('assets/candadoDrawer.png'),
                        title: Text(
                          'Cambio contraseña',
                          style: TextStyle(
                              fontFamily: 'Helvetica Neue',
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal
                          ),
                        ),
                        onTap: () {
                          Navigator.push (
                              context,
                              MaterialPageRoute(
                                builder: (context) => CambioContrasenya(payload['email']),
                              )
                          );
                        }
                    ),
                  ),
                  Container(
                    alignment: Alignment(0.0, 0.0),
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xFFD8D8D8))
                      ),
                    ),
                    child: ListTile(
                        leading: Image.asset('assets/candadoDrawer.png'),
                        title: Text(
                          'Cambio PIN',
                          style: TextStyle(
                              fontFamily: 'Helvetica Neue',
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal
                          ),
                        ),
                        onTap: () {
                          Navigator.push (
                              context,
                              MaterialPageRoute(
                                builder: (context) => CambioPin(payload['email']),
                              )
                          );
                        }
                    ),
                  ),
                  Container(
                    alignment: Alignment(0.0, 0.0),
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xFFD8D8D8))
                      ),
                    ),
                    child: ListTile(
                      leading: Image.asset('assets/soporteDrawer.png'),
                      title: Text(
                        'Soporte',
                        style: TextStyle(
                            fontFamily: 'Helvetica Neue',
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                  //ListTile(
                  //  leading: Image.asset('assets/ganaRetirosDrawer.png'),
                  //  title: Text(
                  //    'Gana Retiros',
                  //    style: TextStyle(
                  //        fontFamily: 'Helvetica Neue',
                  //        fontSize: 16,
                  //        fontStyle: FontStyle.normal,
                  //        fontWeight: FontWeight.normal
                  //    ),
                  //  ),
                  //  shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
                  //),
                  Container (
                    alignment: Alignment(0.0, 0.0),
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xFFD8D8D8))
                      ),
                    ),
                    child: ListTile(
                      leading: Image.asset('assets/preguntasFreqDrawer.png'),
                      title: Text(
                        'Preguntas frecuentes',
                        style: TextStyle(
                            fontFamily: 'Helvetica Neue',
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                  Container (
                    alignment: Alignment(0.0, 0.0),
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xFFD8D8D8))
                      ),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/terminosYCondiDrawer.png',
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        'Términos y condiciones',
                        style: TextStyle(
                            fontFamily: 'Helvetica Neue',
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: posicionOpcionCerrarSesion,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 72.0,
                        alignment: Alignment(0.0, 0.0),
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Color(0xFFD8D8D8))
                          ),
                        ),
                        child: ListTile(
                          //leading: Image.asset('assets/terminosYCondiDrawer.png'),
                            contentPadding: EdgeInsets.fromLTRB(80.0, 0, 0, 0),
                            title: Text(
                              'Cerrar sesión',
                              style: TextStyle(
                                fontFamily: 'Helvetica Neue',
                                fontSize: 16.0,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE81D5E),
                              ),
                            ),
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            }
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
        ),
      ),
      bottomNavigationBar: _BottonNavigationBar(jwt: jwt, payload: payload),
    );
  }
}
class _BottonNavigationBar extends StatefulWidget {
  final String jwt;
  final Map<String, dynamic> payload;
  _BottonNavigationBar({this.jwt, this.payload});

  @override
  _BottonNavigationBarState createState() {
    return _BottonNavigationBarState(this.jwt, this.payload);
  }
}
class _BottonNavigationBarState extends State<_BottonNavigationBar>{
  final String jwt;
  final Map<String, dynamic> payload;
  @override
  _BottonNavigationBarState(this.jwt, this.payload);
  Widget _iconRetiroOn = Image.asset('assets/retiroOnBottonNavBar.png');
  Widget _iconRetiroOff = Image.asset('assets/retiroOffBottonNavBar.png');
  Widget _iconTiendaOn = Image.asset('assets/tiendaOnBottonNavBar.png');
  Widget _iconTiendaOff = Image.asset('assets/tiendaOffBottonNavBar.png');
  Widget _iconSaldoOn = Image.asset('assets/saldoOnBottonNavBar.png');
  Widget _iconSaldoOff = Image.asset('assets/saldoOffBottonNavBar.png');
  Widget _iconPerfilOn = Image.asset('assets/perfilOnBottonNavBar.png');
  Widget _iconPerfilOff = Image.asset('assets/perfilOffBottonNavBar.png');
  Widget _iconRetiro;
  Widget _iconTienda;
  Widget _iconSaldo;
  Widget _iconPerfil;
  Color _textRetiroOn = Color(0xFF4895F6);
  Color _textRetiroOff = Color(0xFFADB0C7);
  Color _textTiendaOn = Color(0xFF4895F6);
  Color _textTiendaOff = Color(0xFFADB0C7);
  Color _textSaldoOn = Color(0xFF4895F6);
  Color _textSaldoOff = Color(0xFFADB0C7);
  Color _textPerfilOn = Color(0xFF4895F6);
  Color _textPerfilOff = Color(0xFFADB0C7);
  Color _textRetiro = Color(0xFF4895F6);
  Color _textTienda = Color(0xFFADB0C7);
  Color _textSaldo = Color(0xFFADB0C7);
  Color _textPerfil = Color(0xFFADB0C7);
  FontWeight _fontOn = FontWeight.bold;
  FontWeight _fontOff = FontWeight.normal;
  FontWeight _fontWeightRetiro;
  FontWeight _fontWeightTienda;
  FontWeight _fontWeightSaldo;
  FontWeight _fontWeightPerfil;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _iconRetiro = _iconRetiroOff;
    _textRetiro = _textRetiroOff;
    _fontWeightRetiro = _fontOff;
    _iconTienda = _iconTiendaOn;
    _textTienda = _textTiendaOn;
    _fontWeightTienda = _fontOn;
    _iconSaldo = _iconSaldoOff;
    _textSaldo = _textSaldoOff;
    _fontWeightSaldo = _fontOn;
    _iconPerfil = _iconPerfilOff;
    _textPerfil = _textPerfilOff;
    _fontWeightPerfil = _fontOff;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
          height: 70,
          padding: EdgeInsets.only(top: 2, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton (
                    icon: _iconRetiro,
                    onPressed: () {
                      setState(() {
                        _iconRetiro = _iconRetiroOn;
                        _textRetiro = _textRetiroOn;
                        _fontWeightRetiro = _fontOn;
                        _iconTienda = _iconTiendaOff;
                        _textTienda = _textTiendaOff;
                        _fontWeightTienda = _fontOff;
                        _iconSaldo = _iconSaldoOff;
                        _textSaldo = _textSaldoOff;
                        _fontWeightSaldo = _fontOff;
                        _iconPerfil = _iconPerfilOff;
                        _textPerfil = _textPerfilOff;
                        _fontWeightPerfil = _fontOff;

                        print ('Paso por el click de Retiro');
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => HomePage(jwt, payload),
                        ));
                      });
                    },
                    padding: EdgeInsets.all(0.0),
                    constraints: BoxConstraints(maxWidth: 24.0, maxHeight: 24.0),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 2.0),
                  Text(
                      'Retiro',
                      style: TextStyle(
                        color: _textRetiro,
                        fontFamily: 'Helvetica Neue',
                        fontWeight: _fontWeightRetiro,
                        fontSize: 16,
                      )
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton (
                    icon: _iconTienda,
                    onPressed: () {
                    },
                    padding: EdgeInsets.all(0.0),
                    constraints: BoxConstraints(maxWidth: 29.0, maxHeight: 24.0),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 2.0),
                  Text(
                      'Tienda',
                      style: TextStyle(
                        color: _textTienda,
                        fontFamily: 'Helvetica Neue',
                        fontWeight: _fontWeightTienda,
                        fontSize: 16,
                      )
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton (
                    icon: _iconSaldo,
                    onPressed: (){
                      setState(() {
                        _iconRetiro = _iconRetiroOff;
                        _textRetiro = _textRetiroOff;
                        _fontWeightRetiro = _fontOff;
                        _iconTienda = _iconTiendaOff;
                        _textTienda = _textTiendaOff;
                        _fontWeightTienda = _fontOff;
                        _iconSaldo = _iconSaldoOn;
                        _textSaldo = _textSaldoOn;
                        _fontWeightSaldo = _fontOn;
                        _iconPerfil = _iconPerfilOff;
                        _textPerfil = _textPerfilOff;
                        _fontWeightPerfil = _fontOff;
                      });
                      print ('Paso por el click de Saldo');
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Saldo(jwt, payload),
                      ));
                    },
                    padding: EdgeInsets.all(0.0),
                    constraints: BoxConstraints(maxWidth: 24.0, maxHeight: 20.0),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 2.0),
                  Text(
                      'Saldo',
                      style: TextStyle(
                        color: _textSaldo,
                        fontFamily: 'Helvetica Neue',
                        fontWeight: _fontWeightTienda,
                        fontSize: 16,
                      )
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton (
                    icon: _iconPerfil,
                    onPressed: (){
                      setState(() {
                        _iconRetiro = _iconRetiroOff;
                        _textRetiro = _textRetiroOff;
                        _fontWeightRetiro = _fontOff;
                        _iconTienda = _iconTiendaOff;
                        _textTienda = _textTiendaOff;
                        _fontWeightTienda = _fontOff;
                        _iconSaldo = _iconSaldoOff;
                        _textSaldo = _textSaldoOff;
                        _fontWeightSaldo = _fontOff;
                        _iconPerfil = _iconPerfilOn;
                        _textPerfil = _textPerfilOn;
                        _fontWeightPerfil = _fontOn;
                      });
                      print ('Paso por el click de Perfil');
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Perfil(jwt, payload),
                      ));
                    },
                    padding: EdgeInsets.only(bottom: 0.0),
                    constraints: BoxConstraints(maxWidth: 22.0, maxHeight: 22.0),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 2.0),
                  Text(
                      'Perfil',
                      style: TextStyle(
                        color: _textPerfil,
                        fontFamily: 'Helvetica Neue',
                        fontWeight: _fontWeightPerfil,
                        fontSize: 16,
                      )
                  ),
                ],
              )
            ],
          )
      ),
    );
  }
}
