// ignore: constant_identifier_names
enum PermissionRole { OWNER, EDITOR, VIEWER }

class ListPermissionModel {
  String? id;
  String? createdAt;
  String? listId;
  String? userId;
  PermissionRole? role;

  ListPermissionModel(
      {this.id, this.createdAt, this.listId, this.userId, this.role});

  ListPermissionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    listId = json['listId'];
    userId = json['userId'];
    role = json['role'] == 'OWNER'
        ? PermissionRole.OWNER
        : json['role'] == 'EDITOR'
            ? PermissionRole.EDITOR
            : PermissionRole.VIEWER;
  }
}
