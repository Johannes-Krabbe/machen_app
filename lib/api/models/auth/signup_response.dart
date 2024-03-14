// generated with https://javiercbk.github.io/json_to_dart/

import 'package:machen_app/api/models/auth/me_model.dart';

class SignupResponse {
  bool? success;
  String? messsage;
  String? code;
  String? token;
  MeUser? user;

  SignupResponse(
      {this.success, this.messsage, this.code, this.token, this.user});

  SignupResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? !json['error'];
    messsage = json['message'];
    code = json['code'];
    token = json['token'];
    user = json['user'] != null ? MeUser.fromJson(json['user']) : null;
  }
}
