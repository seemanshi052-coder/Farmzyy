class AuthModel {
  final String user_id;
  final String access_token;

  AuthModel({required this.user_id, required this.access_token});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user_id: json['user_id'],
      access_token: json['access_token'],
    );
  }
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}
