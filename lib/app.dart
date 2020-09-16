// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'home.dart';
import 'login.dart';
import 'registry.dart';
import 'validateRegistry.dart';
import 'reset.dart';
import 'validateResetPass.dart';
import 'colors.dart';
import 'utils/util.dart';

final storage = FlutterSecureStorage();

class BlupApp extends StatelessWidget {

  Future<String> _jwtOrEmpty() async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "No existe Token";
    return jwt;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blup',
      // TODO: Change home: to a Backdrop with a HomePage frontLayer (104)
      home: FutureBuilder (
          future: _jwtOrEmpty(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return PleaseWaitWidget();
            } else {
              if (snapshot.data != "No existe Token") {
                var jwt = snapshot.data;
                var  str = jwt.split(".");
                if (str.length != 3) {
                  return LoginPage();
                } else {
                  var payload = json.decode(utf8.decode(base64.decode(base64.normalize(str[1]))));
                  print("Antes de imprimir el payload");
                  print(payload);
                  if (DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                    print("El token es válido aun");
                    //return HomePage.fromBase64(jwt);
                    return LoginPage();
                  } else {
                    return LoginPage();
                  }
                }
              } else {
                return LoginPage();
              }
            }
          }
      ),
      //initialRoute: '/login',
      //initialRoute: '/login',
      onGenerateRoute: _getRoute,
      // TODO: Add a theme (103)
      theme: _blupTheme, // New code
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
//    if (settings.name != '/login') {
//      return null;
//    }
    if (settings.name == '/login') {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => LoginPage(),
        fullscreenDialog: true,
      );
    } else if (settings.name == 'login/registry') {
      final ScreenArguments args = settings.arguments;
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => RegistryPage(args.user_name),
        fullscreenDialog: true,
      );
    } else if (settings.name == 'login/registry/validate'){
      final ScreenArguments args = settings.arguments;
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => validateRegistryPage(args.user_name),
        fullscreenDialog: true,
      );
    } else if (settings.name == '/login/restableceContraseña') {
      final ScreenArguments args = settings.arguments;
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => ResetPage(args.user_name),
        fullscreenDialog: true,
      );
    } else if (settings.name == '/login/restableceContraseña/validate'){
      final ScreenArguments args = settings.arguments;
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => validateResetPage(args.user_name),
        fullscreenDialog: true,
      );
    } else {
      return null;
    }
  }
}
// TODO: Build a Blup Theme (103)
final ThemeData _blupTheme = _buildBlupTheme();
ThemeData _buildBlupTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.black,
    accentColor: secondaryColor,
    buttonTheme: base.buttonTheme.copyWith (
      buttonColor: Colors.black,
      colorScheme: base.colorScheme.copyWith(
        secondary: primaryTextColor,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      height: 64,
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,

    ),
    appBarTheme: base.appBarTheme.copyWith(
      color: colorCajasTexto,
      textTheme: _buildBlupTextThemeAppBar(base.textTheme),
    ),
    scaffoldBackgroundColor: colorFondo,
    //backgroundColor: kBlupIndigo50,
    cardColor: colorCajasTexto,
    textSelectionColor: secondaryLightColor,
    errorColor: kBlupErrorRed,
    // TODO: Add the text themes (103)
    textTheme: _buildBlupTextTheme(base.textTheme),
    primaryTextTheme: _buildBlupTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildBlupTextTheme(base.accentTextTheme),
    // TODO: Add the icon themes (103)
    primaryIconTheme: base.iconTheme.copyWith(
        color: primaryDarkColor
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      fillColor: colorCajasTexto,
      filled: true,
    ),
  );
}

// TODO: Build a Blup Text Theme (103)
TextTheme _buildBlupTextTheme(TextTheme base) {
  return base.copyWith(

    headline1: base.headline1.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 32.0
    ),
    headline2: base.headline2.copyWith(
        fontSize: 24.0
    ),
    caption: base.caption.copyWith(
      fontSize: 16.0,
    ),
  ).apply(
    fontFamily: 'Helvetica Neu',
    displayColor: Colors.black,
    bodyColor: Colors.black,
  );
}
TextTheme _buildBlupTextThemeAppBar(TextTheme base) {
  return base.copyWith(
    headline1: base.headline1.copyWith(
      fontWeight: FontWeight.bold,
      height: 32.0,
    ),
    headline2: base.headline2.copyWith(
        fontSize: 24.0
    ),
    caption: base.caption.copyWith(
      fontSize: 16.0,
    ),
  ).apply(
    fontFamily: 'Helvetica Neu',
    displayColor: Colors.black,
    bodyColor: Colors.black,
  );
}