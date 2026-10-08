import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_exception.dart';
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
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(90, 44)),
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

  @override
  Widget build(BuildContext context) {
    final countries = ref.watch(filteredCountriesProvider);
    final query = ref.watch(searchQueryProvider);
    final favOnly = ref.watch(favoritesOnlyProvider);
    final recents = ref.watch(recentSearchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        actions: [
          IconButton(
            tooltip: favOnly ? 'Show all' : 'Show favorites',
            onPressed: () =>
                ref.read(favoritesOnlyProvider.notifier).state = !favOnly,
            icon: Icon(
              favOnly ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: favOnly ? Colors.redAccent : null,
            ),
          ),
          IconButton(
            tooltip: 'Log out',
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onChanged: _setQuery,
                onSubmitted: (v) =>
                    ref.read(recentSearchesProvider.notifier).add(v),
                decoration: InputDecoration(
                  hintText: 'Search countries',
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
            ),
            if (query.isEmpty && recents.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text('Recent searches',
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600)),
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
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(countriesProvider);
                      try {
                        await ref.read(countriesProvider.future);
                      } catch (_) {}
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => CountryCard(
                        country: list[i],
                        onTap: () => _open(list[i]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
