import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/preferences_helper.dart';
import 'home_screen.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key});

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final _powerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;

    final power = int.parse(_powerController.text);
    await PreferencesHelper.setMicrowavePower(power);

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  void dispose() {
    _powerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bem-vindo ao MicroCerto')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.microwave, size: 80, color: Colors.orange),
              const SizedBox(height: 32),
              const Text(
                'Configure seu micro-ondas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Digite a potência do seu micro-ondas em watts:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _powerController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Potência (W)',
                  hintText: 'Ex: 800',
                  border: OutlineInputBorder(),
                  suffixText: 'W',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a potência';
                  }
                  final power = int.tryParse(value);
                  if (power == null || power <= 0) {
                    return 'Digite um valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _saveAndContinue,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Continuar', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
