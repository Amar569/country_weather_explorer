import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/app_exception.dart';
import '../../data/models/weather.dart';
import '../../providers/providers.dart';

/// Loads on its own; failure here never affects the rest of the details screen.
class WeatherSection extends ConsumerWidget {
  const WeatherSection({super.key, required this.point});
  final LatLng? point;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = point;
    if (p == null) {
      return _shell(context,
          child: const _Notice(
              icon: Icons.location_off_rounded,
              text: 'Weather unavailable: no coordinates for this country.'));
    }
    final weather = ref.watch(weatherProvider(p));
    return _shell(
      context,
      child: weather.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 28),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => _Notice(
          icon: Icons.cloud_off_rounded,
          text: errorMessage(e),
          onRetry: () => ref.invalidate(weatherProvider(p)),
        ),
        data: (w) => _WeatherBody(weather: w),
      ),
    );
  }

  Widget _shell(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Current weather',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }
}

class _WeatherBody extends StatelessWidget {
  const _WeatherBody({required this.weather});
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(children: [
      Row(children: [
        Icon(weather.icon, size: 52, color: scheme.primary),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${weather.temperature.toStringAsFixed(1)}°C',
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
          Text(weather.condition,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 15)),
        ]),
      ]),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(
            child: _Metric(
                icon: Icons.water_drop_outlined,
                label: 'Humidity',
                value: '${weather.humidity}%')),
        const SizedBox(width: 12),
        Expanded(
            child: _Metric(
                icon: Icons.air_rounded,
                label: 'Wind',
                value: '${weather.windSpeed.toStringAsFixed(1)} km/h')),
      ]),
    ]);
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: scheme.primaryContainer.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(icon, color: scheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            Text(value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ]),
        ),
      ]),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, this.onRetry});
  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Icon(icon, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ]),
      if (onRetry != null)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ),
    ]);
  }
}
