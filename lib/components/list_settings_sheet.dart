import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/api/repositories/todo_list_repository.dart';
import 'package:machen_app/components/input_tile.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:machen_app/state/blocs/todo_list_bloc.dart';

class ListSettingsSheet extends StatefulWidget {
  final String todoListId;
  final Function onUpdate;

  const ListSettingsSheet(
      {Key? key, required this.todoListId, required this.onUpdate})
      : super(key: key);

  @override
  State<ListSettingsSheet> createState() => _ListSettingsSheetState();
}

class _ListSettingsSheetState extends State<ListSettingsSheet> {
  @override
  Widget build(BuildContext context) {
    var todoListBloc = context.watch<TodoListBloc>();

    var authBloc = context.read<AuthBloc>();
    todoListBloc.add(
      TodoListFetchEvent(
        authBloc.state.token,
        widget.todoListId,
      ),
    );

    return IconButton(
      icon: const Icon(
        Icons.settings,
        color: Colors.white,
      ),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      '${(todoListBloc.state.list?.name ?? '')} Settings',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    InputTile(
                        title: 'Name',
                        value: todoListBloc.state.list?.name ?? '',
                        updateFunc: (String value) async {
                          var response = await TodoListRepository().updateList(
                            authBloc.state.token,
                            todoListBloc.state.id,
                            value,
                            null,
                          );
                          widget.onUpdate(false);
                          Navigator.pop(context);
                          return response;
                        }),
                    const Spacer(),
                    SafeArea(
                      child: TextButton(
                        onPressed: () {
                          todoListBloc.add(
                            TodoListDeleteListEvent(authBloc.state.token),
                          );
                          widget.onUpdate(true);

                          Navigator.pop(context);
                        },
                        child: const Text('Delete List',
                            style: TextStyle(fontSize: 25, color: Colors.red)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
