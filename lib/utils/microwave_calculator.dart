class MicrowaveCalculator {
  static int calculateAdjustedTime({
    required int packageTime,
    required int packagePowerPercent,
    required int referencePower,
    required int microwavePower,
  }) {
    final packagePowerWatts = (referencePower * packagePowerPercent) / 100;

    return (packageTime * (packagePowerWatts / microwavePower)).ceil();
  }

  static int calculateAdjustedPower({
    required int packagePowerPercent,
    required int referencePower,
    required int microwavePower,
  }) {
    final packagePowerWatts = (referencePower * packagePowerPercent) / 100;

    final exactPower = ((packagePowerWatts / microwavePower) * 100).round();

    return ((exactPower / 10).round() * 10).clamp(10, 100);
  }
}
