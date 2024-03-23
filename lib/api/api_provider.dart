import 'package:dio/dio.dart';
export 'api_provider.dart';

abstract class ApiProvider {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080',
  ));
}
