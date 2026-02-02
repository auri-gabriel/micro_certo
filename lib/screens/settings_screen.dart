import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/preferences_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _microwavePowerController = TextEditingController();
  final _referencePowerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadCurrentConfiguration();
  }

  Future<void> _loadCurrentConfiguration() async {
    final microwavePower = await PreferencesHelper.getMicrowavePower();
    final referencePower = await PreferencesHelper.getReferencePower();

    if (microwavePower != null) {
      _microwavePowerController.text = microwavePower.toString();
    }
    _referencePowerController.text = referencePower.toString();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final microwavePower = int.parse(_microwavePowerController.text);
    final referencePower = int.parse(_referencePowerController.text);

    await PreferencesHelper.setMicrowavePower(microwavePower);
    await PreferencesHelper.setReferencePower(referencePower);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Configuração salva!')));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _microwavePowerController.dispose();
    _referencePowerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Configuração do micro-ondas do usuário
              const Text(
                'Seu micro-ondas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Potência do seu micro-ondas',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _microwavePowerController,
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

              // Configuração da potência de referência padrão
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Potência de referência',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Valor padrão usado para calcular a potência das embalagens (geralmente 1000W)',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _referencePowerController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Potência de referência (W)',
                  hintText: 'Ex: 1000',
                  border: OutlineInputBorder(),
                  suffixText: 'W',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a potência de referência';
                  }
                  final power = int.tryParse(value);
                  if (power == null || power <= 0) {
                    return 'Digite um valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Quando a embalagem indicar "100%", será usado este valor como referência',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Botão salvar
              FilledButton(
                onPressed: _save,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Salvar', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
