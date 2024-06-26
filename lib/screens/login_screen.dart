import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:machen_app/state/types/auth_state.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailUsernameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailUsernameController,
                decoration: const InputDecoration(
                  hintText: "Enter your Email or Username",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email or username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter your Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  var authBloc = context.read<AuthBloc>();
                  authBloc.add(ChangePageAuthEvent(AuthPageStateEnum.signup));
                },
                child: const Text('Don\'t have an account? Create one here!'),
              ),
              Builder(builder: (context) {
                var authBloc = context.watch<AuthBloc>();

                if (authBloc.state.state == AuthStateEnum.loading) {
                  return const Column(
                    children: [
                      SizedBox(height: 10),
                      Center(child: CircularProgressIndicator()),
                    ],
                  );
                } else if (authBloc.state.state == AuthStateEnum.failure) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Text(authBloc.state.error ?? 'Unknown error',
                            style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              var authBloc = context.read<AuthBloc>();
              authBloc.add(
                LoginAuthEvent(
                  _emailUsernameController.text,
                  _passwordController.text,
                ),
              );
            }
          },
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
