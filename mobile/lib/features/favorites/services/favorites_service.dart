import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../../places/models/place_model.dart';

class FavoritesService {
  FavoritesService(this._apiClient);
  final ApiClient _apiClient;

  Future<List<PlaceModel>> getAll() async {
    try {
      final response = await _apiClient.dio.get('/favorites');
      return (response.data['places'] as List<dynamic>)
          .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(String placeId) async {
    try {
      await _apiClient.dio.post('/favorites', data: {'placeId': placeId});
    } catch (_) {}
  }

  Future<void> remove(String placeId) async {
    try {
      await _apiClient.dio.delete('/favorites/$placeId');
    } catch (_) {}
  }
}

final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService(ApiClient.instance);
});

class FavoritesController extends StateNotifier<AsyncValue<Set<String>>> {
  FavoritesController(this._service) : super(const AsyncValue.data({})) {
    refresh();
  }

  final FavoritesService _service;
  List<PlaceModel> _places = [];

  List<PlaceModel> get places => _places;

  Future<void> refresh() async {
    try {
      _places = await _service.getAll();
      state = AsyncValue.data(_places.map((p) => p.id).toSet());
    } catch (_) {
      state = const AsyncValue.data({});
    }
  }

  bool isSaved(String placeId) => state.value?.contains(placeId) ?? false;

  Future<void> toggle(PlaceModel place) async {
    final current = state.value ?? {};
    if (current.contains(place.id)) {
      state = AsyncValue.data({...current}..remove(place.id));
      _places = _places.where((p) => p.id != place.id).toList();
      await _service.remove(place.id);
    } else {
      state = AsyncValue.data({...current, place.id});
      _places = [place, ..._places];
      await _service.save(place.id);
    }
  }
}

final favoritesControllerProvider =
StateNotifierProvider<FavoritesController, AsyncValue<Set<String>>>((ref) {
  return FavoritesController(ref.watch(favoritesServiceProvider));
});
