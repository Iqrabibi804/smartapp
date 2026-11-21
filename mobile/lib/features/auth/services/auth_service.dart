import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../models/user_model.dart';

class AuthService {
  AuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? city,
    List<String>? interests,
  }) async {
    final response = await _apiClient.dio.post(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        if (city != null) 'city': city,
        if (interests != null) 'interests': interests,
      },
    );

    final token = response.data['token'] as String;
    await _apiClient.saveToken(token);
    return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> login({required String email, required String password}) async {
    final response = await _apiClient.dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );

    final token = response.data['token'] as String;
    await _apiClient.saveToken(token);
    return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  Future<UserModel?> currentUser() async {
    final token = await _apiClient.readToken();
    if (token == null) return null;

    final response = await _apiClient.dio.get(ApiConstants.me);
    return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  Future<void> logout() => _apiClient.clearToken();
}
