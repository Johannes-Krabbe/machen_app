import 'package:flutter/material.dart';
import 'package:machen_app/components/input_tile.dart';
import 'package:machen_app/components/multi_line_input_tile.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:machen_app/state/blocs/todo_list_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/state/blocs/todo_lists_bloc.dart';
import 'package:machen_app/state/types/todo_list_state.dart';

class ListSettingsScreen extends StatefulWidget {
  final String? todoListId;

  const ListSettingsScreen({Key? key, required this.todoListId})
      : super(key: key);

  @override
  State<ListSettingsScreen> createState() => _ListSettingsScreenState();
}

class _ListSettingsScreenState extends State<ListSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.todoListId != context.read<TodoListBloc>().state.list?.id &&
        widget.todoListId != null) {
      var authBloc = context.read<AuthBloc>();
      context
          .read<TodoListBloc>()
          .add(TodoListFetchEvent(authBloc.state.token, widget.todoListId!));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${(context.watch<TodoListBloc>().state.list?.name ?? '')} Settings',
        ),
      ),
      body: Builder(builder: (context) {
        if (widget.todoListId == null) {
          return const Center(
            child: Text('No list selected'),
          );
        }
        return BlocListener<TodoListBloc, TodoListState>(
          listenWhen: (previous, current) {
            if (previous.list?.name != current.list?.name ||
                previous.list?.description != current.list?.description) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
            context.read<TodoListsBloc>().add(
                  TodoListsUpdatedListEvent(state.list!),
                );
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                InputTile(
                  title: 'Name',
                  value: context.watch<TodoListBloc>().state.list?.name ?? '',
                  updateFunc: (String value) async {
                    var oldName = context.read<TodoListBloc>().state.list?.name;
                    if (oldName != value) {
                      context.read<TodoListBloc>().add(
                            TodoListUpdateListEvent(
                              context.read<AuthBloc>().state.token,
                              value,
                              null,
                            ),
                          );
                    }
                  },
                ),
                const SizedBox(height: 20),
                MultiLineInputTile(
                  title: "Description",
                  value:
                      context.watch<TodoListBloc>().state.list?.description ??
                          '',
                  updateFunc: (String value) async {
                    context.read<TodoListBloc>().add(
                          TodoListUpdateListEvent(
                            context.read<AuthBloc>().state.token,
                            null,
                            value,
                          ),
                        );
                  },
                ),
                const Spacer(),
                SafeArea(
                  child: TextButton(
                    onPressed: () {
                      if (context.watch<TodoListBloc>().state.list?.deletable ==
                          false) {
                        return;
                      }
                      context.read<TodoListBloc>().add(
                            TodoListDeleteListEvent(
                                context.read<AuthBloc>().state.token),
                          );
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Delete List',
                      style: TextStyle(
                          fontSize: 25,
                          color: context
                                      .read<TodoListBloc>()
                                      .state
                                      .list
                                      ?.deletable ==
                                  false
                              ? Colors.grey
                              : Colors.red),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
