import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:machen_app/auth/auth_repository.dart';
import 'package:machen_app/models/auth_models.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LogInData extends AuthEvent {
  final String username;
  final String password;
  LogInData(this.username, this.password);
}

class LoggedIn extends AuthEvent {
  final LogInData user;
  LoggedIn(this.user);
}

class LoggedOut extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final MeUser user;
  AuthAuthenticated(this.user);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class AuthUnauthenticated extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token != null) {
        // Attempt to validate token if you have a mechanism on your backend
        emit(AuthAuthenticated(MeUser(token: token)));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure('Error checking authentication status'));
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    try {
      final user =
          await _authRepository.login(event.user.username, event.user.password);
      if (user.error != null && user.error!.isNotEmpty) {
        emit(AuthFailure(user.error!));
        // print('Login failed: ${user.error} (code: 001)');
        return;
      }
      await _storage.write(key: 'jwt_token', value: user.token);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure('Login failed: ${e.toString()} (code: 002)'));
    }
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    try {
      await _storage.delete(key: 'jwt_token');
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure('Error during logout'));
    }
  }
}
