import 'package:machen_app/models/auth_models.dart';
import 'package:machen_app/resources/api_provider.dart';

class AuthRepository {
  final ApiProvider _apiService = ApiProvider();

  Future<MeUser> login(String username, String password) async {
    try {
      final meUser = await _apiService.login(username, password);
      return meUser;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()} (code: 003)');
    }
  }

  Future<MeUser> signup(String username, String password) async {
    try {
      final response = await _apiService.login(username, password);
      return response;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()} (code: 004)');
    }
  }
}
