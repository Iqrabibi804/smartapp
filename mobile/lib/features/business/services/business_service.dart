import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/business_model.dart';

class BusinessService {
  BusinessService(this._apiClient);
  final ApiClient _apiClient;

  Future<BusinessModel> submit({
    required String name,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
    String? phone,
    String? website,
    String priceRange = 'medium',
  }) async {
    final response = await _apiClient.dio.post('/businesses', data: {
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (website != null && website.isNotEmpty) 'website': website,
      'priceRange': priceRange,
    });
    return BusinessModel.fromJson(response.data['business'] as Map<String, dynamic>);
  }

  Future<List<BusinessModel>> getMine() async {
    final response = await _apiClient.dio.get('/businesses/mine');
    return (response.data['businesses'] as List<dynamic>)
        .map((json) => BusinessModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

final businessServiceProvider = Provider<BusinessService>((ref) {
  return BusinessService(ApiClient.instance);
});

final myBusinessesProvider = FutureProvider<List<BusinessModel>>((ref) {
  return ref.watch(businessServiceProvider).getMine();
});
