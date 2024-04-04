import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/api/repositories/todo_list_repository.dart';
import 'package:machen_app/state/types/todo_lists_state.dart';

// Events

sealed class TodoListsEvent {}

class TodoListsLoadEvent extends TodoListsEvent {
  final String token;

  TodoListsLoadEvent(this.token);
}

// Bloc

class TodoListsBloc extends Bloc<TodoListsEvent, TodoListsState> {
  TodoListsBloc() : super(TodoListsState(lists: [])) {
    on<TodoListsLoadEvent>((event, emit) async {
      await _onLoad(event, emit);
    });
  }

  _onLoad(TodoListsLoadEvent event, Emitter<TodoListsState> emit) async {
    TodoListRepository repository = TodoListRepository();
    var getListsResponse = await repository.getLists(event.token);
    if (getListsResponse.success == true) {
      emit(TodoListsState(lists: getListsResponse.lists ?? []));
    }
  }
}
