import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils.dart';
import '../../data/models/country.dart';
import '../../providers/providers.dart';
import '../widgets/flag_image.dart';
import '../widgets/map_section.dart';
import '../widgets/weather_section.dart';

class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({super.key, required this.country});
  final Country country;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).contains(country.code);
    final point = country.latLng;

    return Scaffold(
      appBar: AppBar(
        title: Text(country.name, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: isFav ? 'Remove favorite' : 'Add favorite',
            onPressed: () =>
                ref.read(favoritesProvider.notifier).toggle(country.code),
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? Colors.redAccent : null,
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE6E9F2)),
                ),
                child: Column(children: [
                  Hero(
                    tag: 'flag-${country.code}',
                    child:
                        FlagImage(url: country.flagUrl, width: 220, height: 140),
                  ),
                  const SizedBox(height: 16),
                  Text(country.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  _InfoRow(
                      icon: Icons.location_city_rounded,
                      label: 'Capital',
                      value: country.capital ?? 'N/A'),
                  _InfoRow(
                      icon: Icons.public_rounded,
                      label: 'Region',
                      value: country.region),
                  _InfoRow(
                      icon: Icons.groups_rounded,
                      label: 'Population',
                      value: formatNumber(country.population)),
                  _InfoRow(
                      icon: Icons.payments_rounded,
                      label: 'Currency',
                      value: country.currencies.isEmpty
                          ? 'N/A'
                          : country.currencies.join('\n')),
                  _InfoRow(
                      icon: Icons.my_location_rounded,
                      label: 'Latitude / Longitude',
                      value: point == null
                          ? 'N/A'
                          : '${point.latitude.toStringAsFixed(2)}, ${point.longitude.toStringAsFixed(2)}'),
                ]),
              ),
              const SizedBox(height: 14),
              WeatherSection(point: point),
              const SizedBox(height: 14),
              MapSection(point: point),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: scheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            Text(value,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ]),
        ),
      ]),
    );
  }
}
