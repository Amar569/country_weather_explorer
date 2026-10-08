import 'package:country_weather_explorer/data/models/weather.dart';
import 'package:country_weather_explorer/data/services/weather_api_service.dart';
import 'package:latlong2/latlong.dart';
import '../models/weather.dart';
import '../services/weather_api_service.dart';

class WeatherRepository {
  WeatherRepository(this._api);
  final WeatherApiService _api;

  Future<Weather> getCurrent(LatLng point) async =>
      Weather.fromJson(await _api.fetchCurrent(point));
}
