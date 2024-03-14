import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/auth/auth_bloc.dart';

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
    return Scaffold(
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
                var authBloc = context.read<AuthBloc>();
                authBloc.add(
                  LoginAuthEvent(
                      _emailController.text, _passwordController.text),
                );
              },
              child: const Text('Login'),
            ),
            Builder(builder: (context) {
              var authBloc = context.watch<AuthBloc>();

              if (authBloc.state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (authBloc.state.isFailure) {
                return Center(
                  child: Text(authBloc.state.error ?? 'Unknown error'),
                );
              } else if (authBloc.state.isSuccess) {
                return Center(child: Text(authBloc.state.token));
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
