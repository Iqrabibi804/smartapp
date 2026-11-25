import 'dart:math' as math;

import 'package:dio/dio.dart';

import '../../../core/offline/offline_cache.dart';
import '../models/place_model.dart';

/// Free OpenStreetMap POI lookup. OSM is map data, not live operating status.
class OsmFacilitiesService {
  OsmFacilitiesService()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 18),
          receiveTimeout: const Duration(seconds: 25),
          sendTimeout: const Duration(seconds: 18),
          headers: const {'User-Agent': 'SmartMapPunjab/1.0 (free OSM facilities search)'},
        ));

  final Dio _dio;

  static const _cityBounds = <String, String>{
    'Attock': '33.70,72.10,34.05,72.55',
    'Lahore': '31.30,74.00,31.75,74.55',
    'Rawalpindi': '33.45,72.75,33.80,73.20',
    'Islamabad': '33.55,72.85,33.85,73.25',
    'Multan': '29.90,71.25,30.30,71.65',
    'Sahiwal': '30.55,72.95,30.80,73.20',
    'Murree': '33.80,73.30,34.10,73.60',
    'Faisalabad': '31.20,72.85,31.65,73.25',
    'Gujranwala': '32.05,74.05,32.30,74.35',
  };

  static const _filters = <String, String>{
    'Hospitals': 'nwr["amenity"="hospital"]',
    'Pharmacies': 'nwr["amenity"="pharmacy"]',
    'Petrol pumps': 'nwr["amenity"="fuel"]',
    'ATMs': 'nwr["amenity"="atm"]',
    'Police': 'nwr["amenity"="police"]',
    'Parks': 'nwr["leisure"="park"]',
    'Parking': 'nwr["amenity"="parking"]',
    'Restaurants': 'nwr["amenity"~"^(restaurant|fast_food|cafe)$"]',
    'Washrooms': 'nwr["amenity"="toilets"]',
    'Drinking water': 'nwr["amenity"="drinking_water"]',
  };

  Future<List<PlaceModel>> fetchCity(String city, String category) async {
    final bounds = _cityBounds[city];
    final filter = _filters[category];
    if (bounds == null || filter == null) return const [];
    final cacheKey = 'osm:facilities:$city:$category';
    final query = '[out:json][timeout:25];($filter($bounds););out center tags;';
    try {
      final response = await _dio.post<dynamic>(
        'https://overpass-api.de/api/interpreter',
        data: {'data': query},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final elements = (response.data is Map ? response.data['elements'] : null) as List? ?? const [];
      final places = elements
          .whereType<Map>()
          .map((e) => _fromElement(Map<String, dynamic>.from(e), city, category))
          .whereType<PlaceModel>()
          .toList();
      places.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      if (places.isNotEmpty) {
        OfflineCache.instance.reportOnline();
        await OfflineCache.instance.put(
          cacheKey,
          places.map(_toCache).toList(),
          ttl: const Duration(hours: 12),
        );
        return places;
      }
      // Empty result can be a valid query, but use cached data if present.
    } catch (_) {
      OfflineCache.instance.reportOffline();
    }
    final cached = OfflineCache.instance.read(cacheKey);
    if (cached is List) {
      try {
        return cached.map((e) => PlaceModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      } catch (_) {}
    }
    return const [];
  }

  PlaceModel? _fromElement(Map<String, dynamic> element, String city, String category) {
    final tags = Map<String, dynamic>.from(element['tags'] as Map? ?? const {});
    final center = element['center'] as Map?;
    final lat = (element['lat'] as num?)?.toDouble() ?? (center?['lat'] as num?)?.toDouble() ?? 0;
    final lon = (element['lon'] as num?)?.toDouble() ?? (center?['lon'] as num?)?.toDouble() ?? 0;
    final name = (tags['name'] ?? tags['name:en'] ?? tags['operator'] ?? '').toString().trim();
    if (name.isEmpty || lat == 0 || lon == 0) return null;
    final street = [tags['addr:street'], tags['addr:housenumber'], tags['addr:suburb'], tags['addr:neighbourhood']]
        .where((v) => v != null && v.toString().trim().isNotEmpty).join(' ');
    final address = [street, tags['addr:city'] ?? city, tags['addr:state'] ?? 'Punjab / Pakistan']
        .where((v) => v.toString().trim().isNotEmpty).join(', ');
    final hours = <String, String>{};
    if (tags['opening_hours'] != null) hours['Listed hours'] = tags['opening_hours'].toString();
    final fee = (tags['fee'] ?? '').toString().toLowerCase();
    final price = fee == 'no' ? 'Free' : fee == 'yes' ? 'Paid (fee listed; amount not specified)' : 'Not listed';
    final phone = (tags['phone'] ?? tags['contact:phone'])?.toString();
    final id = 'osm:${element['type']}:${element['id']}';
    return PlaceModel(
      id: id, name: name, description: 'OpenStreetMap mapped place. Operating status is not verified live.',
      latitude: lat, longitude: lon, address: address, city: city,
      rating: 0, reviewCount: 0, priceRange: price, images: const [],
      verified: false, verificationStatus: null, source: 'OpenStreetMap · map data',
      featured: false, phone: phone, website: tags['website']?.toString(),
      openingHours: hours, categoryName: category,
    );
  }

  Map<String, dynamic> _toCache(PlaceModel p) => {
    'id': p.id, 'name': p.name, 'description': p.description,
    'location': {'coordinates': [p.longitude, p.latitude]},
    'address': p.address, 'city': p.city, 'rating': p.rating,
    'reviewCount': p.reviewCount, 'priceRange': p.priceRange,
    'images': p.images, 'verified': p.verified, 'verificationStatus': p.verificationStatus,
    'source': p.source, 'featured': p.featured, 'phone': p.phone, 'website': p.website,
    'openingHours': p.openingHours, 'categoryId': {'name': p.categoryName},
  };

  static double distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const radius = 6371.0;
    const radians = math.pi / 180;
    final dLat = (lat2 - lat1) * radians;
    final dLon = (lon2 - lon1) * radians;
    final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * radians) * math.cos(lat2 * radians) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    return 2 * radius * math.asin(math.min(1, math.sqrt(h)));
  }
}
