import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/api/repositories/todo_list_repository.dart';
import 'package:machen_app/components/input_tile.dart';
import 'package:machen_app/components/multi_line_input_tile.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:machen_app/state/blocs/todo_list_bloc.dart';
import 'package:machen_app/state/types/todo_list_state.dart';

class ListSettingsSheet extends StatefulWidget {
  final Function onUpdate;

  const ListSettingsSheet({Key? key, required this.onUpdate}) : super(key: key);

  @override
  State<ListSettingsSheet> createState() => _ListSettingsSheetState();
}

class _ListSettingsSheetState extends State<ListSettingsSheet> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.settings,
        color: Colors.white,
      ),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext modalContext) {
            return BlocProvider.value(
              value: BlocProvider.of<TodoListBloc>(context),
              child: BlocBuilder<TodoListBloc, TodoListState>(
                  builder: (context, state) {
                context.watch<TodoListBloc>().add(
                      TodoListFetchEvent(
                        context.read<AuthBloc>().state.token,
                        state.id,
                      ),
                    );
                return SizedBox(
                  height: MediaQuery.of(modalContext).size.height * 0.9,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Text(
                          '${(context.watch<TodoListBloc>().state.list?.name ?? '')} Settings',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 20),
                        InputTile(
                            title: 'Name',
                            value: context
                                    .watch<TodoListBloc>()
                                    .state
                                    .list
                                    ?.name ??
                                '',
                            updateFunc: (String value) async {
                              var response =
                                  await TodoListRepository().updateList(
                                modalContext.read<AuthBloc>().state.token,
                                context.watch<TodoListBloc>().state.id,
                                value,
                                null,
                              );
                              widget.onUpdate(false);
                              Navigator.pop(modalContext);
                              return response;
                            }),
                        const SizedBox(height: 20),
                        MultiLineInputTile(
                          title: "Description",
                          value: context
                                  .watch<TodoListBloc>()
                                  .state
                                  .list
                                  ?.description ??
                              '',
                          updateFunc: (String value) async {
                            context.read<TodoListBloc>().add(
                                  TodoListUpdateListEvent(
                                    modalContext.read<AuthBloc>().state.token,
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
                              if (context
                                      .watch<TodoListBloc>()
                                      .state
                                      .list
                                      ?.deletable ==
                                  false) {
                                return;
                              }
                              modalContext.read<TodoListBloc>().add(
                                    TodoListDeleteListEvent(modalContext
                                        .read<AuthBloc>()
                                        .state
                                        .token),
                                  );
                              widget.onUpdate(true);
                              Navigator.pop(modalContext);
                            },
                            child: Text(
                              'Delete List',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: state.list?.deletable == false
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
          },
        );
      },
    );
  }
}
