import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/config.dart';
import '../../core/theme.dart';

class MapSection extends StatelessWidget {
  const MapSection({super.key, required this.point});
  final LatLng? point;

  @override
  Widget build(BuildContext context) {
    final p = point;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.only(left: 4, bottom: 10),
        child: Text('Location',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink)),
      ),
      Container(
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.softShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: p == null
              ? Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: const Text('Map unavailable: no coordinates.'))
              : Stack(children: [
                  FlutterMap(
                    options: MapOptions(initialCenter: p, initialZoom: 4),
                    children: [
                      TileLayer(
                        urlTemplate: AppConfig.mapTileUrl,
                        userAgentPackageName: AppConfig.mapUserAgent,
                      ),
                      MarkerLayer(markers: [
                        Marker(
                          point: p,
                          width: 44,
                          height: 44,
                          alignment: Alignment.topCenter,
                          child: const Icon(Icons.location_on_rounded,
                              size: 44, color: Colors.redAccent),
                        ),
                      ]),
                    ],
                  ),
                  Positioned(
                    right: 6,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      color: Colors.white70,
                      child: const Text('© OpenStreetMap contributors',
                          style: TextStyle(fontSize: 10)),
                    ),
                  ),
                ]),
        ),
      ),
    ]);
  }
}
