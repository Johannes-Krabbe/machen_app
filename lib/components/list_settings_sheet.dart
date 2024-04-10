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
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black12
                            : Colors.white12,
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      // flull width
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Description',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                // textAlign: TextAlign.left,
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        final controller =
                                            TextEditingController(
                                                text: todoListBloc.state.list
                                                        ?.description ??
                                                    '');
                                        return Dialog(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.only(
                                                top: 20,
                                                left: 20,
                                                right: 20,
                                                bottom: 10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? Colors.black12
                                                        : Colors.white12,
                                                  ),
                                                  child: TextField(
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          "Enter your new description",
                                                      border: InputBorder.none,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: null,
                                                    controller: controller,
                                                    autofocus: true,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await TodoListRepository()
                                                            .updateList(
                                                          authBloc.state.token,
                                                          todoListBloc.state.id,
                                                          null,
                                                          controller.text,
                                                        );
                                                        widget.onUpdate(false);

                                                        todoListBloc.add(
                                                          TodoListFetchEvent(
                                                            authBloc
                                                                .state.token,
                                                            widget.todoListId,
                                                          ),
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Update'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            todoListBloc.state.list?.description ?? '',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SafeArea(
                      child: TextButton(
                        onPressed: () {
                          if (todoListBloc.state.list?.deletable == false) {
                            return;
                          }
                          todoListBloc.add(
                            TodoListDeleteListEvent(authBloc.state.token),
                          );
                          widget.onUpdate(true);

                          Navigator.pop(context);
                        },
                        child: Text(
                          'Delete List',
                          style: TextStyle(
                              fontSize: 25,
                              color: todoListBloc.state.list?.deletable == false
                                  ? Colors.grey
                                  : Colors.red),
                        ),
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
