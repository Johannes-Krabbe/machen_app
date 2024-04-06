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

  Future<bool> deleteList(String token, String listId) async {
    try {
      await dio.delete("/list/$listId",
          options: Options(headers: {"authorization": "Bearer $token"}));
      return true;
    } catch (error) {
      return false;
    }
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

  Future<bool> createItem(
      String token, String listId, String title, String description) async {
    try {
      await dio.post("/list-item/create",
          data: {
            "title": title,
            "listId": listId,
            "description": description,
          },
          options: Options(headers: {"authorization": "Bearer $token"}));
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteItem(String token, String id) async {
    try {
      await dio.delete("/list-item/$id",
          options: Options(headers: {"authorization": "Bearer $token"}));
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateItem(String token, String? itemId, String? title,
      String? description, bool? completed) async {
    try {
      await dio.post(
        "/list-item/update/$itemId",
        options: Options(headers: {"authorization": "Bearer $token"}),
        data: {
          "title": title,
          "description": description,
          "completed": completed,
        },
      );
      return true;
    } catch (error) {
      return false;
    }
  }
}
