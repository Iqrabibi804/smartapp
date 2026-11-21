import '../../places/models/place_model.dart';

class AiRecommendation {
  final PlaceModel place;
  final String explanation;

  AiRecommendation({required this.place, required this.explanation});

  factory AiRecommendation.fromJson(Map<String, dynamic> json) {
    return AiRecommendation(
      place: PlaceModel.fromJson(json['place'] as Map<String, dynamic>),
      explanation: json['explanation'] as String? ?? '',
    );
  }
}

class AiResponse {
  final String reply;
  final List<AiRecommendation> recommendations;

  AiResponse({required this.reply, required this.recommendations});

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      reply: json['reply'] as String? ?? '',
      recommendations: (json['recommendations'] as List<dynamic>? ?? [])
          .map((e) => AiRecommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChatMessage {
  final bool isUser;
  final String text;
  final List<AiRecommendation> recommendations;

  ChatMessage.user(this.text) : isUser = true, recommendations = const [];
  ChatMessage.ai(this.text, this.recommendations) : isUser = false;
}
