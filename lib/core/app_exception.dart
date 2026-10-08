class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

String errorMessage(Object error) =>
    error is AppException ? error.message : 'Something went wrong. Please try again.';
