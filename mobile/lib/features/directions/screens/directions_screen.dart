import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/api_client.dart';

enum TravelMode { driving, walking, cycling }

const _avgSpeedKmh = {
  TravelMode.driving: 30.0,
  TravelMode.walking: 5.0,
  TravelMode.cycling: 15.0,
};

class DirectionsScreen extends StatefulWidget {
  final String destinationName;
  final double destinationLat;
  final double destinationLng;

  const DirectionsScreen({
    super.key,
    required this.destinationName,
    required this.destinationLat,
    required this.destinationLng,
  });

  @override
  State<DirectionsScreen> createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends State<DirectionsScreen> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;

  LatLng? _origin;
  List<LatLng> _routePoints = [];
  bool _loading = true;
  String? _errorMessage;
  final ConnectivityService _connectivityService = ConnectivityService();
  double? _distanceKmBackend;
  int? _etaMinutesBackend;
  TravelMode _mode = TravelMode.driving;


  late final LatLng _destination =
  LatLng(widget.destinationLat, widget.destinationLng);

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadOrigin);
  }

  Future<void> _loadOrigin() async {
    final result = await _locationService.getCurrentLocation();
    if (result.status == LocationStatus.granted) {
      setState(() {
        _origin = LatLng(result.position!.latitude, result.position!.longitude);
        _loading = false;
      });
      Future.delayed(const Duration(milliseconds: 300), _fitBounds);
      _fetchRoute();
    } else {
      setState(() {
        _loading = false;
        _errorMessage =
        'Could not get your current location. Enable location access to see directions.';
      });
    }
  }

  /// Fetches route from backend and updates state.
  Future<void> _fetchRoute() async {
    if (_origin == null) return;
    // Check internet connectivity first.
    final hasInternet = await _connectivityService.isConnected();
    if (!hasInternet) {
      final dist = _distanceKm(_origin!, _destination);
      final speed = _avgSpeedKmh[_mode] ?? 30.0;
      final eta = (dist / speed * 60).round();
      setState(() {
        _distanceKmBackend = dist;
        _etaMinutesBackend = eta;
        _errorMessage = 'Offline mode: Showing estimated straight-line route.';
      });
      return;
    }

    try {
      final response = await ApiClient.instance.dio.get(
        '${ApiConstants.baseUrl}/directions/route',
        queryParameters: {
          'originLat': _origin!.latitude,
          'originLng': _origin!.longitude,
          'destLat': _destination.latitude,
          'destLng': _destination.longitude,
          'mode': _mode.name,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final polyline = (data['polyline'] as List)
          .map((e) => LatLng(e['latitude'] as double, e['longitude'] as double))
          .toList();
      setState(() {
        _routePoints = polyline;
        _distanceKmBackend = (data['distanceKm'] as num?)?.toDouble();
        _etaMinutesBackend = (data['durationMins'] as num?)?.toInt();
        _errorMessage = null;
      });
      // Re‑fit camera to new bounds.
      Future.delayed(const Duration(milliseconds: 300), _fitBounds);
    } catch (e) {
      final dist = _distanceKm(_origin!, _destination);
      final speed = _avgSpeedKmh[_mode] ?? 30.0;
      final eta = (dist / speed * 60).round();
      setState(() {
        _distanceKmBackend = dist;
        _etaMinutesBackend = eta;
        _errorMessage = 'Using offline direct line (${friendlyErrorMessage(e)})';
      });
    }
  }

  void _fitBounds() {
    if (_origin == null || _mapController == null) return;
    final bounds = LatLngBounds(
      southwest: LatLng(
        math.min(_origin!.latitude, _destination.latitude),
        math.min(_origin!.longitude, _destination.longitude),
      ),
      northeast: LatLng(
        math.max(_origin!.latitude, _destination.latitude),
        math.max(_origin!.longitude, _destination.longitude),
      ),
    );
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }



  double _distanceKm(LatLng a, LatLng b) {
    const earthRadiusKm = 6371.0;
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLng = _deg2rad(b.longitude - a.longitude);
    final lat1 = _deg2rad(a.latitude);
    final lat2 = _deg2rad(b.latitude);

    final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) * math.sin(dLng / 2) * math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
    return earthRadiusKm * c;
  }

  double _deg2rad(double deg) => deg * (math.pi / 180);

  @override
  Widget build(BuildContext context) {
    final distanceKm = _distanceKmBackend;
    final etaMinutes = _etaMinutesBackend;

    return Scaffold(
      appBar: AppBar(title: Text('Directions to ${widget.destinationName}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              color: AppColors.warning.withValues(alpha: 0.15),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, size: 18, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_errorMessage!, style: const TextStyle(fontSize: 13))),
                ],
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _origin ?? _destination,
                    zoom: 12,
                  ),
                  onMapCreated: (c) {
                    _mapController = c;
                    _fitBounds();
                  },
                  markers: {
                    if (_origin != null)
                      Marker(
                        markerId: const MarkerId('origin'),
                        position: _origin!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueAzure),
                        infoWindow: const InfoWindow(title: 'Your location'),
                      ),
                    Marker(
                      markerId: const MarkerId('destination'),
                      position: _destination,
                      infoWindow: InfoWindow(title: widget.destinationName),
                    ),
                  },
                  polylines: {
                    if (_origin != null)
                      Polyline(
                        polylineId: const PolylineId('route'),
                        points: _routePoints.isNotEmpty ? _routePoints : [_origin!, _destination],
                        color: AppColors.primary,
                        width: 4,
                        patterns: [PatternItem.dash(16), PatternItem.gap(8)],
                      ),
                  },
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                ),
              ],
            ),
          ),
          _RouteInfoPanel(
            mode: _mode,
            onModeChanged: (m) {
              setState(() => _mode = m);
              _fetchRoute();
            },
            distanceKm: distanceKm,
            etaMinutes: etaMinutes,
          ),
        ],
      ),
    );
  }
}

class _RouteInfoPanel extends StatelessWidget {
  final TravelMode mode;
  final ValueChanged<TravelMode> onModeChanged;
  final double? distanceKm;
  final int? etaMinutes;

  const _RouteInfoPanel({
    required this.mode,
    required this.onModeChanged,
    required this.distanceKm,
    required this.etaMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ModeButton(
                icon: Icons.directions_car,
                label: 'Drive',
                selected: mode == TravelMode.driving,
                onTap: () => onModeChanged(TravelMode.driving),
              ),
              const SizedBox(width: 8),
              _ModeButton(
                icon: Icons.directions_walk,
                label: 'Walk',
                selected: mode == TravelMode.walking,
                onTap: () => onModeChanged(TravelMode.walking),
              ),
              const SizedBox(width: 8),
              _ModeButton(
                icon: Icons.directions_bike,
                label: 'Cycle',
                selected: mode == TravelMode.cycling,
                onTap: () => onModeChanged(TravelMode.cycling),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (distanceKm != null && etaMinutes != null)
            Builder(builder: (context) {
              final dist = distanceKm!;
              final eta = etaMinutes!;
              return Row(
                children: [
                  Text(
                    eta < 60 ? '$eta min' : '${(eta / 60).toStringAsFixed(1)} hr',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '(${dist.toStringAsFixed(1)} km, straight-line)',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              );
            })
          else
            const Text(
              'Enable location to see distance and time.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
            border: Border.all(color: selected ? AppColors.primary : Colors.black12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary, size: 20),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
