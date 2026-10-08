import 'package:flutter/material.dart';

import '../../core/app_exception.dart';

class Weather {
  final double temperature; // °C
  final int humidity; // %
  final double windSpeed; // km/h
  final int code;

  const Weather({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.code,
  });

  factory Weather.fromJson(dynamic json) {
    final current = json is Map ? json['current'] : null;
    if (current is! Map ||
        current['temperature_2m'] is! num ||
        current['relative_humidity_2m'] is! num ||
        current['wind_speed_10m'] is! num) {
      throw const AppException('Weather data is unavailable for this location.');
    }
    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).round(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      code: (current['weather_code'] as num?)?.toInt() ?? -1,
    );
  }

  String get condition {
    if (code == 0) return 'Clear sky';
    if (code == 1 || code == 2) return 'Partly cloudy';
    if (code == 3) return 'Overcast';
    if (code == 45 || code == 48) return 'Foggy';
    if (code >= 51 && code <= 57) return 'Drizzle';
    if (code >= 61 && code <= 67) return 'Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain showers';
    if (code == 85 || code == 86) return 'Snow showers';
    if (code >= 95 && code <= 99) return 'Thunderstorm';
    return 'Unknown';
  }

  IconData get icon {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code == 1 || code == 2) return Icons.wb_cloudy_outlined;
    if (code == 3) return Icons.cloud_rounded;
    if (code == 45 || code == 48) return Icons.foggy;
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return Icons.water_drop_rounded;
    }
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return Icons.ac_unit_rounded;
    }
    if (code >= 95 && code <= 99) return Icons.thunderstorm_rounded;
    return Icons.thermostat_rounded;
  }
}
