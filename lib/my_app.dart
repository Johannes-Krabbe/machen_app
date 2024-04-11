import 'package:flutter/material.dart';
import 'package:machen_app/api/repositories/todo_list_repository.dart';
import 'package:machen_app/components/list_settings_sheet.dart';
import 'package:machen_app/screens/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/screens/todo_list_screen.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:machen_app/state/blocs/todo_list_bloc.dart';
import 'package:machen_app/state/blocs/todo_lists_bloc.dart';
import 'package:machen_app/state/types/todo_lists_state.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = context.watch<AuthBloc>();
    var todoListsBloc = context.watch<TodoListsBloc>();

    if (todoListsBloc.state.status == TodoListStatus.initial) {
      todoListsBloc.add(
        TodoListsLoadEvent(authBloc.state.token),
      );
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                todoListsBloc.state.lists.isNotEmpty
                    ? todoListsBloc.state.lists[_selectedIndex].name ?? ''
                    : 'Loading',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Builder(builder: (context) {
              if (todoListsBloc.state.status == TodoListStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (todoListsBloc.state.lists.isEmpty) {
                return const Center(
                  child: Text("No lists found"),
                );
              }

              return Provider(
                create: (_) => TodoListBloc(),
                child: TodoListScreen(
                  todoListId:
                      todoListsBloc.state.lists[_selectedIndex].id ?? '',
                ),
              );
            }),
            drawer: Drawer(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    TextEditingController controller = TextEditingController();
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20, bottom: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black12
                                      : Colors.white12,
                                ),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: "Enter your new list name",
                                    border: InputBorder.none,
                                  ),
                                  controller: controller,
                                  autofocus: true,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () async {
                                      if (controller.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Center(
                                              child: Text(
                                                'Please enter a name',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                      var response =
                                          await TodoListRepository().createList(
                                        authBloc.state.token,
                                        controller.text,
                                        null,
                                      );
                                      if (response) {
                                        todoListsBloc.add(
                                          TodoListsLoadEvent(
                                              authBloc.state.token),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Center(
                                              child: Text(
                                                "Failed to create list",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Create'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    todoListsBloc.add(TodoListsLoadEvent(authBloc.state.token));
                  },
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(
                                      authBloc.state.me?.profilePictureUrl ??
                                          'https://storage.googleapis.com/machen-profile-pictures/empty.png',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SizedBox(
                                      width: 130,
                                      height: 25,
                                      child: Text(
                                        authBloc.state.me?.name ?? "",
                                        softWrap: false,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Settings(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.settings))
                              ],
                            )
                          ],
                        ),
                        ...todoListsBloc.state.lists
                            .asMap()
                            .entries
                            .map((e) => ListTile(
                                  title: Text(
                                    e.value.name ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Icon(
                                    e.value.deletable == false
                                        ? Icons.inbox
                                        : Icons.list,
                                    color: Colors.white,
                                  ),
                                  selected: e.key == _selectedIndex,
                                  onTap: () {
                                    _selectIndex(e.key);
                                    Navigator.pop(context);
                                  },
                                ))
                            .toList(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class AppRoute {
  Widget widget;
  String title;
  String id = '';
  String createdAt;
  bool isMain;
  AppRoute({
    required this.widget,
    required this.title,
    required this.createdAt,
    required this.id,
    this.isMain = false,
  });
}
