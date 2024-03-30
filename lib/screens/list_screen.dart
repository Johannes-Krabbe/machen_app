import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/components/nav_app_bar.dart';
import 'package:machen_app/components/task_tile.dart';
import 'package:machen_app/state/blocs/todo_list_bloc.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoListBloc(),
      child: Builder(builder: (context) {
        return NavAppBar(
          title: "ListName",
          body: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Builder(builder: (context) {
                    var todoListBloc = context.watch<TodoListBloc>();
                    return ListView(
                      children: [
                        ...todoListBloc.state.items
                            .map(
                              (e) => Dismissible(
                                key: Key(e.id),
                                onDismissed: (direction) {
                                  todoListBloc.add(DeleteTodoEvent(e.id));
                                },
                                background: Container(
                                  color: Colors.red,
                                  child: const Icon(Icons.delete),
                                ),
                                child: TaskTile(
                                    title: e.title,
                                    isDone: e.isDone,
                                    onChanged: (value) => {
                                          todoListBloc
                                              .add(ToggleTodoEvent(e.id))
                                        }),
                              ),
                            )
                            .toList()
                      ],
                    );
                  }),
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
                              border: InputBorder.none),
                          controller: _controller,
                        ),
                      ),
                      const SizedBox(width: 15),
                      IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            context
                                .read<TodoListBloc>()
                                .add(AddTodoEvent(_controller.text));
                            _controller.clear();
                          }),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
                Container(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black12
                        : Colors.white12,
                    height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        );
      }),
    );
  }
}
