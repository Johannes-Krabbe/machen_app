// generated with https://javiercbk.github.io/json_to_dart/

import 'package:machen_app/api/models/auth/me_model.dart';

class MeResponse {
  bool? success;
  String? messsage;
  String? code;
  MeUserModel? user;

  MeResponse({this.success, this.messsage, this.code, this.user});

  MeResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    messsage = json['message'];
    code = json['code'];
    user = json['user'] != null ? MeUserModel.fromJson(json['user']) : null;
  }
}
