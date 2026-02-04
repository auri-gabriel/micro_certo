import 'package:flutter/material.dart';
import '../utils/format_helper.dart';
import '../widgets/result_card.dart';

class ResultScreen extends StatelessWidget {
  final double adjustedTime;
  final int adjustedPower;
  final String packageTime;

  const ResultScreen({
    super.key,
    required this.adjustedTime,
    required this.adjustedPower,
    required this.packageTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Use uma destas opções:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Primeira opção
            ResultCard(
              optionLabel: 'Opção 1',
              timeText: FormatHelper.formatTimeToMinutesSeconds(adjustedTime),
              powerText: 'em 100%',
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            const SizedBox(height: 16),

            // Texto "ou"
            const Text(
              'ou',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Segunda opção
            ResultCard(
              optionLabel: 'Opção 2',
              timeText: packageTime,
              powerText: 'em $adjustedPower%',
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
            const SizedBox(height: 32),

            // Botão para calcular novamente
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.calculate),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Calcular Novamente',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
