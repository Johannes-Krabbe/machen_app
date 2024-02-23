export 'auth_models.dart';

class MeUser {
  String? id;
  String? email;
  String? name;
  String? username;
  String? role;
  String? token;
  String? error;

  MeUser({
    this.id,
    this.email,
    this.name,
    this.username,
    this.role,
    this.token,
    this.error = '',
  });

  factory MeUser.fromJson(Map<String, dynamic> json, String token) {
    return MeUser(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      username: json['username'],
      role: json['role'],
      token: token,
    );
  }

  MeUser.withError(String errorMessage) {
    error = errorMessage;
  }
}
