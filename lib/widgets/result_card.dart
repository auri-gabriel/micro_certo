import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String optionLabel;
  final String timeText;
  final String powerText;
  final Color? backgroundColor;
  final bool isRecommended;

  const ResultCard({
    super.key,
    required this.optionLabel,
    required this.timeText,
    required this.powerText,
    this.backgroundColor,
    this.isRecommended = false,
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
            if (isRecommended)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Recomendado',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
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
