import 'dart:math' as math;

import '../../../core/data/punjab_offline_data.dart';
import '../../../core/offline/offline_cache.dart';
import '../../../core/services/api_client.dart';
import '../models/place_model.dart';

class PlacesService {
  PlacesService(this._apiClient);
  final ApiClient _apiClient;

  Future<List<PlaceModel>> getNearby({
    required double lat,
    required double lng,
    double radiusKm = 5,
  }) async {
    final cache = OfflineCache.instance;
    final key = 'nearby:${lat.toStringAsFixed(2)}:${lng.toStringAsFixed(2)}:${radiusKm.toStringAsFixed(1)}';
    try {
      final response = await _apiClient.dio.get(
        '/places/nearby',
        queryParameters: {'lat': lat, 'lng': lng, 'radiusKm': radiusKm},
      );

      final raw = response.data['places'] as List<dynamic>;
      final places = raw
          .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
          .toList();
      if (places.isNotEmpty) {
        cache.reportOnline();
        await cache.put(key, raw, ttl: const Duration(hours: 6));
        return places;
      }
    } catch (_) {
      // Offline fallbacks below.
    }

    cache.reportOffline();
    final cached = _parsePlaces(cache.read(key));
    if (cached.isNotEmpty) return cached;

    // Bundled fallback: only places actually within the radius, computed from
    // the bundled coordinates. Never label arbitrary places "nearby".
    return PunjabOfflineData.places
        .where((p) => _distanceKm(lat, lng, p.latitude, p.longitude) <= radiusKm)
        .toList();
  }

  static double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;
    const toRad = math.pi / 180;
    final dLat = (lat2 - lat1) * toRad;
    final dLon = (lon2 - lon1) * toRad;
    final sinLat = math.sin(dLat / 2);
    final sinLon = math.sin(dLon / 2);
    final h = sinLat * sinLat +
        math.cos(lat1 * toRad) * math.cos(lat2 * toRad) * sinLon * sinLon;
    return 2 * earthRadiusKm * math.asin(math.min(1, math.sqrt(h)));
  }

  Future<List<PlaceModel>> search({
    String? query,
    String? categoryId,
    String? categoryName,
    String? city,
    double? minRating,
    String? priceRange,
    double? lat,
    double? lng,
    double radiusKm = 25,
    String? sort,
  }) async {
    final cache = OfflineCache.instance;
    final key = _searchKey(
      query: query,
      categoryId: categoryId,
      categoryName: categoryName,
      city: city,
      minRating: minRating,
      priceRange: priceRange,
      sort: sort,
    );

    try {
      final response = await _apiClient.dio.get(
        '/places/search',
        queryParameters: {
          if (query != null && query.isNotEmpty) 'q': query,
          if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
          if (categoryName != null && categoryName.isNotEmpty) 'categoryName': categoryName,
          if (city != null && city.isNotEmpty && city != 'All Cities') 'city': city,
          if (minRating != null) 'minRating': minRating,
          if (priceRange != null) 'priceRange': priceRange,
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
          if (lat != null && lng != null) 'radiusKm': radiusKm,
          if (sort != null) 'sort': sort,
        },
      );

      final raw = response.data['places'] as List<dynamic>;
      final places = raw
          .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
          .toList();
      if (places.isNotEmpty) {
        cache.reportOnline();
        await cache.put(key, raw);
        return places;
      }
    } catch (_) {
      // Offline fallbacks below.
    }

    cache.reportOffline();
    final cached = _parsePlaces(cache.read(key));
    if (cached.isNotEmpty) return cached;

    // Seamless offline search over the bundled dataset.
    final results = PunjabOfflineData.filterPlaces(
      query: query,
      categoryId: categoryId,
      categoryName: categoryName,
      city: city,
      minRating: minRating,
      sort: sort,
    );

    // If filter produced nothing but a category was specified, show category places
    if (results.isEmpty && (categoryName != null || city != null)) {
      return PunjabOfflineData.filterPlaces(city: city, categoryName: categoryName);
    }

    return results.isNotEmpty ? results : PunjabOfflineData.places;
  }

  static String _searchKey({
    String? query,
    String? categoryId,
    String? categoryName,
    String? city,
    double? minRating,
    String? priceRange,
    String? sort,
  }) {
    return 'search:${query ?? ''}|${categoryId ?? ''}|${categoryName ?? ''}|'
        '${city ?? ''}|${minRating ?? ''}|${priceRange ?? ''}|${sort ?? ''}';
  }

  static List<PlaceModel> _parsePlaces(Object? raw) {
    if (raw is! List) return const [];
    try {
      return raw
          .map((e) => PlaceModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<PlaceDetailsResult> getById(String id) async {
    final cache = OfflineCache.instance;
    final key = 'place:$id';
    try {
      final response = await _apiClient.dio.get('/places/$id');
      final placeJson = response.data['place'] as Map<String, dynamic>;
      final relatedJson = response.data['related'] as List<dynamic>? ?? [];
      final place = PlaceModel.fromJson(placeJson);
      final related = relatedJson
          .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
          .toList();
      cache.reportOnline();
      await cache.put(key, {'place': placeJson, 'related': relatedJson});
      return PlaceDetailsResult(place: place, related: related);
    } catch (_) {
      // Offline fallback.
    }

    cache.reportOffline();
    final cached = cache.read(key);
    if (cached is Map && cached['place'] is Map) {
      try {
        final place = PlaceModel.fromJson(Map<String, dynamic>.from(cached['place'] as Map));
        final related = cached['related'] is List
            ? (cached['related'] as List)
                .map((e) => PlaceModel.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList()
            : <PlaceModel>[];
        return PlaceDetailsResult(place: place, related: related);
      } catch (_) {}
    }

    // Bundled fallback: return the matching record, or fail honestly instead
    // of silently showing a different place.
    final matches = PunjabOfflineData.places.where(
      (p) => p.id == id || p.name.toLowerCase() == id.toLowerCase(),
    );
    if (matches.isEmpty) {
      throw StateError('This place is not available offline.');
    }
    final place = matches.first;
    final related = PunjabOfflineData.places
        .where((p) => p.id != place.id && (p.categoryName == place.categoryName || p.address.contains(place.address.split(',').first)))
        .take(4)
        .toList();
    return PlaceDetailsResult(place: place, related: related);
  }
}

class PlaceDetailsResult {
  final PlaceModel place;
  final List<PlaceModel> related;
  PlaceDetailsResult({required this.place, required this.related});
}
