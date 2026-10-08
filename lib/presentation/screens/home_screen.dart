import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_exception.dart';
import '../../core/theme.dart';
import '../../data/models/country.dart';
import '../../providers/providers.dart';
import '../widgets/country_card.dart';
import '../widgets/state_views.dart';
import 'details_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuery(String v) => ref.read(searchQueryProvider.notifier).state = v;

  void _open(Country c) {
    if (_controller.text.trim().isNotEmpty) {
      ref.read(recentSearchesProvider.notifier).add(c.name);
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailsScreen(country: c)),
    );
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(100, 44)),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Log out')),
        ],
      ),
    );
    if (ok == true) {
      ref.read(searchQueryProvider.notifier).state = '';
      ref.read(favoritesOnlyProvider.notifier).state = false;
      await ref.read(authRepositoryProvider).signOut();
    }
  }

  Widget _constrained(Widget child) => Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720), child: child),
      );

  Widget _headerButton(
      {required IconData icon,
      required String tooltip,
      required VoidCallback onPressed,
      Color color = Colors.white}) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(backgroundColor: Colors.white24),
      icon: Icon(icon, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final countries = ref.watch(filteredCountriesProvider);
    final query = ref.watch(searchQueryProvider);
    final favOnly = ref.watch(favoritesOnlyProvider);
    final recents = ref.watch(recentSearchesProvider);
    final top = MediaQuery.of(context).padding.top;

    const noBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide.none,
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(children: [
        // ---------- Gradient header with search ----------
        Container(
          padding: EdgeInsets.fromLTRB(20, top + 14, 20, 22),
          decoration: const BoxDecoration(
            gradient: AppTheme.headerGradient,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: _constrained(Column(children: [
            Row(children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Explore',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 2),
                    Text('Countries, weather & maps',
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              _headerButton(
                icon: favOnly
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: favOnly ? Colors.pinkAccent.shade100 : Colors.white,
                tooltip: favOnly ? 'Show all' : 'Show favorites',
                onPressed: () =>
                    ref.read(favoritesOnlyProvider.notifier).state = !favOnly,
              ),
              const SizedBox(width: 8),
              _headerButton(
                icon: Icons.logout_rounded,
                tooltip: 'Log out',
                onPressed: _logout,
              ),
            ]),
            const SizedBox(height: 18),
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onChanged: _setQuery,
              onSubmitted: (v) =>
                  ref.read(recentSearchesProvider.notifier).add(v),
              decoration: InputDecoration(
                hintText: 'Search countries',
                border: noBorder,
                enabledBorder: noBorder,
                focusedBorder: noBorder,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _controller.clear();
                          _setQuery('');
                        },
                      ),
              ),
            ),
          ])),
        ),

        // ---------- Body ----------
        Expanded(
          child: _constrained(Column(children: [
            if (query.isEmpty && recents.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Text('Recent searches',
                          style: TextStyle(
                              color: AppTheme.ink,
                              fontWeight: FontWeight.w700)),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            ref.read(recentSearchesProvider.notifier).clear(),
                        child: const Text('Clear'),
                      ),
                    ]),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (final r in recents)
                          ActionChip(
                            avatar: const Icon(Icons.history_rounded, size: 18),
                            label: Text(r),
                            onPressed: () {
                              _controller.text = r;
                              _controller.selection =
                                  TextSelection.collapsed(offset: r.length);
                              _setQuery(r);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            Expanded(
              child: countries.when(
                loading: () =>
                    const LoadingView(message: 'Loading countries...'),
                error: (e, _) => MessageView(
                  icon: Icons.wifi_off_rounded,
                  title: 'Could not load countries',
                  message: errorMessage(e),
                  onRetry: () => ref.invalidate(countriesProvider),
                ),
                data: (list) {
                  if (list.isEmpty) {
                    final noFavs = favOnly && query.trim().isEmpty;
                    return MessageView(
                      icon: noFavs
                          ? Icons.favorite_border_rounded
                          : Icons.search_off_rounded,
                      title: noFavs ? 'No favorites yet' : 'No countries found',
                      message: noFavs
                          ? 'Tap the heart on a country to save it here.'
                          : 'Nothing matches "${query.trim()}". Try a different name.',
                    );
                  }
                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                      child: Row(children: [
                        Text(
                          favOnly
                              ? '${list.length} favorites'
                              : '${list.length} countries',
                          style: const TextStyle(
                              color: AppTheme.muted,
                              fontWeight: FontWeight.w600),
                        ),
                      ]),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(countriesProvider);
                          try {
                            await ref.read(countriesProvider.future);
                          } catch (_) {}
                        },
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
                          itemCount: list.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) => CountryCard(
                            country: list[i],
                            onTap: () => _open(list[i]),
                          ),
                        ),
                      ),
                    ),
                  ]);
                },
              ),
            ),
          ])),
        ),
      ]),
    );
  }
}
