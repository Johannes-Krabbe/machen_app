import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/my_app.dart';
import 'package:machen_app/screens/signup_screen.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:machen_app/screens/login_screen.dart';
import 'package:machen_app/state/blocs/todo_list_bloc.dart';
import 'package:machen_app/state/blocs/todo_lists_bloc.dart';
import 'package:machen_app/state/types/auth_state.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      BlocProvider(
        lazy: false,
        create: (_) => AuthBloc(),
      ),
      BlocProvider(
        lazy: false,
        create: (_) => TodoListsBloc(),
      ),
      BlocProvider(lazy: false, create: (_) => TodoListBloc())
    ],
    child: const AppRoot(),
  ));
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  var themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    var authBloc = context.watch<AuthBloc>();

    if (authBloc.state.state == AuthStateEnum.initializing) {
      authBloc.add(AppStartedAuthEvent());
    }

    Widget currentRenderedPage;

    if (authBloc.state.state == AuthStateEnum.success) {
      currentRenderedPage = const MyApp();
    } else if (authBloc.state.state == AuthStateEnum.initializing) {
      currentRenderedPage = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (authBloc.state.pageState == AuthPageStateEnum.login) {
      currentRenderedPage = const Login();
    } else if (authBloc.state.pageState == AuthPageStateEnum.signup) {
      currentRenderedPage = const Signup();
    } else {
      //center loading spinner
      currentRenderedPage = const Center(
        child: CircularProgressIndicator(),
      );
    }

    return MaterialApp(
      title: 'Machen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark().copyWith(primary: Colors.blue),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      themeMode: themeMode,
      home: currentRenderedPage,
    );
  }
}
