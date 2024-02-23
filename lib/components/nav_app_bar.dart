import 'package:flutter/material.dart';
import 'package:machen_app/components/nav_drawer.dart';

class NavAppBar extends StatelessWidget {
  final StatefulWidget? body;
  final String title;
  const NavAppBar({
    Key? key,
    required this.body,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            // drawer
            appBar: AppBar(
              title: Text(title),
            ),
            drawer: const NavDrawer(),
            body: body),
      ),
    );
  }
}
