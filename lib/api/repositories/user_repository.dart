import 'dart:io';

import 'package:machen_app/api/api_provider.dart';
import 'package:machen_app/api/models/user/update_response.dart';
import 'package:dio/dio.dart';

class UserRepository extends ApiProvider {
  Future<UserUpdateResponse> update(
      String token, String? username, String? name, String? email) async {
    try {
      Response response = await dio.post("/user/update",
          options: Options(headers: {"authorization": "Bearer $token"}),
          data: {
            "username": username,
            "name": name,
            "email": email,
          });

      return UserUpdateResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioException) {
        return UserUpdateResponse(
            success: false,
            messsage: error.response?.data["message"] ?? 'Unknown error',
            code: error.response?.data["code"]);
      }
    }
    return UserUpdateResponse(success: false, messsage: 'Unknown error');
  }

  Future<bool> uploadProfilePicture(String token, File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    try {
      await dio.post(
        "/user/upload-profile-picture",
        data: formData,
        options: Options(headers: {"authorization": "Bearer $token"}),
      );
      return true;
    } catch (error) {
      if (error is DioException) {
        return false;
      }
      return false;
    }
  }
}
