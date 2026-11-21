import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/punjab_offline_data.dart';
import '../../../core/services/api_client.dart';
import '../models/category_model.dart';

class CategoriesService {
  CategoriesService(this._apiClient);
  final ApiClient _apiClient;

  Future<List<CategoryModel>> getAll() async {
    try {
      final response = await _apiClient.dio.get('/categories');
      final list = (response.data['categories'] as List<dynamic>)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) return list;
    } catch (_) {
      // Offline fallback
    }
    return PunjabOfflineData.categories;
  }
}

final categoriesServiceProvider = Provider<CategoriesService>((ref) {
  return CategoriesService(ApiClient.instance);
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) {
  return ref.watch(categoriesServiceProvider).getAll();
});
