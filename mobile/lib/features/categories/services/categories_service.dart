import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/punjab_offline_data.dart';
import '../../../core/offline/offline_cache.dart';
import '../../../core/services/api_client.dart';
import '../models/category_model.dart';

class CategoriesService {
  CategoriesService(this._apiClient);
  final ApiClient _apiClient;

  Future<List<CategoryModel>> getAll() async {
    final cache = OfflineCache.instance;
    try {
      final response = await _apiClient.dio.get('/categories');
      final raw = response.data['categories'] as List<dynamic>;
      final list = raw
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) {
        cache.reportOnline();
        await cache.put('categories', raw);
        return list;
      }
    } catch (_) {
      // Offline fallbacks below.
    }

    cache.reportOffline();
    final cached = cache.read('categories');
    if (cached is List) {
      try {
        final parsed = cached
            .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        if (parsed.isNotEmpty) return parsed;
      } catch (_) {}
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
