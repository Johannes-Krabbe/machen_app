import 'package:machen_app/api/api_provider.dart';
import 'package:machen_app/api/models/auth/login_response.dart';
import 'package:machen_app/api/models/auth/me_response.dart';
import 'package:machen_app/api/models/auth/signup_response.dart';
import 'package:dio/dio.dart';

class AuthRepository extends ApiProvider {
  Future<LoginResponse> login(String emailOrUsername, String password) async {
    try {
      Response response = await dio.post("/auth/login", data: {
        "emailOrUsername": emailOrUsername,
        "password": password,
      });

      return LoginResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioException) {
        return LoginResponse(
            success: false,
            messsage: error.response?.data["message"] ?? 'Unknown error',
            code: error.response?.data["code"]);
      }
    }
    return LoginResponse(success: false, messsage: 'Unknown error');
  }

  Future<SignupResponse> signup(
      String username, String email, String password) async {
    try {
      Response response = await dio.post("/auth/signup", data: {
        "username": username,
        "email": email,
        "password": password,
      });

      return SignupResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioException) {
        return SignupResponse(
          success: false,
          messsage: error.response?.data["message"] ?? 'Unknown error',
          code: error.response?.data["code"],
        );
      }
    }
    return SignupResponse(
      success: false,
      messsage: 'Unknown error',
    );
  }

  Future<MeResponse> me(String token) async {
    try {
      Response response = await dio.get("/auth/me",
          options: Options(headers: {"authorization": "Bearer $token"}));

      return MeResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioException) {
        return MeResponse(
          success: false,
          messsage: error.response?.data["message"] ?? 'Unknown error',
          code: error.response?.data["code"],
        );
      }
    }
    return MeResponse(
      success: false,
      messsage: 'Unknown error',
    );
  }
}
