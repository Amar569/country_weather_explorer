class AppConfig {
  AppConfig._();

  static const countriesBaseUrl = 'https://countries.dev';
  static const countryFields =
      'name,alpha2Code,alpha3Code,flags,capital,region,population,currencies,latlng';

  static const weatherBaseUrl = 'https://api.open-meteo.com/v1';

  static const mapTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const mapUserAgent = 'com.example.country_weather_explorer';

  static const requestTimeout = Duration(seconds: 15);
  static const maxRecentSearches = 5;
}