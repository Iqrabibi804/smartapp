import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/ai_models.dart';

class AiService {
  AiService(this._apiClient);
  final ApiClient _apiClient;

  Future<AiResponse> recommend({required String message, double? lat, double? lng}) async {
    final response = await _apiClient.dio.post('/ai/recommend', data: {
      'message': message,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    });
    return AiResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

final aiServiceProvider = Provider<AiService>((ref) {
  return AiService(ApiClient.instance);
});

class ChatController extends StateNotifier<List<ChatMessage>> {
  ChatController(this._service)
      : super([
    ChatMessage.ai(
      "Hi! I'm Map AI. Ask me things like \"cheap restaurants near me\" or "
          '"best rated parks" and I\'ll search real places for you.',
      const [],
    ),
  ]);

  final AiService _service;
  bool sending = false;

  Future<void> send(String text, {double? lat, double? lng}) async {
    if (text.trim().isEmpty || sending) return;

    state = [...state, ChatMessage.user(text)];
    sending = true;

    try {
      final response = await _service.recommend(message: text, lat: lat, lng: lng);
      state = [...state, ChatMessage.ai(response.reply, response.recommendations)];
    } catch (_) {
      state = [
        ...state,
        ChatMessage.ai(
          "Sorry, I couldn't reach the server. Please check your connection and try again.",
          const [],
        ),
      ];
    } finally {
      sending = false;
    }
  }
}

final chatControllerProvider = StateNotifierProvider<ChatController, List<ChatMessage>>((ref) {
  return ChatController(ref.watch(aiServiceProvider));
});
