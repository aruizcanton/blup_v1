import 'package:blupv1/model/FechaCorte.dart';
import 'package:blupv1/model/SaldoActualDetalle.dart';

class SaldoActual {
  final int totalDescontado;
  final int totalCuotas;
  final int totalRetirado;
  final int totalFolios;
  final List<SaldoActualDetalle> detalle;
  final List<FechaCorte> fechaCortes;

  SaldoActual ({this.totalDescontado, this.totalCuotas, this.totalRetirado, this.totalFolios, this.detalle, this.fechaCortes});

  factory SaldoActual.fomJson(Map<String, dynamic> json) {
    final parsedSaldoActualDetalle = json['detalle'].cast<Map<String, dynamic>>();
    final List<SaldoActualDetalle> saldoActualDetalleList = parsedSaldoActualDetalle.map<SaldoActualDetalle>((json) => SaldoActualDetalle.fomJson(json)).toList();
    final parsedFechaCortes = json['fechaCortes'].cast<Map<String, dynamic>>();
    final List<FechaCorte> fechaCortesList = parsedFechaCortes.map<FechaCorte>((json) => FechaCorte.fomJson(json)).toList();
    return SaldoActual(
      totalDescontado: int.parse(json['totalDescontado'].toString()),
      totalCuotas : int.parse(json['totalCuotas'].toString()),
      totalRetirado: int.parse(json['totalRetirado'].toString()),
      totalFolios: int.parse(json['totalFolios'].toString()),
      detalle: saldoActualDetalleList,
      fechaCortes: fechaCortesList
    );
  }
}