import 'package:machen_app/api/models/todo_list/todo_list_item_model.dart';

class TodoListState {
  final String id;
  final List<TodoListItemModel> items;

  TodoListState({
    required this.id,
    required this.items,
  });

  TodoListState copyWith({
    List<TodoListItemModel>? items,
  }) {
    return TodoListState(
      items: items ?? this.items,
      id: id,
    );
  }
}
