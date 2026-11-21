class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? profileImage;
  final String? city;
  final List<String> interests;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    this.city,
    this.interests = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final preferences = json['preferences'] as Map<String, dynamic>?;
    return UserModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'user',
      profileImage: json['profileImage'] as String?,
      city: json['city'] as String?,
      interests: (preferences?['interests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
