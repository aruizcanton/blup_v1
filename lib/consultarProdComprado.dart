import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';


import 'package:blupv1/colors.dart';
import 'package:blupv1/model/productComprado.dart';
import 'package:blupv1/utils/util.dart';


class ConsultarProdComprado extends StatelessWidget {
  ConsultarProdComprado(this.jwt, this.payload, this.productoComprado);

  final String jwt;
  final Map<String, dynamic> payload;
  final ProductComprado productoComprado;

  Widget pantalla (BuildContext context, ProductComprado productoComprado) {
    return LayoutBuilder(
        builder: (context, constraints){
          print ('Comienzo la consultaProdComprado ...');
          print ('El ancho de la pantalla es: ' + constraints.maxWidth.toString());
          double anchoImagen = constraints.maxWidth * 0.998;  // Constante que determino = 0,475
          print ('El ancho de la foto es: ' + anchoImagen.toString());
          return SafeArea(
            child: ListView(
              children: [
                SizedBox(height: 36.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
                        alignment: Alignment.center,
                        width: anchoImagen,
                        child: AspectRatio(
                          aspectRatio: 3.0 / 2.0,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => CircularProgressIndicator(),
                            imageUrl: SERVER_IP + '/image/products/' + productoComprado.image,
                            //imageUrl: SERVER_IP + '/image/products/cinemex_compra.png',
                            //imageUrl: SERVER_IP + '/image/products/cinemex.png',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.0),
                          Text(
                            productoComprado.product_name,
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                              color: Color(0xFF303034),
                            ),
                          ),
                          SizedBox(height: 24.0),
                          Text(
                            productoComprado.product_type,
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w300,
                              fontSize: 16.0,
                              color: Color(0xFF36B0F8),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            productoComprado.brand,
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w300,
                              fontSize: 16.0,
                              color: Color(0xFF6C6D77),
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
                SizedBox(height: 48.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color: colorFondo, style: BorderStyle.solid, width: 0.0),
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
                    borderOnForeground: true,
                    clipBehavior: Clip.antiAlias,
                    color: colorFondo,
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.0),
                        Center(
                          child: QrImage(
                            data: productoComprado.order_id,
                            version: QrVersions.auto,
                            size: 224,
                            gapless: false,

                          ),
                        ),
                        SizedBox(height: 25.0),
                        Center(
                          child: Text(
                            'Folio: ' + productoComprado.order_id,
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 17.0, right: 17.0),
                          child: Center(
                            child: Text(
                              productoComprado.remark,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0,
                                fontFamily: 'SF Pro Display',
                                fontStyle: FontStyle.normal,
                                color: Color(0xFF6C6D77),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                      ],
                    ),
                  ),
                )
              ],
            )
          );
        }
    );
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
          productoComprado.product_name,
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: pantalla(context, productoComprado),
    );
  }
}