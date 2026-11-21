import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/trip_model.dart';

class TripsService {
  TripsService(this._apiClient);
  final ApiClient _apiClient;

  Future<TripModel> create({
    required String destination,
    required int days,
    required int travelers,
    double budget = 0,
    List<String> interests = const [],
  }) async {
    final response = await _apiClient.dio.post('/trips', data: {
      'destination': destination,
      'days': days,
      'travelers': travelers,
      'budget': budget,
      'interests': interests,
    });
    return TripModel.fromJson(response.data['trip'] as Map<String, dynamic>);
  }

  Future<List<TripModel>> getAll() async {
    final response = await _apiClient.dio.get('/trips');
    return (response.data['trips'] as List<dynamic>)
        .map((json) => TripModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> delete(String tripId) async {
    await _apiClient.dio.delete('/trips/$tripId');
  }
}

final tripsServiceProvider = Provider<TripsService>((ref) {
  return TripsService(ApiClient.instance);
});

final myTripsProvider = FutureProvider<List<TripModel>>((ref) {
  return ref.watch(tripsServiceProvider).getAll();
});
