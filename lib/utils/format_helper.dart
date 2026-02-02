/// Utilitários para formatação de valores
class FormatHelper {
  /// Converte tempo decimal (em minutos) para formato MM:SS
  ///
  /// Exemplo: 6.9 minutos = "6:54"
  static String formatTimeToMinutesSeconds(double decimalMinutes) {
    final minutes = decimalMinutes.floor();
    final seconds = ((decimalMinutes - minutes) * 60).round();

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Arredonda a potência para o múltiplo de 10 mais próximo
  ///
  /// Exemplo: 63% -> 60%, 68% -> 70%
  static int roundPowerToNearestTen(int power) {
    return ((power / 10).round() * 10).clamp(10, 100);
  }
}
