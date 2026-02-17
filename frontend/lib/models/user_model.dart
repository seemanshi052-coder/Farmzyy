/// User model for storing user data
class User {
  final String userId;
  final String? phone;
  final String? email;
  final String? name;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.userId,
    this.phone,
    this.email,
    this.name,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  /// Create User from JSON response
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? json['id'] ?? '',
      phone: json['phone'],
      email: json['email'],
      name: json['name'],
      profileImage: json['profile_image'] ?? json['avatar'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  /// Convert User to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'phone': phone,
      'email': email,
      'name': name,
      'profile_image': profileImage,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Copy with method for creating modified instances
  User copyWith({
    String? userId,
    String? phone,
    String? email,
    String? name,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(userId: $userId, phone: $phone, name: $name)';
  }
}

/// Auth response model
class AuthResponse {
  final String accessToken;
  final String userId;
  final User? user;

  AuthResponse({
    required this.accessToken,
    required this.userId,
    this.user,
  });

  /// Create AuthResponse from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? json['token'] ?? '',
      userId: json['user_id'] ?? json['id'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'user_id': userId,
      'user': user?.toJson(),
    };
  }

  @override
  String toString() {
    return 'AuthResponse(accessToken: $accessToken, userId: $userId)';
  }
}
