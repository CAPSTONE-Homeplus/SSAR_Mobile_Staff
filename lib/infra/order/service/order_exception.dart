class OrderException implements Exception {
  final String message;
  OrderException(this.message);

  @override
  String toString() => 'OrderException: $message';
}
