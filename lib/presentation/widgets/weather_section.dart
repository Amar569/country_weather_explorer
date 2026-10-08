import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../core/app_exception.dart';
import '../../core/theme.dart';
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
      return _plainCard(const _Notice(
          icon: Icons.location_off_rounded,
          text: 'Weather unavailable: no coordinates for this country.'));
    }
    final weather = ref.watch(weatherProvider(p));
    return weather.when(
      loading: () => _plainCard(const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(child: CircularProgressIndicator()),
      )),
      error: (e, _) => _plainCard(_Notice(
        icon: Icons.cloud_off_rounded,
        text: errorMessage(e),
        onRetry: () => ref.invalidate(weatherProvider(p)),
      )),
      data: (w) => _WeatherBody(weather: w),
    );
  }

  Widget _plainCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Current weather',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink)),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.weatherGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x332563EB), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Current weather',
            style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Row(children: [
          Icon(weather.icon, size: 60, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${weather.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w800)),
                  Text(weather.condition,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16)),
                ]),
          ),
        ]),
        const SizedBox(height: 18),
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
      ]),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12, color: Colors.white.withOpacity(0.85))),
            Text(value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
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
        Icon(icon, color: AppTheme.muted),
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
