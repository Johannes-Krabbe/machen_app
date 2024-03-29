import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/screens/list_screen.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authBloc = context.read<AuthBloc>();
    return LayoutBuilder(builder: (context, constraints) {
      return Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
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
                  const Center(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              "https://www.shutterstock.com/shutterstock/videos/1086926591/thumb/12.jpg?ip=x480"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Johannes',
                            style: TextStyle(
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
                            authBloc.add(LogoutAuthEvent());
                          },
                          icon: const Icon(Icons.logout))
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Today'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ListScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.inbox),
                title: const Text('Inbox'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Placeholder(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
