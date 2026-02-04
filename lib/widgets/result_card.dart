import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String optionLabel;
  final String timeText;
  final String powerText;
  final Color? backgroundColor;

  const ResultCard({
    super.key,
    required this.optionLabel,
    required this.timeText,
    required this.powerText,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              optionLabel,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              timeText,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              powerText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
