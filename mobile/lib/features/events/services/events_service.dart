import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/punjab_offline_data.dart';
import '../../../core/services/api_client.dart';
import '../models/event_model.dart';

class EventsService {
  EventsService(this._apiClient);
  final ApiClient _apiClient;

  Future<List<EventModel>> getUpcoming({double? lat, double? lng, double radiusKm = 20}) async {
    try {
      final response = await _apiClient.dio.get('/events', queryParameters: {
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
        if (lat != null && lng != null) 'radiusKm': radiusKm,
      });
      final list = (response.data['events'] as List<dynamic>)
          .map((json) => EventModel.fromJson(json as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) return list;
    } catch (_) {
      // Offline fallback
    }
    return PunjabOfflineData.events;
  }

  Future<EventModel> getById(String id) async {
    try {
      final response = await _apiClient.dio.get('/events/$id');
      return EventModel.fromJson(response.data['event'] as Map<String, dynamic>);
    } catch (_) {
      // Offline fallback
      return PunjabOfflineData.events.firstWhere(
        (e) => e.id == id,
        orElse: () => throw StateError('This event is not available offline.'),
      );
    }
  }
}

final eventsServiceProvider = Provider<EventsService>((ref) {
  return EventsService(ApiClient.instance);
});

final upcomingEventsProvider = FutureProvider<List<EventModel>>((ref) {
  return ref.watch(eventsServiceProvider).getUpcoming();
});

final eventDetailsProvider = FutureProvider.family<EventModel, String>((ref, eventId) {
  return ref.watch(eventsServiceProvider).getById(eventId);
});
