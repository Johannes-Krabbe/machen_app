import 'package:flutter_bloc/flutter_bloc.dart';

enum TodoEvent { add, delete, toggle }

class Todo {
  final String title;
  final bool isDone;
  final int id;

  Todo({
    required this.title,
    required this.id,
    this.isDone = false,
  });

  Todo copyWith({
    String? title,
    bool? isDone,
  }) {
    return Todo(
      title: title ?? this.title,
      id: id,
      isDone: isDone ?? this.isDone,
    );
  }
}

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  void add(String title) {
    if (title.isEmpty || RegExp(r"^\s*$").firstMatch(title) != null) return;
    emit([
      ...state,
      Todo(
        title: title.trim(),
        id: state.isEmpty ? 0 : state[state.length - 1].id + 1,
      )
    ]);
  }

  void delete(int index) {
    emit([
      ...state.getRange(0, index),
      ...state.getRange(index + 1, state.length),
    ]);
  }

  void toggle(int index) {
    emit([
      ...state.getRange(0, index),
      state[index].copyWith(isDone: !state[index].isDone),
      ...state.getRange(index + 1, state.length),
    ]);
  }
}
