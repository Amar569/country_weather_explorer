import '../../core/api_client.dart';
import '../../core/config.dart';

class CountryApiService {
  CountryApiService(this._client);
  final ApiClient _client;

   Future<dynamic> fetchAll() {
    final uri = Uri.parse('${AppConfig.countriesBaseUrl}/countries')
        .replace(queryParameters: {'fields': AppConfig.countryFields});
    return _client.getJson(uri);
  }
}
