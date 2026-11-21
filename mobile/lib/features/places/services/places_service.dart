import '../../../core/data/punjab_offline_data.dart';
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
    try {
      final response = await _apiClient.dio.get(
        '/places/nearby',
        queryParameters: {'lat': lat, 'lng': lng, 'radiusKm': radiusKm},
      );

      final places = (response.data['places'] as List<dynamic>)
          .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
          .toList();
      if (places.isNotEmpty) return places;
    } catch (_) {
      // Offline fallback
    }

    return PunjabOfflineData.places.take(8).toList();
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

      final places = (response.data['places'] as List<dynamic>)
          .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
          .toList();
      if (places.isNotEmpty) return places;
    } catch (_) {
      // Offline fallback
    }

    // Seamless offline search
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

  Future<PlaceDetailsResult> getById(String id) async {
    try {
      final response = await _apiClient.dio.get('/places/$id');
      final place = PlaceModel.fromJson(response.data['place'] as Map<String, dynamic>);
      final related = (response.data['related'] as List<dynamic>? ?? [])
          .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return PlaceDetailsResult(place: place, related: related);
    } catch (_) {
      // Offline fallback
      final place = PunjabOfflineData.places.firstWhere(
        (p) => p.id == id || p.name.toLowerCase() == id.toLowerCase(),
        orElse: () => PunjabOfflineData.places.first,
      );
      final related = PunjabOfflineData.places
          .where((p) => p.id != place.id && (p.categoryName == place.categoryName || p.address.contains(place.address.split(',').first)))
          .take(4)
          .toList();
      return PlaceDetailsResult(place: place, related: related);
    }
  }
}

class PlaceDetailsResult {
  final PlaceModel place;
  final List<PlaceModel> related;
  PlaceDetailsResult({required this.place, required this.related});
}
