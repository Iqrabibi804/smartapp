/// Centralized API configuration. Never hardcode secrets here — only
/// the base URL, which is not sensitive. Pass real API keys (Maps, AI, etc.)
/// via --dart-define at build time, or through native platform config
/// (e.g. AndroidManifest meta-data) — never committed to source.
class ApiConstants {
  ApiConstants._();

  // Overridable at build time:
  // flutter run --dart-define=API_BASE_URL=https://your-backend.example.com/api
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000/api', // Android emulator -> localhost:5000
  );

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String places = '/places';

  static const String secureStorageTokenKey = 'smartmap_auth_token';
}
