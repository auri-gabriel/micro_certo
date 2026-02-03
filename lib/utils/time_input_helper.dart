import 'package:flutter/services.dart';

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final limitedDigits = digitsOnly.substring(
      0,
      digitsOnly.length > 4 ? 4 : digitsOnly.length,
    );

    String formatted;
    if (limitedDigits.length <= 2) {
      formatted = limitedDigits;
    } else {
      final minutes = limitedDigits.substring(0, limitedDigits.length - 2);
      final seconds = limitedDigits.substring(limitedDigits.length - 2);
      formatted = '$minutes:$seconds';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

double? parseTimeToDecimal(String time) {
  if (time.isEmpty) return null;

  if (time.contains(':')) {
    final parts = time.split(':');
    if (parts.length != 2) return null;

    final minutes = int.tryParse(parts[0]);
    final seconds = int.tryParse(parts[1]);

    if (minutes == null || seconds == null) return null;
    if (seconds >= 60) return null;

    return minutes + (seconds / 60);
  } else {
    final seconds = int.tryParse(time);
    if (seconds == null) return null;
    return seconds / 60;
  }
}

String formatDecimalToTime(double decimalMinutes) {
  final minutes = decimalMinutes.floor();
  final seconds = ((decimalMinutes - minutes) * 60).round();
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}
