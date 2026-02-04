class FormatHelper {
  static String formatTimeToMinutesSeconds(int totalSeconds) {
    final minutes = (totalSeconds / 60).floor();
    final seconds = (totalSeconds % 60).round();

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  static int roundPowerToNearestTen(int power) {
    return ((power / 10).round() * 10).clamp(10, 100);
  }
}
