import 'package:blupv1/app.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        //final isValidHost = host == "3.83.228.250";
        final isValidHost = host == "192.168.1.134";
        //final isValidHost = host == "192.168.2.106";
        return isValidHost;
      };
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(BlupApp());
}