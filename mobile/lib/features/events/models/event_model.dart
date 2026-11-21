class EventModel {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String organizer;
  final String ticketInfo;
  final String? image;

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.organizer,
    required this.ticketInfo,
    this.image,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final coords = (json['location']?['coordinates'] as List<dynamic>?) ?? [0, 0];
    return EventModel(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      longitude: (coords.isNotEmpty ? coords[0] : 0).toDouble(),
      latitude: (coords.length > 1 ? coords[1] : 0).toDouble(),
      address: json['address'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      organizer: json['organizer'] as String? ?? '',
      ticketInfo: json['ticketInfo'] as String? ?? 'Free entry',
      image: json['image'] as String?,
    );
  }
}
