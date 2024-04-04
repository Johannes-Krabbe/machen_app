import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/api/models/todo_list/todo_list_item_model.dart';
import 'package:machen_app/api/repositories/todo_list_repository.dart';
import 'package:machen_app/state/types/todo_list_state.dart';

// Events

sealed class TodoListEvent {}

final class TodoListFetchEvent extends TodoListEvent {
  final String token;
  final String todoListId;

  TodoListFetchEvent(this.token, this.todoListId);
}

final class TodoListAddEvent extends TodoListEvent {
  final String token;
  final String title;

  TodoListAddEvent(this.token, this.title);
}

final class TodoListDeleteEvent extends TodoListEvent {
  final String token;
  final String id;

  TodoListDeleteEvent(this.token, this.id);
}

final class TodoListToggleEvent extends TodoListEvent {
  final String token;
  final String id;

  TodoListToggleEvent(this.token, this.id);
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
    var getListResponse =
        await TodoListRepository().getList(event.token, event.todoListId);

    if (getListResponse.success == true && getListResponse.list != null) {
      emit(state.copyWith(
        items: getListResponse.list!.listItems,
      ));
    }
  }

  _onAdd(TodoListAddEvent event, Emitter<TodoListState> emit) async {
    if (event.title.isEmpty ||
        RegExp(r"^\s*$").firstMatch(event.title) != null) {
      return;
    }
    emit(state.copyWith(
      items: [
        ...state.items,
        TodoListItemModel(title: event.title, id: DateTime.now().toString()),
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
          return item.copyWith(completed: !(item.completed ?? true));
        }
        return item;
      }).toList(),
    ));
  }
}
