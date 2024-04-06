import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:machen_app/state/blocs/todo_list_bloc.dart';

class ListSettingsSheet extends StatefulWidget {
  final String todoListId;

  const ListSettingsSheet({Key? key, required this.todoListId})
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
