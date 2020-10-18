import 'package:iraqibayt/modules/City.dart';

class Weather {
  int id;
  City city;
  String direction;
  String temperature;
  String maxTemperature;
  String minTemperature;
  String windDirection;
  String windSpeed;
  String humidity;
  String wIcon;
  String day;

  Weather({
    this.id,
    this.city,
    this.direction,
    this.temperature,
    this.maxTemperature,
    this.minTemperature,
    this.windDirection,
    this.windSpeed,
    this.humidity,
    this.wIcon,
    this.day,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'] as int,
      city: City.fromJson(json['city']),
      direction: json['direction'] as String,
      temperature: json['temp'] as String,
      maxTemperature: json['max_temp'] as String,
      minTemperature: json['min_temp'] as String,
      windDirection: json['wind_dir'] as String,
      windSpeed: json['wind_speed'] as String,
      humidity: json['hum'] as String,
      wIcon: json['icon'] as String,
      day: json['day'] as String,
    );
  }
}
