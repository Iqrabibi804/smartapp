import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/review_model.dart';

class ReviewsService {
  ReviewsService(this._apiClient);
  final ApiClient _apiClient;

  Future<List<ReviewModel>> getForPlace(String placeId) async {
    try {
      final response = await _apiClient.dio.get('/places/$placeId/reviews');
      return (response.data['reviews'] as List<dynamic>)
          .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> submit({required String placeId, required double rating, String? comment}) async {
    await _apiClient.dio.post('/reviews', data: {
      'placeId': placeId,
      'rating': rating,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
    });
  }

  Future<void> delete(String reviewId) async {
    await _apiClient.dio.delete('/reviews/$reviewId');
  }
}

final reviewsServiceProvider = Provider<ReviewsService>((ref) {
  return ReviewsService(ApiClient.instance);
});

final placeReviewsProvider =
FutureProvider.family<List<ReviewModel>, String>((ref, placeId) {
  return ref.watch(reviewsServiceProvider).getForPlace(placeId);
});
