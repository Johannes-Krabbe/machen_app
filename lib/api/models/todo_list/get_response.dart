// generated with https://javiercbk.github.io/json_to_dart/

import 'package:machen_app/api/models/todo_list/todo_list_model.dart';

class ListsGetResponse {
  bool? success;
  String? messsage;
  String? code;

  List<TodoListModel>? lists;

  ListsGetResponse({
    this.success,
    this.messsage,
    this.code,
  });

  ListsGetResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    messsage = json['message'];
    code = json['code'];

    if (json['lists'] != null) {
      lists = <TodoListModel>[];
      json['lists'].forEach((v) {
        lists!.add(TodoListModel.fromJson(v));
      });
    }
  }
}
