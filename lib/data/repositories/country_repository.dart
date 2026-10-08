import '../../core/app_exception.dart';
import '../models/country.dart';
import '../services/country_api_service.dart';

class CountryRepository {
  CountryRepository(this._api);
  final CountryApiService _api;

  Future<List<Country>> getCountries() async {
    final data = await _api.fetchAll();

    if (data is Map) {
      final errors = data['errors'];
      final msg = (errors is List && errors.isNotEmpty && errors.first is Map)
          ? (errors.first as Map)['message']?.toString()
          : null;
      throw AppException(msg ?? 'The countries service returned an error.');
    }
    if (data is! List || data.isEmpty) {
      throw const AppException('No countries were returned by the server.');
    }

    final countries = <Country>[];
    for (final item in data) {
      if (item is! Map<String, dynamic>) continue;
      try {
        countries.add(Country.fromJson(item));
      } on FormatException {
        // skip malformed entries instead of crashing
      }
    }
    if (countries.isEmpty) {
      throw const AppException('The server returned invalid country data.');
    }
    countries.sort((a, b) => a.name.compareTo(b.name));
    return countries;
  }
}