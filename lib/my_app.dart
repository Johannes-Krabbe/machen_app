import 'package:flutter/material.dart';
import 'package:machen_app/screens/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/screens/todo_list_screen.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:machen_app/state/blocs/todo_list_bloc.dart';
import 'package:machen_app/state/blocs/todo_lists_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    var todoListBloc = context.read<TodoListsBloc>();
    var authBloc = context.read<AuthBloc>();
    todoListBloc.add(TodoListsLoadEvent(authBloc.state.token));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = context.watch<AuthBloc>();
    var todoListBloc = context.watch<TodoListsBloc>();

    final List<AppRoute> todoListRoutes = todoListBloc.state.lists
        .map(
          (e) => AppRoute(
              widget: BlocProvider(
                  create: (_) => TodoListBloc(),
                  child: TodoListScreen(todoListId: e.id ?? '')),
              title: e.name ?? ''),
        )
        .toList();

    final AppRoute selectedRoute = todoListRoutes.isEmpty
        ? AppRoute(
            widget: const Center(child: CircularProgressIndicator()), title: "")
        : todoListRoutes[_selectedIndex];

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            appBar: AppBar(
              title: Text(selectedRoute.title),
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
                                _onItemTapped(e.key);
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
  AppRoute({required this.widget, required this.title});
}
