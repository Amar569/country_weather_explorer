import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE6E9F2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Hero(
              tag: 'flag-${country.code}',
              child: FlagImage(url: country.flagUrl, width: 64, height: 44),
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
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.location_city_rounded,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(country.capital ?? 'No capital',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey.shade700)),
                    ),
                  ]),
                  const SizedBox(height: 2),
                  Row(children: [
                    Icon(Icons.public_rounded,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(country.region,
                        style: TextStyle(color: Colors.grey.shade700)),
                  ]),
                ],
              ),
            ),
            IconButton(
              tooltip: isFav ? 'Remove favorite' : 'Add favorite',
              onPressed: () =>
                  ref.read(favoritesProvider.notifier).toggle(country.code),
              icon: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? Colors.redAccent : Colors.grey,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
