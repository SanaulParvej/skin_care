class NetworkResponse<T> {
  final bool isSuccess;
  final int statusCode;
  final String? errorMessage;
  final T? data;

  const NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.errorMessage,
    this.data,
  });
}
