import 'package:machen_app/api/models/todo_list/todo_list_model.dart';

class TodoListsState {
  final List<TodoListModel> lists;

  TodoListsState({
    required this.lists,
  });

  TodoListsState copyWith({
    List<TodoListModel>? lists,
  }) {
    return TodoListsState(
      lists: lists ?? this.lists,
    );
  }
}
