import 'package:machen_app/api/models/todo_list/todo_list_model.dart';

enum TodoListStatus { initial, loading, loaded, error }

class TodoListsState {
  final List<TodoListModel> lists;
  final TodoListStatus status;

  TodoListsState({
    required this.lists,
    required this.status,
  });

  TodoListsState copyWith({
    List<TodoListModel>? lists,
    TodoListStatus? status,
  }) {
    return TodoListsState(
      lists: lists ?? this.lists,
      status: status ?? this.status,
    );
  }
}
