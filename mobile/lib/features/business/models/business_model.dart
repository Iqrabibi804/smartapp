class BusinessModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final String? website;
  final String priceRange;
  final String status;
  final String? rejectionReason;

  BusinessModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.website,
    required this.priceRange,
    required this.status,
    this.rejectionReason,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    final coords = (json['location']?['coordinates'] as List<dynamic>?) ?? [0, 0];
    return BusinessModel(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      longitude: (coords.isNotEmpty ? coords[0] : 0).toDouble(),
      latitude: (coords.length > 1 ? coords[1] : 0).toDouble(),
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      priceRange: json['priceRange'] as String? ?? 'medium',
      status: json['status'] as String? ?? 'pending',
      rejectionReason: json['rejectionReason'] as String?,
    );
  }
}
