import 'package:blupv1/model/SaldoHistoDetalle.dart';
import 'package:flutter/foundation.dart';

class SaldoHistorico {
  final int totalDescontado;
  final int totalCuotas;
  final int totalRetirado;
  final int totalFolios;
  final List<SaldoHistoDetalle> detalle;

  SaldoHistorico ({this.totalDescontado, this.totalCuotas, this.totalRetirado, this.totalFolios, this.detalle});

  factory SaldoHistorico.fomJson(Map<String, dynamic> json) {
    final parsedSaldoHistoDetalle = json['detalle'].cast<Map<String, dynamic>>();
    final List<SaldoHistoDetalle> saldoHistoDetalleList = parsedSaldoHistoDetalle.map<SaldoHistoDetalle>((json) => SaldoHistoDetalle.fomJson(json)).toList();
    return SaldoHistorico(
      totalDescontado: int.parse(json['totalDescontado'].toString()),
      totalCuotas : int.parse(json['totalCuotas'].toString()),
      totalRetirado: int.parse(json['totalRetirado'].toString()),
      totalFolios: int.parse(json['totalFolios'].toString()),
      detalle: saldoHistoDetalleList
    );
  }
}