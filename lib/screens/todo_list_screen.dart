import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/components/task_tile.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:machen_app/state/blocs/todo_list_bloc.dart';
import 'package:machen_app/state/types/todo_list_state.dart';

class TodoListScreen extends StatefulWidget {
  final String todoListId;

  const TodoListScreen({Key? key, required this.todoListId}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    var authBloc = context.read<AuthBloc>();
    context
        .read<TodoListBloc>()
        .add(TodoListFetchEvent(authBloc.state.token, widget.todoListId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<TodoListBloc, TodoListState>(
              builder: (context, state) {
                if (state.items.isEmpty) {
                  return const CircularProgressIndicator();
                } else {
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Dismissible(
                        key: Key(item.id ?? ''),
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        onDismissed: (direction) {
                          if (item.id != null) {
                            context
                                .read<TodoListBloc>()
                                .add(TodoListDeleteItemEvent(
                                  context.read<AuthBloc>().state.token,
                                  item.id!,
                                ));
                          }
                        },
                        child: TaskTile(
                          title: item.title ?? '',
                          isDone: item.completed ?? false,
                          onChanged: (value) {
                            context.read<TodoListBloc>().add(
                                  TodoListToggleItemEvent(
                                    context.read<AuthBloc>().state.token,
                                    item.id ?? '',
                                  ),
                                );
                          },
                        ),
                      );
                    },
                  );
                }
                /*
              else if (state is TodoListError) {
                return Text('Error: ${state.message}');
              }
              return SizedBox(); // Fallback empty space
              */
              },
            ),
          ),
          Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black12
                : Colors.white12,
            height: 70,
            child: Row(
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Create new task",
                      border: InputBorder.none,
                    ),
                    controller: _controller,
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    context.read<TodoListBloc>().add(
                          TodoListAddItemEvent(
                            context.read<AuthBloc>().state.token,
                            _controller.text,
                          ),
                        );
                    _controller.clear();
                  },
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black12
                : Colors.white12,
            height: MediaQuery.of(context).padding.bottom,
          ),
        ],
      ),
    );
  }
}
