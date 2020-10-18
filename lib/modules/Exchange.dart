import 'package:iraqibayt/modules/City.dart';
import 'package:iraqibayt/modules/Currency.dart';

class Exchange {
  int id;
  Currency from;
  double fromVal;
  Currency to;
  double toVal;
  String direction;
  City city;
  String date;

  Exchange({
    this.id,
    this.from,
    this.fromVal,
    this.to,
    this.toVal,
    this.direction,
    this.city,
    this.date,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      id: json['id'] as int,
      from: Currency.fromJson(json['from']),
      fromVal: json['val_from'].toDouble(),
      to: Currency.fromJson(json['to']),
      toVal: json['val_to'].toDouble(),
      direction: json['direction'] as String,
      city: City.fromJson(json['city']),
      date: json['day'] as String,
    );
  }
}
