import 'package:dio/dio.dart';
import 'package:machen_app/api/models/auth/login_response.dart';
import 'package:machen_app/api/models/auth/signup_response.dart';

export 'api_provider.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _url = 'http://localhost:8080';

  Future<LoginResponse> login(String emailOrUsername, String password) async {
    try {
      Response response = await _dio.post("$_url/auth/login", data: {
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

  Future<SignupResponse> signup(String emailOrUsername, String password) async {
    try {
      Response response = await _dio.post("$_url/auth/login", data: {
        "emailOrUsername": emailOrUsername,
        "password": password,
      });

      return SignupResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioException) {
        return SignupResponse(
            success: false,
            messsage: error.response?.data["message"] ?? 'Unknown error',
            code: error.response?.data["code"]);
      }
    }
    return SignupResponse(
      success: false,
      messsage: 'Unknown error',
    );
  }
}
