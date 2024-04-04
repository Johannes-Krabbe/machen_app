import 'package:machen_app/api/models/todo_list/todo_list_permission_model.dart';

class TodoListModel {
  String? id;
  String? createdAt;
  String? name;
  String? description;
  bool? deletable;
  List<ListPermissionModel>? listPermissions;

  // Null? folderId;
  // Null? folder;

  TodoListModel({
    this.id,
    this.createdAt,
    this.name,
    this.description,
    this.deletable,
    this.listPermissions,
  });

  TodoListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    name = json['name'];
    description = json['description'];
    deletable = json['deletable'];
    if (json['listPermissions'] != null) {
      listPermissions = <ListPermissionModel>[];
      json['listPermissions'].forEach((v) {
        listPermissions!.add(ListPermissionModel.fromJson(v));
      });
    }
  }
}
