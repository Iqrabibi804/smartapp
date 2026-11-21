import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../../business/models/business_model.dart';
import '../../places/models/place_model.dart';

class AdminStats {
  final int totalUsers;
  final int activeUsers;
  final int totalPlaces;
  final int verifiedBusinesses;
  final int pendingBusinesses;
  final int totalReviews;
  final int reportedReviews;
  final int totalEvents;

  AdminStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalPlaces,
    required this.verifiedBusinesses,
    required this.pendingBusinesses,
    required this.totalReviews,
    required this.reportedReviews,
    required this.totalEvents,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    int n(String key) => (json[key] as num?)?.toInt() ?? 0;
    return AdminStats(
      totalUsers: n('totalUsers'),
      activeUsers: n('activeUsers'),
      totalPlaces: n('totalPlaces'),
      verifiedBusinesses: n('verifiedBusinesses'),
      pendingBusinesses: n('pendingBusinesses'),
      totalReviews: n('totalReviews'),
      reportedReviews: n('reportedReviews'),
      totalEvents: n('totalEvents'),
    );
  }
}

class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String accountStatus;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.accountStatus,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      accountStatus: json['accountStatus'] as String? ?? 'active',
    );
  }
}

class AdminReview {
  final String id;
  final String userName;
  final String userEmail;
  final String placeName;
  final int rating;
  final String comment;
  final String status;
  final int reportCount;
  final DateTime createdAt;

  AdminReview({
    required this.id,
    required this.userName,
    required this.userEmail,
    required this.placeName,
    required this.rating,
    required this.comment,
    required this.status,
    required this.reportCount,
    required this.createdAt,
  });

  factory AdminReview.fromJson(Map<String, dynamic> json) {
    final userMap = json['userId'] is Map ? json['userId'] as Map<String, dynamic> : {};
    final placeMap = json['placeId'] is Map ? json['placeId'] as Map<String, dynamic> : {};
    return AdminReview(
      id: json['_id'] as String,
      userName: userMap['name'] as String? ?? 'Anonymous User',
      userEmail: userMap['email'] as String? ?? '',
      placeName: placeMap['name'] as String? ?? 'Unknown Place',
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      comment: json['comment'] as String? ?? '',
      status: json['status'] as String? ?? 'approved',
      reportCount: (json['reportCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class AdminService {
  AdminService(this._apiClient);
  final ApiClient _apiClient;

  Future<AdminStats> getStats() async {
    final response = await _apiClient.dio.get('/admin/stats');
    return AdminStats.fromJson(response.data['stats'] as Map<String, dynamic>);
  }

  Future<List<AdminUser>> getUsers() async {
    final response = await _apiClient.dio.get('/admin/users');
    return (response.data['users'] as List<dynamic>)
        .map((json) => AdminUser.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> setUserStatus(String userId, String accountStatus) async {
    await _apiClient.dio.put('/admin/users/$userId/status', data: {'accountStatus': accountStatus});
  }

  Future<List<BusinessModel>> getBusinesses({String? status}) async {
    final response = await _apiClient.dio.get('/businesses', queryParameters: {
      if (status != null) 'status': status,
    });
    return (response.data['businesses'] as List<dynamic>)
        .map((json) => BusinessModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> setBusinessStatus(String businessId, String status, {String? reason}) async {
    await _apiClient.dio.put('/businesses/$businessId/status', data: {
      'status': status,
      if (reason != null && reason.isNotEmpty) 'rejectionReason': reason,
    });
  }

  Future<List<AdminReview>> getReviews({bool reportedOnly = true}) async {
    final response = await _apiClient.dio.get('/admin/reviews', queryParameters: {
      if (reportedOnly) 'reported': 'true',
    });
    return (response.data['reviews'] as List<dynamic>)
        .map((json) => AdminReview.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> setReviewStatus(String reviewId, String status) async {
    await _apiClient.dio.put('/admin/reviews/$reviewId/status', data: {'status': status});
  }

  Future<List<PlaceModel>> getPlaces({String? query, bool? verified, bool? featured}) async {
    final response = await _apiClient.dio.get('/admin/places', queryParameters: {
      if (query != null && query.isNotEmpty) 'q': query,
      if (verified != null) 'verified': verified.toString(),
      if (featured != null) 'featured': featured.toString(),
    });
    return (response.data['places'] as List<dynamic>)
        .map((json) => PlaceModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> updatePlace(String placeId, Map<String, dynamic> data) async {
    await _apiClient.dio.put('/admin/places/$placeId', data: data);
  }

  Future<void> deletePlace(String placeId) async {
    await _apiClient.dio.delete('/admin/places/$placeId');
  }
}

final adminServiceProvider = Provider<AdminService>((ref) {
  return AdminService(ApiClient.instance);
});

final adminStatsProvider = FutureProvider<AdminStats>((ref) {
  return ref.watch(adminServiceProvider).getStats();
});

final adminUsersProvider = FutureProvider<List<AdminUser>>((ref) {
  return ref.watch(adminServiceProvider).getUsers();
});

final adminBusinessesProvider =
    FutureProvider.family<List<BusinessModel>, String?>((ref, status) {
  return ref.watch(adminServiceProvider).getBusinesses(status: status);
});

final adminReviewsProvider =
    FutureProvider.family<List<AdminReview>, bool>((ref, reportedOnly) {
  return ref.watch(adminServiceProvider).getReviews(reportedOnly: reportedOnly);
});

final adminPlacesProvider =
    FutureProvider.family<List<PlaceModel>, Map<String, dynamic>>((ref, filter) {
  return ref.watch(adminServiceProvider).getPlaces(
        query: filter['query'] as String?,
        verified: filter['verified'] as bool?,
        featured: filter['featured'] as bool?,
      );
});
