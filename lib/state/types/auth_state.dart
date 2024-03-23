// import 'package:equatable/equatable.dart';

enum AuthStateEnum { none, initializing, loading, failure, success }

class AuthState {
  final AuthStateEnum state;
  final String? error;

  final String token;

  const AuthState({
    this.state = AuthStateEnum.initializing,
    this.error,
    this.token = '',
  });

  // copy with
  AuthState copyWith({
    AuthStateEnum? state,
    String? error,
    String? token,
  }) {
    return AuthState(
      state: state ?? this.state,
      error: error ?? this.error,
      token: token ?? this.token,
    );
  }
}
