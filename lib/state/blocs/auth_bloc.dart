import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machen_app/api/repositories/auth_repository.dart';
import 'package:machen_app/state/types/auth_state.dart';

// move to secure storage reposotory
import 'package:machen_app/utils/secure_storage_repository.dart';

// Events

sealed class AuthEvent {}

final class LoginAuthEvent extends AuthEvent {
  final String emailOrUsername;
  final String password;

  LoginAuthEvent(this.emailOrUsername, this.password);
}

final class SignupAuthEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  SignupAuthEvent(this.username, this.email, this.password);
}

final class LogoutAuthEvent extends AuthEvent {}

final class AppStartedAuthEvent extends AuthEvent {}

final class FetchMeAuthEvent extends AuthEvent {}

final class ChangePageAuthEvent extends AuthEvent {
  final AuthPageStateEnum pageState;

  ChangePageAuthEvent(this.pageState);
}

// Bloc

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginAuthEvent>((event, emit) async {
      await _onLogin(event, emit);
    });
    on<SignupAuthEvent>((event, emit) async {
      await _onSignUp(event, emit);
    });
    on<LogoutAuthEvent>((event, emit) async {
      await _onLogout(event, emit);
    });
    on<AppStartedAuthEvent>((event, emit) async {
      await _onAppStarted(event, emit);
    });
    on<FetchMeAuthEvent>((event, emit) async {
      await _onFetchMe(event, emit);
    });
    on<ChangePageAuthEvent>((event, emit) async {
      emit(AuthState(pageState: event.pageState, state: AuthStateEnum.none));
    });
  }

  _onLogin(LoginAuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(state: AuthStateEnum.loading));

    var loginResponse =
        await AuthRepository().login(event.emailOrUsername, event.password);

    if (loginResponse.success == true &&
        loginResponse.token?.isNotEmpty == true) {
      var meResponse = await AuthRepository().me(loginResponse.token!);

      if (meResponse.success == true) {
        await SecureStorageRepository().write('token', loginResponse.token!);
        emit(state.copyWith(
          state: AuthStateEnum.success,
          token: loginResponse.token,
          me: meResponse.user,
        ));
      } else {
        emit(state.copyWith(
          state: AuthStateEnum.failure,
          error: "Something went wrong, please try again.",
        ));
      }
    } else {
      emit(state.copyWith(
        state: AuthStateEnum.failure,
        error: loginResponse.messsage,
      ));
    }
  }

  _onSignUp(SignupAuthEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(state: AuthStateEnum.loading));

    var signUpResponse = await AuthRepository()
        .signup(event.username, event.email, event.password);

    if (signUpResponse.success == true &&
        signUpResponse.token?.isNotEmpty == true) {
      var meResponse = await AuthRepository().me(signUpResponse.token!);

      if (meResponse.success == true) {
        await SecureStorageRepository().write('token', signUpResponse.token!);
        emit(state.copyWith(
          state: AuthStateEnum.success,
          token: signUpResponse.token,
          me: meResponse.user,
        ));
      } else {
        emit(state.copyWith(
          state: AuthStateEnum.failure,
          error: "Something went wrong, please try again.",
        ));
      }
    } else {
      emit(state.copyWith(
        state: AuthStateEnum.failure,
        error: signUpResponse.messsage,
      ));
    }
  }

  _onFetchMe(FetchMeAuthEvent event, Emitter<AuthState> emit) async {
    var token = await SecureStorageRepository().read('token');
    if (token != null) {
      var meResponse = await AuthRepository().me(token);
      if (meResponse.success == true) {
        emit(state.copyWith(me: meResponse.user));
      }
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
      var meResponse = await AuthRepository().me(token);

      if (meResponse.success == true) {
        emit(state.copyWith(
            state: AuthStateEnum.success, token: token, me: meResponse.user));
      } else {
        emit(const AuthState(state: AuthStateEnum.none));
      }
    }
  }
}
