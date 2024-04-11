import 'package:machen_app/api/models/todo_list/todo_list_item_model.dart';
import 'package:machen_app/api/models/todo_list/todo_list_permission_model.dart';

class TodoListModel {
  String? id;
  String? createdAt;
  String? name;
  String? description;
  bool? deletable;
  List<ListPermissionModel>? listPermissions;
  List<TodoListItemModel>? listItems;

  // Null? folderId;
  // Null? folder;

  TodoListModel({
    this.id,
    this.createdAt,
    this.name,
    this.description,
    this.deletable,
    this.listPermissions,
    this.listItems,
  });

  TodoListModel copyWith({
    String? id,
    String? createdAt,
    String? name,
    String? description,
    bool? deletable,
    List<ListPermissionModel>? listPermissions,
    List<TodoListItemModel>? listItems,
  }) {
    return TodoListModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      description: description ?? this.description,
      deletable: deletable ?? this.deletable,
      listPermissions: listPermissions ?? this.listPermissions,
      listItems: listItems ?? this.listItems,
    );
  }

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
    if (json['listItems'] != null) {
      listItems = <TodoListItemModel>[];
      json['listItems'].forEach((v) {
        listItems!.add(TodoListItemModel.fromJson(v));
      });
    }
  }
}
