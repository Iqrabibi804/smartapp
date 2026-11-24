class PlaceModel {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final double rating;
  final int reviewCount;
  final String priceRange;
  final List<String> images;
  final bool verified;
  final String? verificationStatus; // verified | community_reported | needs_verification | unavailable
  final String? lastVerifiedAt;
  final String? source;
  final bool featured;
  final String? phone;
  final String? website;
  final List<String> facilities;
  final Map<String, String> openingHours;
  final String? categoryName;
  final List<String> paymentMethods; // e.g. ['Easypaisa', 'JazzCash', 'Cash Only', 'NBP Transfer']
  final bool isFemaleSafe;
  final bool isFamilyFriendly;
  final int? localPrice; // Fair local rate
  final int? touristPrice; // Rate tourists are often scammed with
  final String? audioGuideUrdu; // Urdu self-guided voice tour script

  bool get hasReviews => reviewCount > 0;

  /// Sensitive venue details are trusted only when verification has both
  /// source provenance and a recorded verification timestamp.
  bool get hasVerifiedDetails =>
      verified &&
      verificationStatus == 'verified' &&
      (source?.trim().isNotEmpty ?? false) &&
      DateTime.tryParse(lastVerifiedAt ?? '') != null;

  PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.city,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.images,
    required this.verified,
    this.verificationStatus,
    this.lastVerifiedAt,
    this.source,
    required this.featured,
    this.phone,
    this.website,
    this.facilities = const [],
    this.openingHours = const {},
    this.categoryName,
    this.paymentMethods = const [],
    this.isFemaleSafe = false,
    this.isFamilyFriendly = false,
    this.localPrice,
    this.touristPrice,
    this.audioGuideUrdu,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    final coords = (json['location']?['coordinates'] as List<dynamic>?) ?? [0, 0];
    final categoryField = json['categoryId'];
    final payments = (json['paymentMethods'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];

    return PlaceModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      longitude: (coords.isNotEmpty ? coords[0] : 0).toDouble(),
      latitude: (coords.length > 1 ? coords[1] : 0).toDouble(),
      address: json['address'] as String? ?? '',
      city: json['city'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      priceRange: json['priceRange'] as String? ?? 'medium',
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      verified: json['verified'] as bool? ?? false,
      verificationStatus: json['verificationStatus'] as String?,
      lastVerifiedAt: json['lastVerifiedAt']?.toString(),
      source: json['source'] as String?,
      featured: json['featured'] as bool? ?? false,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      facilities: (json['facilities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      openingHours: (json['openingHours'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
      categoryName: categoryField is Map ? categoryField['name'] as String? : null,
      paymentMethods: payments,
      isFemaleSafe: json['isFemaleSafe'] as bool? ?? false,
      isFamilyFriendly: json['isFamilyFriendly'] as bool? ?? false,
      localPrice: (json['localPrice'] as num?)?.toInt(),
      touristPrice: (json['touristPrice'] as num?)?.toInt(),
      audioGuideUrdu: json['audioGuideUrdu'] as String?,
    );
  }
}
