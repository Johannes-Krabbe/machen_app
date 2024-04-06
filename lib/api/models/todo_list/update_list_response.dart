// generated with https://javiercbk.github.io/json_to_dart/

import 'package:machen_app/api/models/todo_list/todo_list_model.dart';

class ListUpdateResponse {
  bool? success;
  String? messsage;
  String? code;

  TodoListModel? list;

  ListUpdateResponse({
    this.success,
    this.messsage,
    this.code,
    this.list,
  });

  ListUpdateResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    messsage = json['message'];
    code = json['code'];

    if (json['list'] != null) {
      list = TodoListModel.fromJson(json['list']);
    }
  }
}
