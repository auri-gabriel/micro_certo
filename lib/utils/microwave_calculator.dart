class MicrowaveCalculator {
  /// Calcula o tempo ajustado mantendo potência em 100%
  ///
  /// [packageTime] - Tempo indicado na embalagem (em minutos)
  /// [packagePowerPercent] - Potência indicada na embalagem (em %)
  /// [referencePower] - Potência de referência padrão (em watts)
  /// [microwavePower] - Potência do micro-ondas do usuário (em watts)
  static double calculateAdjustedTime({
    required double packageTime,
    required int packagePowerPercent,
    required int referencePower,
    required int microwavePower,
  }) {
    // Calcula a potência real da embalagem em watts
    final packagePowerWatts = (referencePower * packagePowerPercent) / 100;

    // Tempo ajustado = tempo_embalagem × (potencia_embalagem / potencia_microondas)
    return packageTime * (packagePowerWatts / microwavePower);
  }

  /// Calcula a potência ajustada mantendo o tempo original
  ///
  /// [packagePowerPercent] - Potência indicada na embalagem (em %)
  /// [referencePower] - Potência de referência padrão (em watts)
  /// [microwavePower] - Potência do micro-ondas do usuário (em watts)
  ///
  /// Retorna a potência arredondada para o múltiplo de 10 mais próximo
  static int calculateAdjustedPower({
    required int packagePowerPercent,
    required int referencePower,
    required int microwavePower,
  }) {
    // Calcula a potência real da embalagem em watts
    final packagePowerWatts = (referencePower * packagePowerPercent) / 100;

    // Potência ajustada = (potencia_embalagem / potencia_microondas) × 100
    final exactPower = ((packagePowerWatts / microwavePower) * 100).round();

    // Arredonda para o múltiplo de 10 mais próximo (mínimo 10%, máximo 100%)
    return ((exactPower / 10).round() * 10).clamp(10, 100);
  }
}
