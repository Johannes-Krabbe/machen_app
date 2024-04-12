import 'package:machen_app/api/models/todo_list/todo_list_item_model.dart';
import 'package:machen_app/api/models/todo_list/todo_list_model.dart';

class TodoListState {
  final String id;
  final TodoListModel? list;
  final bool isDeleted;

  TodoListState({
    required this.id,
    this.list,
    this.isDeleted = false,
  });

  TodoListState copyWith({
    String? id,
    TodoListModel? list,
    List<TodoListItemModel>? items,
    bool? isDeleted,
  }) {
    return TodoListState(
      list: list ?? this.list,
      id: id ?? this.id,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
