import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/api/models/todo_list/todo_list_model.dart';
import 'package:machen_app/api/repositories/todo_list_repository.dart';
import 'package:machen_app/state/types/todo_lists_state.dart';

// Events

sealed class TodoListsEvent {}

class TodoListsLoadEvent extends TodoListsEvent {
  final String token;

  TodoListsLoadEvent(this.token);
}

class TodoListsResetEvent extends TodoListsEvent {
  TodoListsResetEvent();
}

class TodoListsUpdatedListEvent extends TodoListsEvent {
  final TodoListModel list;

  TodoListsUpdatedListEvent(this.list);
}

class TodoListDeletedEvent extends TodoListsEvent {
  final String listId;

  TodoListDeletedEvent(this.listId);
}

// Bloc

class TodoListsBloc extends Bloc<TodoListsEvent, TodoListsState> {
  TodoListsBloc()
      : super(TodoListsState(lists: [], status: TodoListStatus.initial)) {
    on<TodoListsLoadEvent>((event, emit) async {
      await _onLoad(event, emit);
    });

    on<TodoListsResetEvent>((event, emit) async {
      emit(TodoListsState(lists: [], status: TodoListStatus.initial));
    });

    on<TodoListsUpdatedListEvent>((event, emit) async {
      var lists = state.lists;
      var index = lists.indexWhere((element) => element.id == event.list.id);
      if (index != -1) {
        lists[index] = event.list;
        lists.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        emit(TodoListsState(lists: lists, status: TodoListStatus.loaded));
      }
    });

    on<TodoListDeletedEvent>((event, emit) async {
      var lists = state.lists;
      var index = lists.indexWhere((element) => element.id == event.listId);
      if (index != -1) {
        lists.removeAt(index);
        lists.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        emit(TodoListsState(lists: lists, status: TodoListStatus.loaded));
      }
    });
  }

  _onLoad(TodoListsLoadEvent event, Emitter<TodoListsState> emit) async {
    emit(TodoListsState(lists: [], status: TodoListStatus.initial));
    TodoListRepository repository = TodoListRepository();
    var getListsResponse = await repository.getLists(event.token);
    if (getListsResponse.success == true) {
      getListsResponse.lists
          ?.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      emit(TodoListsState(
          lists: getListsResponse.lists ?? [], status: TodoListStatus.loaded));
    }
  }
}
