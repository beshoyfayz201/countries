// ignore_for_file: implementation_imports


import 'package:countriesmms/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:countriesmms/core/services/network_service/endpoints.dart';
import 'package:flutter/material.dart';


import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
}

class DioImpl extends DioHelper {
  DioImpl();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 8),
    ),
  )..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 100));

  @override
  Future<dynamic> get({
    String? base,
    required String endPoint,
    dynamic data,
    dynamic query,
    String? token,
    CancelToken? cancelToken,
    int? timeOut,
    bool isMultipart = false,
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = Duration(seconds: timeOut);
    }

    // dio.options.headers = {
    //   if (isMultipart) 'Content-Type': 'multipart/form-data',
    //   if (!isMultipart) 'Content-Type': 'application/json',
    //   if (!isMultipart) 'Accept': 'application/json',
    //   "x-version": '1.0',
    //   // "x-lang": CashHelper.getData(CacheKeys.languageCode) ?? 'ar',
    //   // 'Authorization': 'Bearer ${await CashHelper.getData(CacheKeys.token)}',
    // };
//just for test
    dio.options.baseUrl = base ?? dio.options.baseUrl;
    debugPrint('URL => ${dio.options.baseUrl + endPoint}');
    debugPrint('Header => ${dio.options.headers.toString()}');
    debugPrint('Body => $data');
    debugPrint('Query => $query');

    dio.options.baseUrl = base ?? dio.options.baseUrl;
    return await request(
      call: () async => await dio.get(
        endPoint,
        queryParameters: query,
        data: data,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
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
  }) async {
    if (timeOut != null) {
      dio.options.connectTimeout = Duration(seconds: timeOut);
    }
    dio.options.headers = {
      if (isMultipart) 'Content-Type': 'multipart/form-data',
      if (!isMultipart) 'Content-Type': 'application/json',
      if (!isMultipart) 'Accept': 'application/json',
      if (isMultipart) 'Accept': '*/*',
    };

    return await request(
      call: () async => await dio.post(
        endPoint,
        data: data,
        queryParameters: query,
        onSendProgress: progressCallback,
        cancelToken: cancelToken,
      ),
    );
  }
}

extension on DioHelper {
  Future request({
    required Future<Response> Function() call,
  }) async {
    try {
      final r = await call.call();
      debugPrint("Response_Data => ${r.data}");
      debugPrint("Response_Code => ${r.statusCode}");

      return r;
    } on DioException catch (e) {
      debugPrint("Error_Message => ${e.message}");
      debugPrint("Errorerror => ${e.error.toString()}");
      debugPrint("Error_Type => ${e.type.toString()}");

      switch (e.type) {
        case DioExceptionType.cancel:
          throw PrimaryServerException(
            code: 100,
            error: e.toString(),
            message: "request has been canceled",
          );

        case DioExceptionType.connectionTimeout:
          throw PrimaryServerException(
            code: 100,
            error: e.toString(),
            message: "sorry! your connection has timed out!",
          );
        case DioExceptionType.sendTimeout:
          throw PrimaryServerException(
              code: 100,
              error: e.toString(),
              message: "sorry! your send request has timed out!");
        case DioExceptionType.receiveTimeout:
          throw PrimaryServerException(
              code: 100,
              error: e.toString(),
              message: "sorry! your recieve request has timed out!");
        case DioExceptionType.badResponse:
          // e.response!.statusCode == 401
          // ? resetCredintails()
          // : e.response!.statusCode == 403
          //     ? gotoVerify()
          // :
          throw PrimaryServerException(
              code: 400,
              error: e.response!.data['message'],
              message: e.response!.data['message'].toString());

        default:
          throw PrimaryServerException(
              code: 100, error: e.toString(), message: 'something went wrong!');
      }
    } catch (e) {
      PrimaryServerException exception = e as PrimaryServerException;

      throw PrimaryServerException(
        code: exception.code,
        error: exception.error,
        message: exception.message,
      );
    }
  }
}
