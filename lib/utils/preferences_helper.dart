import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const String _microwavePowerKey = 'microwave_power';
  static const String _referencePowerKey = 'reference_power';
  static const int _defaultReferencePower = 1000;

  static Future<int?> getMicrowavePower() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_microwavePowerKey);
  }

  static Future<void> setMicrowavePower(int power) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_microwavePowerKey, power);
  }

  static Future<int> getReferencePower() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_referencePowerKey) ?? _defaultReferencePower;
  }

  static Future<void> setReferencePower(int power) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_referencePowerKey, power);
  }

  static Future<bool> isConfigured() async {
    final microwavePower = await getMicrowavePower();
    return microwavePower != null;
  }
}
