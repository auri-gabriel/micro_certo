import 'package:flutter/material.dart';
import '../utils/preferences_helper.dart';
import 'initial_setup_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkConfiguration();
  }

  Future<void> _checkConfiguration() async {
    final isConfigured = await PreferencesHelper.isConfigured();

    if (!mounted) return;

    if (!isConfigured) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const InitialSetupScreen()),
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
