import 'package:flutter/material.dart';
import 'package:machen_app/api/models/user/update_response.dart';
import 'package:machen_app/api/repositories/user_repository.dart';
import 'package:machen_app/components/input_tile.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    var authBloc = context.read<AuthBloc>();
    authBloc.add(FetchMeAuthEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = context.watch<AuthBloc>();
    var me = authBloc.state.me;

    Future<UserUpdateResponse> updateFunc(
        String? username, String? name, String? email) async {
      var response = await UserRepository()
          .update(authBloc.state.token, username, name, email);

      if (response.success == true) {
        authBloc.add(FetchMeAuthEvent());
      }
      return response;
    }

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage(
                "https://www.shutterstock.com/shutterstock/videos/1086926591/thumb/12.jpg?ip=x480",
              ),
            ),
            const SizedBox(height: 20),
            InputTile(
              title: "Username",
              value: me?.username ?? "",
              updateFunc: (String username) {
                return updateFunc(username, null, null);
              },
            ),
            const SizedBox(height: 20),
            InputTile(
                title: "Email",
                value: me?.email ?? "",
                updateFunc: (String email) {
                  return updateFunc(null, null, email);
                }),
            const SizedBox(height: 20),
            InputTile(
                title: "Display Name",
                value: me?.name ?? "",
                updateFunc: (String name) {
                  return updateFunc(null, name, null);
                }),
          ],
        ),
      ),
    );
  }
}
