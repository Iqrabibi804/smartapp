import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

/// Thin wrapper around Dio so every feature service (auth, places, etc.)
/// shares one configured HTTP client instead of constructing its own.
/// Keeps the JWT out of app-visible storage by using flutter_secure_storage
/// (Keystore/Keychain-backed) rather than SharedPreferences.
class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 3),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: ApiConstants.secureStorageTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Centralized place to react to 401s (e.g. force logout) once
          // a session/auth provider exists to call back into.
          handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();

  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Dio get dio => _dio;

  Future<void> saveToken(String token) =>
      _storage.write(key: ApiConstants.secureStorageTokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: ApiConstants.secureStorageTokenKey);

  Future<void> clearToken() => _storage.delete(key: ApiConstants.secureStorageTokenKey);
}

/// Normalizes Dio errors into a plain, user-presentable message so UI code
/// doesn't need to know about DioException internals (spec section 57).
String friendlyErrorMessage(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'The request timed out. Please check your connection and try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
  return 'An unexpected error occurred.';
}
