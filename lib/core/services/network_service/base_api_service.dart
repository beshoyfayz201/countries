import 'package:dio/dio.dart';

abstract class DioHelper {
  Future<dynamic> post({
    String? base,
    required String endPoint,
    dynamic data,
    dynamic query,
    String? token,
    ProgressCallback? progressCallback,
    CancelToken? cancelToken,
    int? timeOut,
    bool isMultipart = false,
  });

  Future<dynamic> get({
    String? base,
    required String endPoint,
    dynamic data,
    dynamic query,
    String? token,
    CancelToken? cancelToken,
    int? timeOut,
    bool isMultipart = false,
  });

  Future<dynamic> download({required String url});
}
