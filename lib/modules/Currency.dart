//import 'package:json_annotation/json_annotation.dart';
//import 'dart:async' show Future;
//import 'package:flutter/services.dart' show rootBundle;
//import 'dart:convert';

//@JsonSerializable(explicitToJson: true)
class Currency {
  int id;
  String name;
  String shortName;
  int active;

  Currency({this.id, this.name, this.shortName, this.active});
  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'] as int,
      name: json['name'] as String,
      shortName: json['short_name'] as String,
      active: json['active'] as int,
    );
  }
}
