import 'package:latlong2/latlong.dart';

class Country {
  final String code;
  final String name;
  final String? capital;
  final String region;
  final String? flagUrl;
  final int population;
  final List<String> currencies;
  final LatLng? latLng;

  const Country({
    required this.code,
    required this.name,
    required this.region,
    required this.population,
    required this.currencies,
    this.capital,
    this.flagUrl,
    this.latLng,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final rawName = json['name'];
    final name = (rawName is Map ? rawName['common'] : rawName)?.toString();
    if (name == null || name.isEmpty) {
      throw const FormatException('Country without a name');
    }

    final rawCapital = json['capital'];
    String? capital;
    if (rawCapital is List && rawCapital.isNotEmpty) {
      capital = rawCapital.first.toString();
    } else if (rawCapital is String && rawCapital.isNotEmpty) {
      capital = rawCapital;
    }

    final alpha2 = json['alpha2Code']?.toString();
    final flags = json['flags'];
    String? flag = flags is Map ? flags['png']?.toString() : null;
    if ((flag == null || flag.isEmpty) && alpha2 != null && alpha2.isNotEmpty) {
      flag = 'https://flagcdn.com/w320/${alpha2.toLowerCase()}.png';
    }

    final currencies = <String>[];
    final cur = json['currencies'];
    if (cur is List) {
      for (final c in cur) {
        if (c is! Map) continue;
        final code = c['code']?.toString() ?? '';
        final n = c['name']?.toString() ?? code;
        final s = c['symbol']?.toString();
        currencies.add(
            '$n ($code${s != null && s.isNotEmpty ? ', $s' : ''})');
      }
    }

    LatLng? latLng;
    final ll = json['latlng'];
    if (ll is List && ll.length >= 2 && ll[0] is num && ll[1] is num) {
      latLng = LatLng((ll[0] as num).toDouble(), (ll[1] as num).toDouble());
    }

    final region = json['region']?.toString() ?? '';

    return Country(
      code: json['alpha3Code']?.toString() ?? alpha2 ?? name,
      name: name,
      capital: capital,
      region: region.isEmpty ? 'Unknown' : region,
      flagUrl: flag,
      population: (json['population'] as num?)?.toInt() ?? 0,
      currencies: currencies,
      latLng: latLng,
    );
  }
}