import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/api/repositories/auth_repository.dart';
import 'package:machen_app/state/types/auth_state.dart';

// move to secure storage reposotory
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:machen_app/utils/secure_storage_repository.dart';

// Events

sealed class AuthEvent {}

final class LoginAuthEvent extends AuthEvent {
  final String emailOrUsername;
  final String password;

  LoginAuthEvent(this.emailOrUsername, this.password);
}

final class LogoutAuthEvent extends AuthEvent {}

final class AppStartedAuthEvent extends AuthEvent {}

// Bloc

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginAuthEvent>((event, emit) async {
      await _onLogin(event, emit);
    });
    on<LogoutAuthEvent>((event, emit) async {
      await _onLogout(event, emit);
    });
    on<AppStartedAuthEvent>((event, emit) async {
      await _onAppStarted(event, emit);
    });
  }

  _onLogin(LoginAuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(state: AuthStateEnum.loading));

    var loginResponse =
        await AuthRepository().login(event.emailOrUsername, event.password);

    if (loginResponse.success == true &&
        loginResponse.token?.isNotEmpty == true) {
      await SecureStorageRepository().write('token', loginResponse.token!);
      emit(state.copyWith(
        state: AuthStateEnum.success,
        token: loginResponse.token,
      ));
    } else {
      emit(state.copyWith(
        state: AuthStateEnum.failure,
        error: loginResponse.messsage,
      ));
    }
  }

  _onLogout(LogoutAuthEvent event, Emitter<AuthState> emit) async {
    await SecureStorageRepository().delete('token');
    emit(const AuthState());
  }

  _onAppStarted(AppStartedAuthEvent event, Emitter<AuthState> emit) async {
    var token = await SecureStorageRepository().read('token');
    if (token == null) {
      emit(const AuthState(state: AuthStateEnum.none));
    } else {
      emit(state.copyWith(state: AuthStateEnum.success, token: token));
    }
  }
}
