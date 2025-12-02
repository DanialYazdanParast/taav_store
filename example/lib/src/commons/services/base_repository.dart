import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:flutter/foundation.dart';



abstract class BaseRepository {
  @protected
  Future<Either<Failure, T>> safeCall<T>({
    required Future<Response> Function() request,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await request();

      if (_isSuccessful(response.statusCode)) {
        final data = fromJson(response.data);
        return Right(data);
      }

      return Left(Failure.server(
        response.statusCode,
        _extractMessage(response.data),
      ));
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      debugPrint('❌ Error: $e');
      return Left(Failure(message: e.toString()));
    }
  }

  bool _isSuccessful(int? code) => code != null && code >= 200 && code < 300;

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'];
    }
    return null;
  }

  Failure _handleDioError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
          Failure.timeout(),
      DioExceptionType.connectionError => Failure.noInternet(),
      DioExceptionType.badResponse => Failure.server(e.response?.statusCode),
      _ => Failure.network(e.message),
    };
  }
}