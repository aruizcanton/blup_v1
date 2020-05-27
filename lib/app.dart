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

import 'home.dart';
import 'login.dart';
import 'colors.dart';

final storage = FlutterSecureStorage();
// TODO: Convert BlupApp to stateful widget (104)
class BlupApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blup',
      // TODO: Change home: to a Backdrop with a HomePage frontLayer (104)
      home: HomePage(),
      // TODO: Make currentCategory field take _currentCategory (104)
      // TODO: Pass _currentCategory for frontLayer (104)
      // TODO: Change backLayer field value to CategoryMenuPage (104)
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
      // TODO: Add a theme (103)
      theme: _blupTheme, // New code
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}

// TODO: Build a Blup Theme (103)
final ThemeData _blupTheme = _buildBlupTheme();
ThemeData _buildBlupTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: secondaryColor,
    primaryColor: primaryColor,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: primaryDarkColor,
      colorScheme: base.colorScheme.copyWith(
        secondary: primaryTextColor,
      ),
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),
    appBarTheme: base.appBarTheme.copyWith(
      textTheme: _buildBlupTextThemeAppBar(base.textTheme),
    ),
    scaffoldBackgroundColor: lBlupBackgroundPreWhite,
    cardColor: secondaryColor,
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
    // TODO: Decorate the inputs (103)
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}

// TODO: Build a Blup Text Theme (103)
TextTheme _buildBlupTextTheme(TextTheme base) {
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(
        fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
  ).apply(
    fontFamily: 'Rubik',
    displayColor: primaryDarkColor,
    bodyColor: primaryDarkColor,
  );
}
TextTheme _buildBlupTextThemeAppBar(TextTheme base) {
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(
        fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
  ).apply(
    fontFamily: 'Rubik',
    displayColor: primaryTextColor,
    bodyColor: primaryTextColor,
  );
}