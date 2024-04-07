import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/state/blocs/auth_bloc.dart';
import 'package:machen_app/state/types/auth_state.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: "Choose a Username",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Enter your Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              TextFormField(
                controller: _repeatPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Repeat your Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please repeat your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  var authBloc = context.read<AuthBloc>();
                  authBloc.add(ChangePageAuthEvent(AuthPageStateEnum.login));
                },
                child: const Text('Already have an account? Login'),
              ),
              Builder(builder: (context) {
                var authBloc = context.watch<AuthBloc>();
                if (authBloc.state.state == AuthStateEnum.loading) {
                  return const Center(
                      child: Column(
                    children: [
                      SizedBox(height: 10),
                      CircularProgressIndicator(),
                    ],
                  ));
                } else if (authBloc.state.state == AuthStateEnum.failure) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Text(authBloc.state.error ?? 'Unknown error',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
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
                SignupAuthEvent(_usernameController.text, _emailController.text,
                    _passwordController.text),
              );
            }
          },
          child: const Text(
            'Create new Account',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
