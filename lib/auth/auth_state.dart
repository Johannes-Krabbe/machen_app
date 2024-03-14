// import 'package:equatable/equatable.dart';

class AuthState {
  final bool isLoading;
  final bool isFailure;
  final bool isSuccess;
  final String? error;

  final String token;

  const AuthState({
    this.isLoading = false,
    this.isFailure = false,
    this.isSuccess = false,
    this.error,
    this.token = '',
  });

  // copy with
  AuthState copyWith({
    bool? isLoading,
    bool? isFailure,
    bool? isSuccess,
    String? error,
    String? token,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      token: token ?? this.token,
    );
  }
}
