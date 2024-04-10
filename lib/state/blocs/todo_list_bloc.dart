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

final class TodoListDeleteListEvent extends TodoListEvent {
  final String token;

  TodoListDeleteListEvent(this.token);
}

final class TodoListAddItemEvent extends TodoListEvent {
  final String token;
  final String title;

  TodoListAddItemEvent(this.token, this.title);
}

final class TodoListDeleteItemEvent extends TodoListEvent {
  final String token;
  final String id;

  TodoListDeleteItemEvent(this.token, this.id);
}

final class TodoListToggleItemEvent extends TodoListEvent {
  final String token;
  final String id;

  TodoListToggleItemEvent(this.token, this.id);
}

// Bloc

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListState(id: '', items: [], list: null)) {
    on<TodoListFetchEvent>((event, emit) async {
      await _onFetch(event, emit);
    });

    on<TodoListAddItemEvent>((event, emit) async {
      await _onAddItem(event, emit);
    });

    on<TodoListDeleteItemEvent>((event, emit) async {
      await _onDeleteItem(event, emit);
    });

    on<TodoListToggleItemEvent>((event, emit) async {
      await _onToggleItem(event, emit);
    });

    on<TodoListDeleteListEvent>((event, emit) async {
      await _onDeleteList(event, emit);
    });
  }

  _onFetch(TodoListFetchEvent event, Emitter<TodoListState> emit) async {
    emit(state.copyWith(
      id: event.todoListId,
      list: null,
    ));
    await _refetch(event.token, emit);
  }

  _onAddItem(TodoListAddItemEvent event, Emitter<TodoListState> emit) async {
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
        .createItem(event.token, state.id, event.title, '');
    if (!success) {
      emit(state.copyWith(
        items: state.items.where((item) => item.id != tempId).toList(),
      ));
    } else {
      await _refetch(event.token, emit);
    }
  }

  _onDeleteItem(
      TodoListDeleteItemEvent event, Emitter<TodoListState> emit) async {
    var tmpItem = state.items.where((item) => item.id == event.id).first;

    emit(state.copyWith(
      items: state.items.where((item) => item.id != event.id).toList(),
    ));

    var success = await TodoListRepository().deleteItem(event.token, event.id);
    if (!success) {
      emit(state.copyWith(
        items: [...state.items, tmpItem],
      ));
    }
    await _refetch(event.token, emit);
  }

  _onToggleItem(
      TodoListToggleItemEvent event, Emitter<TodoListState> emit) async {
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
        .updateItem(event.token, event.id, null, null, !completed);

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

  _onDeleteList(
      TodoListDeleteListEvent event, Emitter<TodoListState> emit) async {
    var deleteListResponse =
        await TodoListRepository().deleteList(event.token, state.id);

    if (deleteListResponse == true) {
      emit(state.copyWith(
        items: [],
        list: null,
        isDeleted: true,
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
        list: getListResponse.list,
      ));
    }
  }
}
