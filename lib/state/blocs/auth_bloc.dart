import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/api/repositories/auth_repository.dart';
import 'package:machen_app/state/types/auth_state.dart';

// move to secure storage reposotory
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Events

sealed class AuthEvent {}

final class LoginAuthEvent extends AuthEvent {
  final String emailOrUsername;
  final String password;

  LoginAuthEvent(this.emailOrUsername, this.password);
}

final class LogoutAuthEvent extends AuthEvent {}

// Bloc

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginAuthEvent>((event, emit) async {
      await _onLogin(event, emit);
    });
    on<LogoutAuthEvent>((event, emit) async {
      await _onLogout(event, emit);
    });
  }

  _onLogin(LoginAuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));

    var loginResponse =
        await AuthRepository().login(event.emailOrUsername, event.password);

    if (loginResponse.success == false) {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
        isSuccess: false,
        error: loginResponse.messsage,
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        isFailure: false,
        isSuccess: true,
        token: loginResponse.token,
      ));
    }
  }

  _onLogout(LogoutAuthEvent event, Emitter<AuthState> emit) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    emit(const AuthState());
  }
}
