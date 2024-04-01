// import 'package:equatable/equatable.dart';

import 'package:machen_app/api/models/auth/me_model.dart';

enum AuthStateEnum { none, initializing, loading, failure, success }

enum AuthPageStateEnum { login, signup }

// ignore: constant_identifier_names
enum UserRoles { ADMIN, USER }

class AuthState {
  final AuthStateEnum state;
  final AuthPageStateEnum pageState;
  final String? error;

  final String token;
  final MeUserModel? me;

  const AuthState({
    this.state = AuthStateEnum.initializing,
    this.pageState = AuthPageStateEnum.login,
    this.error,
    this.token = '',
    this.me,
  });

  // copy with
  AuthState copyWith({
    AuthStateEnum? state,
    AuthPageStateEnum? pageState,
    String? error,
    String? token,
    MeUserModel? me,
  }) {
    return AuthState(
      state: state ?? this.state,
      pageState: pageState ?? this.pageState,
      error: error ?? this.error,
      token: token ?? this.token,
      me: me ?? this.me,
    );
  }
}
