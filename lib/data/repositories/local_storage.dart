import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage(this._p);
  final SharedPreferences _p;

  static const _recentKey = 'recent_searches';
  static const _favKey = 'favorite_countries';

  List<String> get recentSearches => _p.getStringList(_recentKey) ?? [];
  Future<void> saveRecentSearches(List<String> v) =>
      _p.setStringList(_recentKey, v);

  Set<String> get favorites => (_p.getStringList(_favKey) ?? []).toSet();
  Future<void> saveFavorites(Set<String> v) =>
      _p.setStringList(_favKey, v.toList());
}
