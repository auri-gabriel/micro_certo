class FormatHelper {
  static String formatTimeToMinutesSeconds(double decimalMinutes) {
    final minutes = decimalMinutes.floor();
    final seconds = ((decimalMinutes - minutes) * 60).round();

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  static int roundPowerToNearestTen(int power) {
    return ((power / 10).round() * 10).clamp(10, 100);
  }
}
