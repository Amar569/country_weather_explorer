import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../data/models/country.dart';
import '../../providers/providers.dart';
import 'flag_image.dart';

class CountryCard extends ConsumerWidget {
  const CountryCard({super.key, required this.country, required this.onTap});
  final Country country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).contains(country.code);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppTheme.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Hero(
                tag: 'flag-${country.code}',
                child: FlagImage(url: country.flagUrl, width: 68, height: 46),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(country.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.ink)),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.location_city_rounded,
                          size: 14, color: AppTheme.muted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(country.capital ?? 'No capital',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppTheme.muted)),
                      ),
                    ]),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF0FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(country.region,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary)),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isFav ? 'Remove favorite' : 'Add favorite',
                onPressed: () =>
                    ref.read(favoritesProvider.notifier).toggle(country.code),
                icon: Icon(
                  isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFav ? Colors.redAccent : Colors.grey.shade400,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
