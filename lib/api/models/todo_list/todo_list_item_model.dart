// generated with https://javiercbk.github.io/json_to_dart/

class TodoListItemModel {
  String? id;
  String? createdAt;
  String? title;
  String? description;
  bool? completed;
  String? ownerId;
  String? listId;

  TodoListItemModel({
    this.id,
    this.createdAt,
    this.title,
    this.description,
    this.completed,
    this.ownerId,
    this.listId,
  });

  TodoListItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    title = json['title'];
    description = json['description'];
    completed = json['completed'];
    ownerId = json['ownerId'];
    listId = json['listId'];
  }

  TodoListItemModel copyWith({
    String? id,
    String? createdAt,
    String? title,
    String? description,
    bool? completed,
    String? ownerId,
    String? listId,
  }) {
    return TodoListItemModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      ownerId: ownerId ?? this.ownerId,
      listId: listId ?? this.listId,
    );
  }
}
