import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/place_model.dart';
import 'places_service.dart';

final placesServiceProvider = Provider<PlacesService>((ref) {
  return PlacesService(ApiClient.instance);
});

class NearbyPlacesController extends StateNotifier<AsyncValue<List<PlaceModel>>> {
  NearbyPlacesController(this._service) : super(const AsyncValue.data([]));

  final PlacesService _service;

  Future<void> load({required double lat, required double lng, double radiusKm = 5}) async {
    state = const AsyncValue.loading();
    try {
      final places = await _service.getNearby(lat: lat, lng: lng, radiusKm: radiusKm);
      state = AsyncValue.data(places);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final nearbyPlacesProvider =
StateNotifierProvider<NearbyPlacesController, AsyncValue<List<PlaceModel>>>((ref) {
  return NearbyPlacesController(ref.watch(placesServiceProvider));
});

class SearchFilters {
  final String query;
  final String? categoryId;
  final String? categoryName;
  final String? city;
  final double? minRating;
  final String? priceRange;
  final bool? acceptsEasypaisa;
  final bool? acceptsJazzCash;
  final bool? femaleSafe;

  const SearchFilters({
    this.query = '',
    this.categoryId,
    this.categoryName,
    this.city,
    this.minRating,
    this.priceRange,
    this.acceptsEasypaisa,
    this.acceptsJazzCash,
    this.femaleSafe,
  });

  SearchFilters copyWith({
    String? query,
    String? categoryId,
    bool clearCategory = false,
    String? categoryName,
    bool clearCategoryName = false,
    String? city,
    bool clearCity = false,
    double? minRating,
    bool clearRating = false,
    String? priceRange,
    bool clearPrice = false,
    bool? acceptsEasypaisa,
    bool clearEasypaisa = false,
    bool? acceptsJazzCash,
    bool clearJazzCash = false,
    bool? femaleSafe,
    bool clearFemaleSafe = false,
  }) {
    return SearchFilters(
      query: query ?? this.query,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      categoryName: clearCategoryName ? null : (categoryName ?? this.categoryName),
      city: clearCity ? null : (city ?? this.city),
      minRating: clearRating ? null : (minRating ?? this.minRating),
      priceRange: clearPrice ? null : (priceRange ?? this.priceRange),
      acceptsEasypaisa: clearEasypaisa ? null : (acceptsEasypaisa ?? this.acceptsEasypaisa),
      acceptsJazzCash: clearJazzCash ? null : (acceptsJazzCash ?? this.acceptsJazzCash),
      femaleSafe: clearFemaleSafe ? null : (femaleSafe ?? this.femaleSafe),
    );
  }

  bool get hasActiveFilters => categoryId != null || categoryName != null || city != null || minRating != null || priceRange != null || acceptsEasypaisa == true || acceptsJazzCash == true || femaleSafe == true;
}

class SearchController extends StateNotifier<AsyncValue<List<PlaceModel>>> {
  SearchController(this._service) : super(const AsyncValue.data([]));

  final PlacesService _service;
  SearchFilters filters = const SearchFilters();

  Future<void> run({double? lat, double? lng}) async {
    state = const AsyncValue.loading();
    try {
      final places = await _service.search(
        query: filters.query,
        categoryId: filters.categoryId,
        categoryName: filters.categoryName,
        city: filters.city,
        minRating: filters.minRating,
        priceRange: filters.priceRange,
        lat: lat,
        lng: lng,
      );
      state = AsyncValue.data(places);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updateFilters(SearchFilters Function(SearchFilters) update) {
    filters = update(filters);
  }
}

final searchControllerProvider =
StateNotifierProvider<SearchController, AsyncValue<List<PlaceModel>>>((ref) {
  return SearchController(ref.watch(placesServiceProvider));
});

final placeDetailsProvider =
FutureProvider.family<PlaceDetailsResult, String>((ref, placeId) {
  return ref.watch(placesServiceProvider).getById(placeId);
});

final popularPlacesProvider = FutureProvider<List<PlaceModel>>((ref) async {
  return ref.watch(placesServiceProvider).search(sort: 'rating');
});
