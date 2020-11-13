import 'package:flutter/foundation.dart';

class SaldoActualDetalle {
  final int transaction_id;
  final int day;
  final String hour;
  final String acct_no;
  final int extracted_amount;
  final int comission_amount;
  final DateTime create_date;
  final String tipo;
  final DateTime exp_date;
  final String description;

  SaldoActualDetalle({this.transaction_id, this.day, this.hour, this.acct_no, this.extracted_amount, this.comission_amount, this.create_date, this.tipo, this.exp_date, this.description});

  factory SaldoActualDetalle.fomJson(Map<String, dynamic> json) {
    return new SaldoActualDetalle(
        transaction_id: json['TRANSACTION_ID'] as int,
        day : json['DAY'] as int,
        hour: json['HOUR'] as String,
        acct_no: json['ACCT_NO'] as String,
        extracted_amount: int.parse(json['EXTRACTED_AMOUNT']),
        comission_amount: int.parse(json['COMISSION_AMOUNT']),
        create_date: DateTime.parse(json['CREATE_DATE']),
        tipo: json['TIPO'] as String,
        exp_date: DateTime.parse(json['EXP_DATE']),
        description: json['DESCRIPTION'] as String
    );
  }
}