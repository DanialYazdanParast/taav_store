
enum FailureType {
  network,
  server,
  parsing,
  timeout,
  noInternet,
  unauthorized,
  unknown,
}

class Failure {
  final String message;
  final int? statusCode;
  final FailureType type;

  const Failure({
    required this.message,
    this.statusCode,
    this.type = FailureType.unknown,
  });

  // Factory constructors
  factory Failure.network([String? msg]) => Failure(
    message: msg ?? 'خطای شبکه',
    type: FailureType.network,
  );

  factory Failure.server(int? code, [String? msg]) => Failure(
    message: msg ?? 'خطای سرور',
    statusCode: code,
    type: FailureType.server,
  );

  factory Failure.timeout() => const Failure(
    message: 'زمان اتصال به پایان رسید',
    type: FailureType.timeout,
  );

  factory Failure.noInternet() => const Failure(
    message: 'اینترنت متصل نیست',
    type: FailureType.noInternet,
  );

  factory Failure.parsing() => const Failure(
    message: 'خطا در پردازش داده',
    type: FailureType.parsing,
  );

  @override
  String toString() => message;
}


class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() {
    return message;
  }
}