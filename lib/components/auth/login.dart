import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/auth/auth_bloc.dart';
import 'package:machen_app/auth/auth_repository.dart';
import 'package:machen_app/screens/list_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Enter you Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter you Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final loginData = LogInData(
                      _emailController.text, _passwordController.text);
                  BlocProvider.of<AuthBloc>(context).add(LoggedIn(loginData));
                  print('LoggedIn event dispatched'); // Check if this prints
                },
                child: const Text('Submit'),
              ),
              Expanded(
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Auth listener')),
                    );
                  },
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
