import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/config.dart';

class MapSection extends StatelessWidget {
  const MapSection({super.key, required this.point});
  final LatLng? point;

  @override
  Widget build(BuildContext context) {
    final p = point;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 240,
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
                const Positioned(
                  right: 6,
                  bottom: 4,
                  child: Text('© OpenStreetMap contributors',
                      style: TextStyle(fontSize: 10, color: Colors.black87)),
                ),
              ]),
      ),
    );
  }
}
