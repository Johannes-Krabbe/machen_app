import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/screens/list_screen.dart';
import 'package:machen_app/screens/signup_screen.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:machen_app/screens/login_screen.dart';
import 'package:machen_app/state/types/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      lazy: false,
      create: (_) => AuthBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    var authBloc = context.watch<AuthBloc>();

    if (authBloc.state.state == AuthStateEnum.initializing) {
      authBloc.add(AppStartedAuthEvent());
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
      home: authBloc.state.state == AuthStateEnum.success
          ? const ListScreen()
          : authBloc.state.pageState == AuthPageStateEnum.login
              ? const Login()
              : const Signup(),
    );
  }
}
