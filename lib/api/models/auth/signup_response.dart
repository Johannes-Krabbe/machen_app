// generated with https://javiercbk.github.io/json_to_dart/

import 'package:machen_app/api/models/auth/me_model.dart';

class SignupResponse {
  bool? success;
  String? messsage;
  String? code;
  String? token;
  MeUserModel? user;

  SignupResponse(
      {this.success, this.messsage, this.code, this.token, this.user});

  SignupResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    messsage = json['message'];
    code = json['code'];
    token = json['token'];
    user = json['user'] != null ? MeUserModel.fromJson(json['user']) : null;
  }
}
