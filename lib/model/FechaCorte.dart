import 'package:blupv1/model/SaldoActual.dart';
import 'package:flutter/foundation.dart';
class FechaCorte {
  final String periodoId;
  FechaCorte ({this.periodoId});
  factory FechaCorte.fomJson(Map<String, dynamic> json) {
    return FechaCorte(
      periodoId: json['PERIOD_ID'] as String,
    );
  }
}