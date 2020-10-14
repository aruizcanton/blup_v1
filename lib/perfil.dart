import 'package:blupv1/saldo.dart';
import 'package:blupv1/tienda.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:blupv1/colors.dart';
import 'package:blupv1/home.dart';
import 'package:blupv1/cambioContraseña.dart';
import 'package:blupv1/cambioPIN.dart';

class Perfil extends StatefulWidget {
  Perfil(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;
  @override
  PerfilState createState() => PerfilState(this.jwt, this.payload);
}
class PerfilState extends State {
  PerfilState(this.jwt, this.payload);
  final String jwt;
  final Map<String, dynamic> payload;

  // Vars
  bool _salaryNoVisible;
  bool _cuentaNoVisible;
  String _salary;
  String _cuenta;
  int _length;

  initState(){
    _salaryNoVisible = true;
    _cuentaNoVisible = true;
    _salary = '\$******';
    _length = payload['acct_no'].toString().length;
    _cuenta = '**** **** **** **' + payload['acct_no'].toString().substring(_length - 4);
    //_cuenta = '**** **** **** **** ****';
  }
  String _DateTimeFormatted() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formatted = formatter.format(now);
    return (formatted); // something like 2013-04-20
  }
  _BodyWidgets(BuildContext context){
    return new ListView(
      padding: EdgeInsets.only(left: 15, right: 15.0, top: 24),
      children: <Widget>[
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 18,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                  colors: <Color>[
                    Color (0xFFA007EB),
                    ////Color (0XFF567DF4),
                    ////Color (0xFF04FFFE)
                    //Color (0xFFAD87EF),
                    //Color (0xFF7D3EEF),
                    //Color (0xFF5F6FF3),
                    //Color (0xFF3FA2F7),
                    //Color (0xFF13E9FC),
                    //Color (0xFF08F8FD)


                    Color (0xFFA007EB),
                    //Color (0XFF567DF4),
                    //Color (0xFF04FFFE)


                    //Color (0xFFAD87EF),
                    Color (0xFF7D3EEF),
                    Color (0xFF5F6FF3),
                    Color (0xFF3FA2F7),
                    Color (0xFF13E9FC),
                    Color (0xFF08F8FD)


                  ]
              )
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 16, 0),
                    child: CircleAvatar(
                      radius: 36.0,
                      //backgroundColor: Color(0xFF23DBD9),
                      //foregroundColor: Color(0xFF3754AA),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          //borderRadius: BorderRadius.circular(36.0),
                          gradient: LinearGradient(
                              colors: <Color>[
                                //Color (0xFFA007EB),
                                //Color (0XFF567DF4),
                                //Color (0xFF04FFFE)

                                //Color (0xFFA007EB),
                                //Color (0xFF7D3EEF),
                                //Color (0xFF5F6FF3),
                                //Color (0xFF3FA2F7),
                                //Color (0xFF13E9FC),
                                //Color (0xFF08F8FD)
                                Color (0xFF5900d9),
                                Color (0xFF5901DA),
                                Color (0xFF430ADF),
                                Color (0xFF0F64EE),
                                Color (0xFF03ADF5),
                                Color (0xFF01D0F9)

                              ]
                          )
                        ),
                        child: Container(
                          width: 72,
                          height: 72,
                          child: Center(
                            child: Text(
                              payload['user_firstname'].toString().substring(0, 1),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 32.0,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        payload['user_firstname'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0,
                          color: Colors.white,
                          fontFamily: 'SF Pro Display'
                        ),
                      ),
                      Text(
                        payload['user_lastname'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32.0,
                            color: Colors.white,
                            fontFamily: 'SF Pro Display'
                        ),
                      ),
                      Text(
                        _DateTimeFormatted(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                          color: Colors.white,
                          fontFamily: 'SF Pro Display'
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 24.0),
        Padding (
          padding: EdgeInsets.only(left: 5),
          child: Text (
            'Datos personales',
            style: const TextStyle (
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: Colors.black,
              fontFamily: 'SF Pro Display'
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Card(
          clipBehavior: Clip.antiAlias,
          color: colorFondo,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Image.asset('assets/perfilNombreUsuario.png'),
                        color: Color(0xFFADB0C7),
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Text(
                        payload['persone_name'].toString(),
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Helvetica Neue',
                          color: Color(0xFF303034),
                        ),
                      )
                    )
                  ],
                ),
              ),
              const Divider(
                color: Color(0xFFD8D9E3),
                //height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Image.asset('assets/perfilCorreo.png'),
                          color: Color(0xFFADB0C7),
                          padding: EdgeInsets.only(right: 16.0),
                        )
                    ),
                    Expanded(
                        flex: 8,
                        child: Text(
                          payload['email'].toString(),
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Helvetica Neue',
                            color: Color(0xFF303034),
                          ),
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40.0),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            'Datos de la nómina',
            style: const TextStyle (
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Colors.black,
                fontFamily: 'SF Pro Display'
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Card(
          clipBehavior: Clip.antiAlias,
          color: colorFondo,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Image.asset('assets/perfilNombreEmpresa.png'),
                        color: Color(0xFFADB0C7),
                        padding: EdgeInsets.only(right: 16.0),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Text(
                        payload['empresa'].toString(),
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Helvetica Neue',
                          color: Color(0xFF303034),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                color: Color(0xFFD8D9E3),
                //height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 0.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/perfilEsquemaPago.png'),
                      color: Color(0xFFADB0C7),
                      padding: EdgeInsets.only(right: 16.0),
                    ),
                    Text(
                      'Esquema de pago',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Helvetica Neue',
                        color: Color(0xFF303034),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        payload['salary_scheme'],
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Helvetica Neue',
                          color: Color(0xFF303034),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                color: Color(0xFFD8D9E3),
                //height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 0.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/perfilSueldoMensual.png'),
                      color: Color(0xFFADB0C7),
                      padding: EdgeInsets.only(right: 16.0),
                    ),
                    Text(
                      'Sueldo mensual',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Helvetica Neue',
                        color: Color(0xFF303034),
                      ),
                    ),
                    Expanded(
                        flex:1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _salary,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Helvetica Neue',
                              color: Color(0xFF303034),
                            ),
                          ),
                        )
                    ),
                    _VerticalDivider(),
                    IconButton(
                        icon: Icon(_salaryNoVisible ? Icons.visibility_off : Icons.visibility),
                        color: Color(0xFFADB0C7),
                        onPressed: () {
                          setState(() {
                            _salaryNoVisible = ! _salaryNoVisible;
                            _salaryNoVisible ? _salary = '\$******' : _salary = new NumberFormat.currency(locale:'en_US', symbol: '\$ ', decimalDigits:0).format(int.parse(payload['salary']));
                          });
                        }
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40.0),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            'Datos bancarios',
            style: const TextStyle (
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Colors.black,
                fontFamily: 'SF Pro Display'
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Card(
          clipBehavior: Clip.antiAlias,
          color: colorFondo,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 0.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/perfilBanco.png'),
                      color: Color(0xFFADB0C7),
                      padding: EdgeInsets.only(right: 16.0),
                    ),
                    Text(
                      'Banco',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Helvetica Neue',
                        color: Color(0xFF303034),
                      ),
                    ),
                    Expanded(
                        flex:1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            payload['bank'],
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Helvetica Neue',
                              color: Color(0xFF303034),
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ),
              const Divider(
                color: Color(0xFFD8D9E3),
                //height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 0.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/perfilCuenta.png'),
                      color: Color(0xFFADB0C7),
                      padding: EdgeInsets.only(right: 16.0),
                    ),
                    Text(
                      'Cuenta',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Helvetica Neue',
                        color: Color(0xFF303034),
                      ),
                    ),
                    Expanded(
                        flex:2,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _cuenta,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Helvetica Neue',
                              color: Color(0xFF303034),
                            ),
                          ),
                        )
                    ),
                    _VerticalDivider(),
                    IconButton(
                        icon: Icon(_cuentaNoVisible ? Icons.visibility_off : Icons.visibility),
                        color: Color(0xFFADB0C7),
                        onPressed: () {
                          setState(() {
                            _cuentaNoVisible = ! _cuentaNoVisible;
                            _length = payload['acct_no'].toString().length;
                            //_cuentaNoVisible ? _cuenta = '**** **** **** ****' : _cuenta = payload['acct_no'].toString();
                            _cuentaNoVisible ? _cuenta = '**** **** **** **' + payload['acct_no'].toString().substring(_length - 4) : _cuenta = payload['acct_no'].toString();
                          });
                        }
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.0),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            '¿Algún dato no es correcto?',
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                fontFamily: 'SF Pro Display',
                color: Color(0xFF303034),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            'Contacta con recursos humanos de tu empresa o ecríbenos a soporte@klinc.mx',
            style: const TextStyle(
              fontWeight: FontWeight.w100,
              fontSize: 16.0,
              color: Color(0xFF303034),
              fontFamily: 'Helvetiva neue'
            ),
          ),
        ),
        SizedBox(height: 40.0),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
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
        title: Image.asset('assets/KlincLogoAppBar.png'),
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
              },
            ),
          ),
        ],
      ),
      body: _BodyWidgets(context),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 80.0,
              child:DrawerHeader(
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(0.0),
                  child: Container(
                    //padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                    //height: 48.0,
                    child: Image.asset('assets/KlinkLogoDrawMenu.png'),
                  )
              ),
            ),
            ListTile(
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
                shape: Border(bottom: BorderSide(color: Color(0xFFD8D9E3))),
                onTap: () {
                  Navigator.pushReplacement (
                      context,
                      MaterialPageRoute(
                        builder: (context) => Perfil(jwt, payload),
                      )
                  );
                }
            ),
            ListTile(
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
                shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
                onTap: () {
                  Navigator.push (
                      context,
                      MaterialPageRoute(
                        builder: (context) => CambioContrasenya(payload['email']),
                      )
                  );
                }
            ),
            ListTile(
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
                shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
                onTap: () {
                  Navigator.push (
                      context,
                      MaterialPageRoute(
                        builder: (context) => CambioPin(payload['email']),
                      )
                  );
                }
            ),
            ListTile(
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
              shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
            ),
            // ListTile(
            //   leading: Image.asset('assets/ganaRetirosDrawer.png'),
            //   title: Text(
            //     'Gana Retiros',
            //     style: TextStyle(
            //         fontFamily: 'Helvetica Neue',
            //         fontSize: 16,
            //         fontStyle: FontStyle.normal,
            //         fontWeight: FontWeight.normal
            //     ),
            //   ),
            //   shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
            // ),
            ListTile(
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
              shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
            ),
            ListTile(
              leading: Image.asset('assets/terminosYCondiDrawer.png'),
              title: Text(
                'Términos y condiciones',
                style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal
                ),
              ),
              shape: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFD8D9E3))),
            )
          ],
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
    _iconTienda = _iconTiendaOff;
    _textTienda = _textTiendaOff;
    _fontWeightTienda = _fontOff;
    _iconSaldo = _iconSaldoOff;
    _textSaldo = _textSaldoOff;
    _fontWeightSaldo = _fontOff;
    _iconPerfil = _iconPerfilOn;
    _textPerfil = _textPerfilOn;
    _fontWeightPerfil = _fontOn;
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
                      });
                      print ('Paso por el click de Retiro');
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => HomePage(jwt, payload),
                      ));
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
                      setState(() {
                        _iconRetiro = _iconRetiroOff;
                        _textRetiro = _textRetiroOff;
                        _fontWeightRetiro = _fontOff;
                        _iconTienda = _iconTiendaOn;
                        _textTienda = _textTiendaOn;
                        _fontWeightTienda = _fontOn;
                        _iconSaldo = _iconSaldoOff;
                        _textSaldo = _textSaldoOff;
                        _fontWeightSaldo = _fontOff;
                        _iconPerfil = _iconPerfilOff;
                        _textPerfil = _textPerfilOff;
                        _fontWeightPerfil = _fontOff;
                        print('Paso por el Click de Tienda');
                      });
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Tienda(jwt, payload),
                      ));
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
                      print ('Paso por el click de Perfil');
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
class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 15.0,
      width: 1.0,
      color: Colors.black,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}