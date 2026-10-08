import 'package:latlong2/latlong.dart';

import '../../core/api_client.dart';
import '../../core/config.dart';

class WeatherApiService {
  WeatherApiService(this._client);
  final ApiClient _client;

  Future<dynamic> fetchCurrent(LatLng p) {
    final uri = Uri.parse('${AppConfig.weatherBaseUrl}/forecast').replace(
      queryParameters: {
        'latitude': p.latitude.toString(),
        'longitude': p.longitude.toString(),
        'current':
            'temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code',
      },
    );
    return _client.getJson(uri);
  }
}
