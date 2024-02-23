import 'package:dio/dio.dart';
import 'package:machen_app/models/auth_models.dart';

export 'api_provider.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _url = 'http://localhost:8080';

  Future<MeUser> login(String emailOrUsername, String password) async {
    try {
      Response response = await _dio.post("$_url/auth/login", data: {
        "emailOrUsername": emailOrUsername,
        "password": password,
      });

      return MeUser.fromJson(response.data["user"], response.data["token"]);
    } catch (error) {
      if (error is DioException) {
        return MeUser.withError(error.response?.data["message"]);
      }
    }
    return MeUser.withError("Unknown error, please try again later");
  }
}
