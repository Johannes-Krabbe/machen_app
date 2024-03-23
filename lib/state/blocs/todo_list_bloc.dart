import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/state/types/todo_list_state.dart';

// Events

sealed class TodoListEvent {}

final class FetchTodoListEvent extends TodoListEvent {
  final String listId;

  FetchTodoListEvent(this.listId);
}

final class AddTodoEvent extends TodoListEvent {
  final String title;

  AddTodoEvent(this.title);
}

final class DeleteTodoEvent extends TodoListEvent {
  final String id;

  DeleteTodoEvent(this.id);
}

final class ToggleTodoEvent extends TodoListEvent {
  final String id;

  ToggleTodoEvent(this.id);
}

// Bloc

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListState(id: '', items: [])) {
    on<AddTodoEvent>((event, emit) async {
      await _onAdd(event, emit);
    });

    on<DeleteTodoEvent>((event, emit) async {
      await _onDelete(event, emit);
    });

    on<ToggleTodoEvent>((event, emit) async {
      await _onToggle(event, emit);
    });
  }

  _onAdd(AddTodoEvent event, Emitter<TodoListState> emit) async {
    if (event.title.isEmpty ||
        RegExp(r"^\s*$").firstMatch(event.title) != null) {
      return;
    }
    emit(state.copyWith(
      items: [
        ...state.items,
        TodoItemState(title: event.title, id: DateTime.now().toString()),
      ],
    ));
  }

  _onDelete(DeleteTodoEvent event, Emitter<TodoListState> emit) async {
    emit(state.copyWith(
      items: state.items.where((item) => item.id != event.id).toList(),
    ));
  }

  _onToggle(ToggleTodoEvent event, Emitter<TodoListState> emit) async {
    emit(state.copyWith(
      items: state.items.map((item) {
        if (item.id == event.id) {
          return item.copyWith(isDone: !item.isDone);
        }
        return item;
      }).toList(),
    ));
  }
}
