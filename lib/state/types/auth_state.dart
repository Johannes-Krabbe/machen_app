// import 'package:equatable/equatable.dart';

enum AuthStateEnum { none, initializing, loading, failure, success }

enum AuthPageStateEnum { login, signup }

class AuthState {
  final AuthStateEnum state;
  final AuthPageStateEnum pageState;
  final String? error;

  final String token;

  const AuthState({
    this.state = AuthStateEnum.initializing,
    this.pageState = AuthPageStateEnum.login,
    this.error,
    this.token = '',
  });

  // copy with
  AuthState copyWith({
    AuthStateEnum? state,
    AuthPageStateEnum? pageState,
    String? error,
    String? token,
  }) {
    return AuthState(
      state: state ?? this.state,
      pageState: pageState ?? this.pageState,
      error: error ?? this.error,
      token: token ?? this.token,
    );
  }
}
