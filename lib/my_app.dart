import 'package:flutter/material.dart';
import 'package:machen_app/screens/list_screen.dart';
import 'package:machen_app/screens/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<AppRoute> _widgetOptions = <AppRoute>[
    AppRoute(widget: const ListScreen(), title: "List"),
    AppRoute(widget: const Text('Index 1: Business'), title: "Business"),
    AppRoute(widget: const Text('Index 2: School'), title: "School"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = context.watch<AuthBloc>();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            appBar: AppBar(
              title: Text(_widgetOptions[_selectedIndex].title),
            ),
            body: _widgetOptions[_selectedIndex].widget,
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
                                child: Text(
                                  authBloc.state.me?.name ?? "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
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
                    ..._widgetOptions
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
