import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/state/types/todo_list_state.dart';

// Events

sealed class TodoListEvent {}

final class TodoListFetchEvent extends TodoListEvent {
  final String todoListId;

  TodoListFetchEvent(this.todoListId);
}

final class TodoListAddEvent extends TodoListEvent {
  final String title;

  TodoListAddEvent(this.title);
}

final class TodoListDeleteEvent extends TodoListEvent {
  final String id;

  TodoListDeleteEvent(this.id);
}

final class TodoListToggleEvent extends TodoListEvent {
  final String id;

  TodoListToggleEvent(this.id);
}

// Bloc

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListState(id: '', items: [])) {
    on<TodoListFetchEvent>((event, emit) async {
      await _onFetch(event, emit);
    });

    on<TodoListAddEvent>((event, emit) async {
      await _onAdd(event, emit);
    });

    on<TodoListDeleteEvent>((event, emit) async {
      await _onDelete(event, emit);
    });

    on<TodoListToggleEvent>((event, emit) async {
      await _onToggle(event, emit);
    });
  }

  _onFetch(TodoListFetchEvent event, Emitter<TodoListState> emit) async {
    print("fetching todo list with id: ${event.todoListId}");
  }

  _onAdd(TodoListAddEvent event, Emitter<TodoListState> emit) async {
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

  _onDelete(TodoListDeleteEvent event, Emitter<TodoListState> emit) async {
    emit(state.copyWith(
      items: state.items.where((item) => item.id != event.id).toList(),
    ));
  }

  _onToggle(TodoListToggleEvent event, Emitter<TodoListState> emit) async {
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
