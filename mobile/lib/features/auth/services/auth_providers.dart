import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ApiClient.instance);
});

/// Holds the currently authenticated user (or null if logged out).
/// Screens watch this to decide navigation (splash -> home vs. onboarding).
class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  AuthController(this._authService) : super(const AsyncValue.data(null));

  final AuthService _authService;

  Future<void> restoreSession() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.currentUser();
      state = AsyncValue.data(user);
    } catch (_) {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.login(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.register(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AsyncValue.data(null);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
  return AuthController(ref.watch(authServiceProvider));
});
