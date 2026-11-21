class TripPlace {
  final String name;
  final String timeSlot;
  final String? placeId;

  TripPlace({required this.name, required this.timeSlot, this.placeId});

  factory TripPlace.fromJson(Map<String, dynamic> json) {
    final placeField = json['placeId'];
    return TripPlace(
      name: json['name'] as String? ?? '',
      timeSlot: json['timeSlot'] as String? ?? '',
      placeId: placeField is String ? placeField : placeField?['_id'] as String?,
    );
  }
}

class TripDay {
  final int day;
  final List<TripPlace> places;

  TripDay({required this.day, required this.places});

  factory TripDay.fromJson(Map<String, dynamic> json) {
    return TripDay(
      day: (json['day'] as num).toInt(),
      places: (json['places'] as List<dynamic>? ?? [])
          .map((p) => TripPlace.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TripModel {
  final String id;
  final String destination;
  final int days;
  final int travelers;
  final double budget;
  final List<String> interests;
  final List<TripDay> itinerary;
  final double estimatedCost;

  TripModel({
    required this.id,
    required this.destination,
    required this.days,
    required this.travelers,
    required this.budget,
    required this.interests,
    required this.itinerary,
    required this.estimatedCost,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['_id'] as String,
      destination: json['destination'] as String? ?? '',
      days: (json['days'] as num?)?.toInt() ?? 1,
      travelers: (json['travelers'] as num?)?.toInt() ?? 1,
      budget: (json['budget'] as num?)?.toDouble() ?? 0,
      interests: (json['interests'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      itinerary: (json['itinerary'] as List<dynamic>? ?? [])
          .map((d) => TripDay.fromJson(d as Map<String, dynamic>))
          .toList(),
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0,
    );
  }

  bool get overBudget => budget > 0 && estimatedCost > budget;
}
