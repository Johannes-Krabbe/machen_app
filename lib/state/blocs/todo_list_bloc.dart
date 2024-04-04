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
    emit(state.copyWith(
      id: event.todoListId,
    ));
    await _refetch(event.token, emit);
  }

  _onAdd(TodoListAddEvent event, Emitter<TodoListState> emit) async {
    if (event.title.isEmpty ||
        RegExp(r"^\s*$").firstMatch(event.title) != null) {
      return;
    }

    var tempId = DateTime.now().toString();

    emit(state.copyWith(
      items: [
        ...state.items,
        TodoListItemModel(title: event.title, id: tempId),
      ],
    ));

    var success = await TodoListRepository()
        .create(event.token, state.id, event.title, '');
    if (!success) {
      emit(state.copyWith(
        items: state.items.where((item) => item.id != tempId).toList(),
      ));
    } else {
      await _refetch(event.token, emit);
    }
  }

  _onDelete(TodoListDeleteEvent event, Emitter<TodoListState> emit) async {
    var tmpItem = state.items.where((item) => item.id == event.id).first;

    emit(state.copyWith(
      items: state.items.where((item) => item.id != event.id).toList(),
    ));

    var success = await TodoListRepository().delete(event.token, event.id);
    if (!success) {
      emit(state.copyWith(
        items: [...state.items, tmpItem],
      ));
    }
    await _refetch(event.token, emit);
  }

  _onToggle(TodoListToggleEvent event, Emitter<TodoListState> emit) async {
    var completed =
        (state.items.where((item) => item.id == event.id).first.completed) ??
            false;

    emit(state.copyWith(
      items: state.items.map((item) {
        if (item.id == event.id) {
          return item.copyWith(completed: !completed);
        }
        return item;
      }).toList(),
    ));

    var getListResponse = await TodoListRepository()
        .update(event.token, event.id, null, null, !completed);

    if (getListResponse == false) {
      emit(state.copyWith(
        items: state.items.map((item) {
          if (item.id == event.id) {
            return item.copyWith(completed: completed);
          }
          return item;
        }).toList(),
      ));
    }

    await _refetch(event.token, emit);
  }

  _refetch(String token, Emitter<TodoListState> emit) async {
    var getListResponse = await TodoListRepository().getList(token, state.id);

    if (getListResponse.success == true && getListResponse.list != null) {
      var completed = getListResponse.list!.listItems
          ?.where((item) => item.completed == true)
          .toList();

      var uncompleted = getListResponse.list!.listItems
          ?.where((item) => item.completed == false)
          .toList();

      completed?.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      uncompleted?.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

      emit(state.copyWith(
        items: [
          ...uncompleted ?? [],
          ...completed ?? [],
        ],
      ));
    }
  }
}
