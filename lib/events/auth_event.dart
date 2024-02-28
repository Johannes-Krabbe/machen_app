import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/resources/api_provider.dart';

enum AuthEvent { login, register }

class Auth {
  String? email;
  String? username;
  String? token;
  String error;

  Auth({this.email, this.username, this.token, this.error = ''});

  Auth copyWith({
    String? email,
    String? username,
    String? token,
    String? error,
  }) {
    return Auth(
      email: email ?? this.email,
      username: username ?? this.username,
      token: token ?? this.token,
      error: error ?? this.error,
    );
  }
}

class AuthCubit extends Cubit<Auth> {
  AuthCubit() : super(Auth());

  void login(String emailOrPassword, String password) {
    ApiProvider().login(emailOrPassword, password).then(
      (value) {
        emit(
          Auth(
            email: value.email,
            username: value.username,
            token: value.token,
            error: value.error ?? '',
          ),
        );
      },
    );
  }
}
