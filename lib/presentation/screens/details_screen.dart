// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../core/utils.dart';
// import '../../data/models/country.dart';
// import '../../providers/providers.dart';
// import '../widgets/flag_image.dart';
// import '../widgets/map_section.dart';
// import '../widgets/weather_section.dart';

// class DetailsScreen extends ConsumerWidget {
//   const DetailsScreen({super.key, required this.country});
//   final Country country;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isFav = ref.watch(favoritesProvider).contains(country.code);
//     final point = country.latLng;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(country.name, overflow: TextOverflow.ellipsis),
//         actions: [
//           IconButton(
//             tooltip: isFav ? 'Remove favorite' : 'Add favorite',
//             onPressed: () =>
//                 ref.read(favoritesProvider.notifier).toggle(country.code),
//             icon: Icon(
//               isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
//               color: isFav ? Colors.redAccent : null,
//             ),
//           ),
//         ],
//       ),
//       body: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 720),
//           child: ListView(
//             padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: const Color(0xFFE6E9F2)),
//                 ),
//                 child: Column(children: [
//                   Hero(
//                     tag: 'flag-${country.code}',
//                     child:
//                         FlagImage(url: country.flagUrl, width: 220, height: 140),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(country.name,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.w800)),
//                   const SizedBox(height: 16),
//                   _InfoRow(
//                       icon: Icons.location_city_rounded,
//                       label: 'Capital',
//                       value: country.capital ?? 'N/A'),
//                   _InfoRow(
//                       icon: Icons.public_rounded,
//                       label: 'Region',
//                       value: country.region),
//                   _InfoRow(
//                       icon: Icons.groups_rounded,
//                       label: 'Population',
//                       value: formatNumber(country.population)),
//                   _InfoRow(
//                       icon: Icons.payments_rounded,
//                       label: 'Currency',
//                       value: country.currencies.isEmpty
//                           ? 'N/A'
//                           : country.currencies.join('\n')),
//                   _InfoRow(
//                       icon: Icons.my_location_rounded,
//                       label: 'Latitude / Longitude',
//                       value: point == null
//                           ? 'N/A'
//                           : '${point.latitude.toStringAsFixed(2)}, ${point.longitude.toStringAsFixed(2)}'),
//                 ]),
//               ),
//               const SizedBox(height: 14),
//               WeatherSection(point: point),
//               const SizedBox(height: 14),
//               MapSection(point: point),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   const _InfoRow(
//       {required this.icon, required this.label, required this.value});
//   final IconData icon;
//   final String label;
//   final String value;

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//               color: scheme.primaryContainer,
//               borderRadius: BorderRadius.circular(10)),
//           child: Icon(icon, size: 20, color: scheme.primary),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text(label,
//                 style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//             Text(value,
//                 style: const TextStyle(
//                     fontSize: 15, fontWeight: FontWeight.w600)),
//           ]),
//         ),
//       ]),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
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
      backgroundColor: AppTheme.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 260,
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(
              tooltip: isFav ? 'Remove favorite' : 'Add favorite',
              onPressed: () =>
                  ref.read(favoritesProvider.notifier).toggle(country.code),
              icon: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? Colors.pinkAccent.shade100 : Colors.white,
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsetsDirectional.only(
                start: 56, end: 56, bottom: 16),
            title: Text(country.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800)),
            background: Container(
              decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 44, top: 20),
                    child: Hero(
                      tag: 'flag-${country.code}',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x44000000),
                                blurRadius: 20,
                                offset: Offset(0, 8)),
                          ],
                        ),
                        child: FlagImage(
                            url: country.flagUrl, width: 170, height: 112),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: _StatTile(
                            icon: Icons.groups_rounded,
                            label: 'Population',
                            value: formatNumber(country.population)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatTile(
                            icon: Icons.public_rounded,
                            label: 'Region',
                            value: country.region),
                      ),
                    ]),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: Column(children: [
                        _InfoRow(
                            icon: Icons.location_city_rounded,
                            label: 'Capital',
                            value: country.capital ?? 'N/A'),
                        const Divider(height: 1, color: Color(0xFFEDEFF7)),
                        _InfoRow(
                            icon: Icons.payments_rounded,
                            label: 'Currency',
                            value: country.currencies.isEmpty
                                ? 'N/A'
                                : country.currencies.join('\n')),
                        const Divider(height: 1, color: Color(0xFFEDEFF7)),
                        _InfoRow(
                            icon: Icons.my_location_rounded,
                            label: 'Latitude / Longitude',
                            value: point == null
                                ? 'N/A'
                                : '${point.latitude.toStringAsFixed(2)}, ${point.longitude.toStringAsFixed(2)}'),
                      ]),
                    ),
                    const SizedBox(height: 18),
                    WeatherSection(point: point),
                    const SizedBox(height: 18),
                    MapSection(point: point),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color(0xFFEEF0FF),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: AppTheme.primary),
        ),
        const SizedBox(height: 12),
        Text(label,
            style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
        const SizedBox(height: 2),
        Text(value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppTheme.ink)),
      ]),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color(0xFFEEF0FF),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: AppTheme.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.ink)),
          ]),
        ),
      ]),
    );
  }
}
