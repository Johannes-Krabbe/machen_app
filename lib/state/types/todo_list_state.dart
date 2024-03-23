class TodoListState {
  final String id;
  final List<TodoItemState> items;

  TodoListState({
    required this.id,
    required this.items,
  });

  TodoListState copyWith({
    List<TodoItemState>? items,
  }) {
    return TodoListState(
      items: items ?? this.items,
      id: id,
    );
  }
}

class TodoItemState {
  final String title;
  final bool isDone;
  final String id;

  TodoItemState({
    required this.title,
    required this.id,
    this.isDone = false,
  });

  TodoItemState copyWith({
    String? title,
    bool? isDone,
  }) {
    return TodoItemState(
      title: title ?? this.title,
      id: id,
      isDone: isDone ?? this.isDone,
    );
  }
}
