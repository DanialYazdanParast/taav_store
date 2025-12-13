import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:taav_store/src/commons/utils/toast_util.dart';
import 'package:taav_store/src/infoStructure/commons/app_configs.dart';
import 'package:taav_store/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

class NetworkService extends GetxService {
  static NetworkService get to => Get.find();

  late final Dio dio;

  NetworkService() {
    _initDio();
  }

  void _initDio() {
    dio = Dio(_createBaseOptions());
    _configureSslPinning();
    _addInterceptors();
  }

  BaseOptions _createBaseOptions() {
    return BaseOptions(
      baseUrl: AppConfigs.baseUrl,
      connectTimeout: const Duration(seconds: AppConfigs.connectTimeout),
      receiveTimeout: const Duration(seconds: AppConfigs.defaultTimeout),
      //  headers: _getDefaultHeaders(),
      validateStatus: (status) => status != null && status < 500,
    );
  }

  // Map<String, dynamic> _getDefaultHeaders() {
  //   return {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Accept-Language': 'fa',
  //   };
  // }

  void _configureSslPinning() {
    if (kDebugMode) {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        };
      }
    }
  }

  Interceptor _createDelayInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        await Future.delayed(const Duration(seconds: 0));
        handler.next(options);
      },
    );
  }

  void _addInterceptors() {
    if (kDebugMode) {
      dio.interceptors.add(_createLogInterceptor());

      dio.interceptors.add(_createDelayInterceptor());
    }

    dio.interceptors.add(_createMainInterceptor());
  }

  Interceptor _createLogInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('┌─────────────────────────────────────');
        debugPrint('│ REQUEST: ${options.method} ${options.uri}');
        debugPrint('│ Headers: ${options.headers}');
        if (options.data != null) {
          debugPrint('│ Body: ${options.data}');
        }
        debugPrint('└─────────────────────────────────────');
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('┌─────────────────────────────────────');
        debugPrint(
          '│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
        );
        debugPrint('│ Data: ${response.data}');
        debugPrint('└─────────────────────────────────────');
        handler.next(response);
      },
      onError: (error, handler) {
        debugPrint('┌─────────────────────────────────────');
        debugPrint('│ ERROR: ${error.type} ${error.requestOptions.uri}');
        debugPrint('│ Message: ${error.message}');
        debugPrint('└─────────────────────────────────────');
        handler.next(error);
      },
    );
  }

  Interceptor _createMainInterceptor() {
    return InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept-Language'] = Get.locale?.languageCode ?? 'fa';

    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  /// مدیریت خطاها
  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401) {
      await _handleUnauthorized();
      return handler.reject(error);
    }

    if (error.requestOptions.extra['showError'] == true) {
      _showErrorSnackbar(error);
    }

    handler.next(error);
  }

  Future<void> _handleUnauthorized() async {
    // await GetStorage().remove('access_token');

    // انتقال به صفحه ورود
    // Get.offAllNamed('/login');
  }

  void _showErrorSnackbar(DioException error) {
    ToastUtil.show(_parseErrorMessage(error), type: ToastType.error);
  }

  Future<String?> _getAuthToken() async {
    // return await GetStorage().read('access_token');
    return null;
  }

  String _parseErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TKeys.timeoutMessage.tr;

      case DioExceptionType.badResponse:
        return _parseResponseError(error.response);

      case DioExceptionType.cancel:
        return TKeys.requestCancelled.tr;

      case DioExceptionType.connectionError:
        return TKeys.checkInternetConnection.tr;

      case DioExceptionType.badCertificate:
        return TKeys.badCertificate.tr;

      case DioExceptionType.unknown:
      default:
        if (error.message != null && error.message!.contains('Exception')) {
          return TKeys.unknownNetworkError.tr;
        }
        return error.message ?? TKeys.unexpectedError.tr;
    }
  }

  /// تجزیه خطای پاسخ سرور
  String _parseResponseError(Response? response) {
    if (response == null) return 'خطای سرور';

    final data = response.data;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
      if (data.containsKey('error')) {
        return data['error'].toString();
      }
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map) {
          return errors.values.first.toString();
        }
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }
    }
    return _getStatusCodeMessage(response.statusCode);
  }

  String _getStatusCodeMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'درخواست نامعتبر';
      case 401:
        return 'دسترسی غیرمجاز';
      case 403:
        return 'دسترسی ممنوع';
      case 404:
        return 'یافت نشد';
      case 500:
        return 'خطای سرور';
      case 503:
        return 'سرویس در دسترس نیست';
      default:
        return 'خطای سرور ($statusCode)';
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool showError = true,
  }) async {
    return dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: _mergeOptions(options, showError),
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool showError = true,
  }) async {
    return dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _mergeOptions(options, showError),
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool showError = true,
  }) async {
    return dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _mergeOptions(options, showError),
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool showError = true,
  }) async {
    return dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _mergeOptions(options, showError),
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool showError = true,
  }) async {
    return dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _mergeOptions(options, showError),
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
    bool showError = true,
  }) async {
    final fileName = filePath.split('/').last;

    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(filePath, filename: fileName),
      ...?data,
    });

    return dio.post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      onSendProgress: onSendProgress,
      options: _mergeOptions(
        options ?? Options(contentType: 'multipart/form-data'),
        showError,
      ),
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> uploadMultipleFiles<T>(
    String path,
    List<String> filePaths, {
    String fieldName = 'files',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
    bool showError = true,
  }) async {
    final files = await Future.wait(
      filePaths.map((path) async {
        final fileName = path.split('/').last;
        return MultipartFile.fromFile(path, filename: fileName);
      }),
    );

    final formData = FormData.fromMap({fieldName: files, ...?data});

    return dio.post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      onSendProgress: onSendProgress,
      options: _mergeOptions(
        options ?? Options(contentType: 'multipart/form-data'),
        showError,
      ),
      cancelToken: cancelToken,
    );
  }

  Future<Response> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool showError = true,
  }) async {
    return dio.download(
      url,
      savePath,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      options: _mergeOptions(null, showError),
    );
  }

  Options _mergeOptions(Options? options, bool showError) {
    return (options ?? Options()).copyWith(
      extra: {...?options?.extra, 'showError': showError},
    );
  }

  void cancelAllRequests() {
    dio.close(force: true);
  }
}
