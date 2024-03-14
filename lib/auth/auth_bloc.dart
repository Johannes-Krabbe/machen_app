import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/api/api_provider.dart';
import 'package:machen_app/auth/auth_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Events

sealed class AuthEvent {}

final class LoginAuthEvent extends AuthEvent {
  final String emailOrUsername;
  final String password;

  LoginAuthEvent(this.emailOrUsername, this.password);
}

final class LogoutAuthEvent extends AuthEvent {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginAuthEvent>((event, emit) async {
      await _onLogin(event, emit);
    });
    on<LogoutAuthEvent>((event, emit) async {
      await _onLogout(event, emit);
    });
  }

  Future<bool> _onLogin(LoginAuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));

    var loginResponse =
        await ApiProvider().login(event.emailOrUsername, event.password);

    if (loginResponse.success == false) {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
        isSuccess: false,
        error: loginResponse.messsage,
      ));
      return false;
    } else {
      emit(state.copyWith(
        isLoading: false,
        isFailure: false,
        isSuccess: true,
        token: loginResponse.token,
      ));

      return true;
    }
  }

  Future<void> _onLogout(LogoutAuthEvent event, Emitter<AuthState> emit) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    emit(const AuthState());
  }
}
