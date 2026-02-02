import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MicroCertoApp());
}

class MicroCertoApp extends StatelessWidget {
  const MicroCertoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroCerto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
