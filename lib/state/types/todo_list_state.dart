import 'package:machen_app/api/models/todo_list/todo_list_item_model.dart';
import 'package:machen_app/api/models/todo_list/todo_list_model.dart';

class TodoListState {
  final String id;
  final TodoListModel? list;
  final List<TodoListItemModel> items;

  TodoListState({
    required this.id,
    required this.items,
    this.list,
  });

  TodoListState copyWith({
    String? id,
    TodoListModel? list,
    List<TodoListItemModel>? items,
  }) {
    return TodoListState(
      items: items ?? this.items,
      list: list ?? this.list,
      id: id ?? this.id,
    );
  }
}
