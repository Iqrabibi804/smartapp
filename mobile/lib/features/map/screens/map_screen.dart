import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/location_service.dart';
import '../../directions/screens/directions_screen.dart';
import '../../places/models/place_model.dart';
import '../../places/screens/place_details_screen.dart';
import '../../places/services/places_providers.dart';

const _defaultCenter = LatLng(33.6844, 73.0479);

class MapScreen extends ConsumerStatefulWidget {
  final LatLng? initialCenter;
  final PlaceModel? initialPlace;

  const MapScreen({super.key, this.initialCenter, this.initialPlace});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;

  late LatLng _center;
  bool _loadingLocation = true;
  String? _locationMessage;
  PlaceModel? _selectedPlace;

  @override
  void initState() {
    super.initState();
    _center = widget.initialCenter ?? _defaultCenter;
    _selectedPlace = widget.initialPlace;
    if (widget.initialCenter != null) {
      _loadingLocation = false;
      Future.microtask(() => _loadNearby(_center));
    } else {
      Future.microtask(_initLocation);
    }
  }

  Future<void> _initLocation() async {
    final result = await _locationService.getCurrentLocation();

    switch (result.status) {
      case LocationStatus.granted:
        final pos = result.position!;
        setState(() {
          _center = LatLng(pos.latitude, pos.longitude);
          _loadingLocation = false;
          _locationMessage = null;
        });
        _animateTo(_center);
        _loadNearby(_center);
        break;
      case LocationStatus.denied:
        setState(() {
          _loadingLocation = false;
          _locationMessage =
          'Location permission denied. You can still search places manually.';
        });
        _loadNearby(_center);
        break;
      case LocationStatus.deniedForever:
        setState(() {
          _loadingLocation = false;
          _locationMessage =
          'Location permission is permanently denied. Enable it in Settings, or search manually.';
        });
        _loadNearby(_center);
        break;
      case LocationStatus.serviceDisabled:
        setState(() {
          _loadingLocation = false;
          _locationMessage = 'Location services are turned off. You can still search places manually.';
        });
        _loadNearby(_center);
        break;
    }
  }

  void _loadNearby(LatLng center) {
    ref.read(nearbyPlacesProvider.notifier).load(lat: center.latitude, lng: center.longitude);
  }

  void _animateTo(LatLng target) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 14));
  }

  Set<Marker> _buildMarkers(List<PlaceModel> places) {
    return places.map((place) {
      return Marker(
        markerId: MarkerId(place.id),
        position: LatLng(place.latitude, place.longitude),
        infoWindow: InfoWindow(title: place.name, snippet: place.address),
        onTap: () => setState(() => _selectedPlace = place),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(nearbyPlacesProvider);
    final places = placesAsync.value ?? [];

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _center, zoom: 14),
          onMapCreated: (controller) => _mapController = controller,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: _buildMarkers(places),
          onTap: (_) => setState(() => _selectedPlace = null),
        ),

        if (Navigator.of(context).canPop())
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF0F172A), size: 22),
                ),
              ),
            ),
          ),

        if (_loadingLocation)
          const Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(child: CircularProgressIndicator()),
          ),

        if (_locationMessage != null)
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: _InfoBanner(message: _locationMessage!, onDismiss: () {
              setState(() => _locationMessage = null);
            }),
          ),

        if (placesAsync is AsyncError)
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: _InfoBanner(
              message: 'Could not load nearby places. Check your connection.',
              onDismiss: () {},
            ),
          ),

        Positioned(
          bottom: _selectedPlace != null ? 180 : 24,
          right: 16,
          child: FloatingActionButton.small(
            heroTag: 'recenter',
            backgroundColor: Colors.white,
            onPressed: _initLocation,
            child: const Icon(Icons.my_location, color: AppColors.primary),
          ),
        ),

        if (_selectedPlace != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _PlacePreviewSheet(
              place: _selectedPlace!,
              onClose: () => setState(() => _selectedPlace = null),
            ),
          ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;
  const _InfoBanner({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 18, color: AppColors.warning),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 13))),
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlacePreviewSheet extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onClose;
  const _PlacePreviewSheet({required this.place, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(place.name,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: onClose),
            ],
          ),
          Row(
            children: [
              if (place.hasReviews) ...[
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${place.rating.toStringAsFixed(1)} (${place.reviewCount})'),
              ] else
                const Text('No reviews yet'),
              const SizedBox(width: 12),
              if (place.verified)
                const Icon(Icons.verified, size: 16, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 4),
          Text(place.address, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DirectionsScreen(
                          destinationName: place.name,
                          destinationLat: place.latitude,
                          destinationLng: place.longitude,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Directions'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => PlaceDetailsScreen(placeId: place.id)),
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('View Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
