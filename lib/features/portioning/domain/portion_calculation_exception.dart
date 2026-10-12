/// Exception yang dilempar oleh CalculatePortionUseCase ketika input
/// atau state data membuat kalkulasi takaran tidak bisa diselesaikan.
///
/// Membawa [userMessage] yang siap ditampilkan di UI (bahasa awam).
/// Berbeda dengan StateError/ArgumentError biasa yang pesannya teknis.
class PortionCalculationException implements Exception {
  /// Pesan yang aman ditampilkan langsung ke pengguna.
  final String userMessage;

  /// Detail teknis opsional untuk debugging/log.
  final String? technicalDetails;

  const PortionCalculationException(
    this.userMessage, {
    this.technicalDetails,
  });

  @override
  String toString() {
    if (technicalDetails == null) return userMessage;
    return '$userMessage ($technicalDetails)';
  }
}
