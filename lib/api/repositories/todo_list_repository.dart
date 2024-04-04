import 'package:machen_app/api/api_provider.dart';
import 'package:machen_app/api/models/todo_list/get_list_response.dart';
import 'package:machen_app/api/models/todo_list/get_lists_response.dart';
import 'package:dio/dio.dart';

class TodoListRepository extends ApiProvider {
  Future<ListsGetResponse> getLists(String token) async {
    try {
      Response response = await dio.get("/list",
          options: Options(headers: {"authorization": "Bearer $token"}));

      return ListsGetResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioException) {
        String errMessage = 'Unknown error';
        String errCode = 'Unknown error code';
        try {
          errMessage = error.response?.data["message"];
          errCode = error.response?.data["code"];
        } catch (e) {
          errMessage = 'Unknown error';
        }

        return ListsGetResponse(
          success: false,
          messsage: errMessage,
          code: errCode,
        );
      }
    }
    return ListsGetResponse(success: false, messsage: 'Unknown error');
  }

  Future<ListGetResponse> getList(String token, String listId) async {
    try {
      Response response = await dio.get("/list-item/$listId",
          options: Options(headers: {"authorization": "Bearer $token"}));

      return ListGetResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioException) {
        String errMessage = 'Unknown error';
        String errCode = 'Unknown error code';
        try {
          errMessage = error.response?.data["message"];
          errCode = error.response?.data["code"];
        } catch (e) {
          errMessage = 'Unknown error';
        }

        return ListGetResponse(
          success: false,
          messsage: errMessage,
          code: errCode,
        );
      }
    }
    return ListGetResponse(success: false, messsage: 'Unknown error');
  }
}
