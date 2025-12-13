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
    message: msg ?? 'Network Error',
    type: FailureType.network,
  );

  factory Failure.server(int? code, [String? msg]) => Failure(
    message: msg ?? 'Server Error',
    statusCode: code,
    type: FailureType.server,
  );

  factory Failure.timeout() => const Failure(
    message: 'Connection timed out',
    type: FailureType.timeout,
  );

  factory Failure.noInternet() => const Failure(
    message: 'No internet connection',
    type: FailureType.noInternet,
  );

  factory Failure.parsing() => const Failure(
    message: 'Data processing error',
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