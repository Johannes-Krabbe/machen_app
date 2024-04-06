import 'package:flutter/material.dart';
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

    final List<AppRoute> todoListRoutes = todoListsBloc.state.lists
        .map(
          (e) => AppRoute(
            widget: BlocProvider(
                create: (_) => TodoListBloc(),
                child: TodoListScreen(todoListId: e.id ?? '')),
            id: e.id ?? '',
            title: e.name ?? '',
            createdAt: e.createdAt ?? '',
          ),
        )
        .toList();

    todoListRoutes.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final AppRoute selectedRoute = todoListRoutes.isEmpty
        ? AppRoute(
            widget: const Center(child: CircularProgressIndicator()),
            title: "",
            createdAt: '',
            id: '',
          )
        : todoListRoutes[_selectedIndex];

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            appBar: AppBar(
              title: Text(selectedRoute.title),
              actions: <Widget>[
                Provider(
                  create: (_) => TodoListBloc(),
                  child: ListSettingsSheet(
                      todoListId: selectedRoute.id,
                      onDelete: () {
                        var authBloc = context.read<AuthBloc>();
                        _selectIndex(0);
                        todoListsBloc
                            .add(TodoListsResetEvent(authBloc.state.token));
                      }),
                ),
              ],
            ),
            body: selectedRoute.widget,
            drawer: Drawer(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0)),
              ),
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
                              const CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    "https://www.shutterstock.com/shutterstock/videos/1086926591/thumb/12.jpg?ip=x480"),
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
                                      builder: (context) => const Settings(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.settings))
                          ],
                        )
                      ],
                    ),
                    ...todoListRoutes
                        .asMap()
                        .entries
                        .map((e) => ListTile(
                              title: Text(e.value.title),
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
  AppRoute({
    required this.widget,
    required this.title,
    required this.createdAt,
    required this.id,
  });
}
