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
  final TextEditingController _emailController = TextEditingController();
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
              Builder(builder: (context) {
                var authBloc = context.watch<AuthBloc>();

                if (authBloc.state.state == AuthStateEnum.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (authBloc.state.state == AuthStateEnum.failure) {
                  return Center(
                    child: Text(authBloc.state.error ?? 'Unknown error'),
                  );
                }
                return const SizedBox.shrink();
              }),
              const Spacer(),
              // link to signup
              TextButton(
                onPressed: () {
                  var authBloc = context.read<AuthBloc>();
                  authBloc.add(ChangePageAuthEvent(AuthPageStateEnum.signup));
                },
                child: const Text('Don\'t have an account? Sign up'),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var authBloc = context.read<AuthBloc>();
                    authBloc.add(
                      LoginAuthEvent(
                        _emailController.text,
                        _passwordController.text,
                      ),
                    );
                  }
                },
                child: const Text('Login', style: TextStyle(fontSize: 30)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
