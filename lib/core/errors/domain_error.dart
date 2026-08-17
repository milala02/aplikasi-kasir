class DomainError implements Exception {
  final String code;
  final String message;

  const DomainError({
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    return '$code: $message';
  }
}
