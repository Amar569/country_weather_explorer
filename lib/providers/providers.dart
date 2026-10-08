import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_client.dart';
import '../core/config.dart';
import '../data/models/country.dart';
import '../data/models/weather.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/country_repository.dart';
import '../data/repositories/local_storage.dart';
import '../data/repositories/weather_repository.dart';
import '../data/services/country_api_service.dart';
import '../data/services/weather_api_service.dart';

// ---------- Infrastructure ----------
final sharedPrefsProvider =
    Provider<SharedPreferences>((_) => throw UnimplementedError());
final localStorageProvider =
    Provider((ref) => LocalStorage(ref.watch(sharedPrefsProvider)));
final apiClientProvider = Provider((_) => ApiClient());

final authRepositoryProvider = Provider((_) => AuthRepository());
final countryRepositoryProvider = Provider((ref) =>
    CountryRepository(CountryApiService(ref.watch(apiClientProvider))));
final weatherRepositoryProvider = Provider((ref) =>
    WeatherRepository(WeatherApiService(ref.watch(apiClientProvider))));

// ---------- Auth ----------
final authStateProvider = StreamProvider<User?>(
    (ref) => ref.watch(authRepositoryProvider).authStateChanges);

// ---------- Countries (AsyncValue = loading / data / error) ----------
final countriesProvider = FutureProvider<List<Country>>(
    (ref) => ref.watch(countryRepositoryProvider).getCountries());

// ---------- Weather (independent of countries, per location) ----------
final weatherProvider = FutureProvider.autoDispose.family<Weather, LatLng>(
    (ref, point) => ref.watch(weatherRepositoryProvider).getCurrent(point));

// ---------- Search & filter ----------
final searchQueryProvider = StateProvider<String>((_) => '');
final favoritesOnlyProvider = StateProvider<bool>((_) => false);

final filteredCountriesProvider = Provider<AsyncValue<List<Country>>>((ref) {
  final all = ref.watch(countriesProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final favOnly = ref.watch(favoritesOnlyProvider);
  final favs = ref.watch(favoritesProvider);

  return all.whenData((list) => list.where((c) {
        if (favOnly && !favs.contains(c.code)) return false;
        return query.isEmpty || c.name.toLowerCase().contains(query);
      }).toList());
});

// ---------- Local storage backed state ----------
class RecentSearchesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => ref.read(localStorageProvider).recentSearches;

  void add(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    final updated = [
      q,
      ...state.where((e) => e.toLowerCase() != q.toLowerCase()),
    ].take(AppConfig.maxRecentSearches).toList();
    state = updated;
    ref.read(localStorageProvider).saveRecentSearches(updated);
  }

  void clear() {
    state = [];
    ref.read(localStorageProvider).saveRecentSearches([]);
  }
}

final recentSearchesProvider =
    NotifierProvider<RecentSearchesNotifier, List<String>>(
        RecentSearchesNotifier.new);

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => ref.read(localStorageProvider).favorites;

  void toggle(String code) {
    final updated = {...state};
    if (!updated.remove(code)) updated.add(code);
    state = updated;
    ref.read(localStorageProvider).saveFavorites(updated);
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);
