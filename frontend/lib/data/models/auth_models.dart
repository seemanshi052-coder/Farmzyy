/// Login Request Model
class LoginRequest {
  final String phone;
  final String otp;

  LoginRequest({
    required this.phone,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'otp': otp,
    };
  }
}

/// Login Response Model
class LoginResponse {
  final String access_token;
  final String user_id;

  LoginResponse({
    required this.access_token,
    required this.user_id,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      access_token: json['access_token'] as String? ?? '',
      user_id: json['user_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': access_token,
      'user_id': user_id,
    };
  }
}

/// OTP Request Model
class OtpRequest {
  final String phone;

  OtpRequest({required this.phone});

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
    };
  }
}
