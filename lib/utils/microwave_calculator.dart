class MicrowaveCalculator {
  static int calculateAdjustedTime({
    required int packageTime,
    required int packagePowerPercent,
    required int referencePower,
    required int microwavePower,
  }) {
    final packagePowerWatts = (referencePower * packagePowerPercent) / 100;

    final baseTime = packageTime * (packagePowerWatts / microwavePower);

    final safetyMargin = microwavePower > packagePowerWatts ? 1.30 : 1.05;

    return (baseTime * safetyMargin).ceil();
  }

  static int calculateAdjustedPower({
    required int packagePowerPercent,
    required int referencePower,
    required int microwavePower,
  }) {
    final packagePowerWatts = (referencePower * packagePowerPercent) / 100;

    final exactPower = ((packagePowerWatts / microwavePower) * 100).round();

    return ((exactPower / 10).ceil() * 10).clamp(10, 100);
  }
}
