class StaffException implements Exception {
  final String message;

  StaffException(this.message);

  @override
  String toString() => "$message";
}
