import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/preferences_helper.dart';
import '../utils/microwave_calculator.dart';
import '../utils/format_helper.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _packageTimeController = TextEditingController();
  final _packagePowerController = TextEditingController(text: '100');
  final _formKey = GlobalKey<FormState>();

  int? _microwavePower;
  int? _referencePower;
  double? _adjustedTime;
  int? _adjustedPower;

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    final microwavePower = await PreferencesHelper.getMicrowavePower();
    final referencePower = await PreferencesHelper.getReferencePower();

    setState(() {
      _microwavePower = microwavePower;
      _referencePower = referencePower;
    });
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final packageTime = double.parse(
      _packageTimeController.text.replaceAll(',', '.'),
    );
    final packagePowerPercent = int.parse(_packagePowerController.text);

    setState(() {
      _adjustedTime = MicrowaveCalculator.calculateAdjustedTime(
        packageTime: packageTime,
        packagePowerPercent: packagePowerPercent,
        referencePower: _referencePower!,
        microwavePower: _microwavePower!,
      );

      _adjustedPower = MicrowaveCalculator.calculateAdjustedPower(
        packagePowerPercent: packagePowerPercent,
        referencePower: _referencePower!,
        microwavePower: _microwavePower!,
      );
    });
  }

  void _clear() {
    setState(() {
      _adjustedTime = null;
      _adjustedPower = null;
      _packageTimeController.clear();
      _packagePowerController.text = '100';
    });
  }

  void _openSettings() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const SettingsScreen()))
        .then((_) => _loadConfiguration());
  }

  @override
  void dispose() {
    _packageTimeController.dispose();
    _packagePowerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MicroCerto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: _microwavePower == null || _referencePower == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Card com info do micro-ondas
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.microwave, size: 32),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Seu micro-ondas: $_microwavePower W',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.info_outline, size: 24),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Referência padrão: $_referencePower W',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Título
                    const Text(
                      'Dados da embalagem',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input tempo da embalagem
                    TextFormField(
                      controller: _packageTimeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Tempo indicado',
                        hintText: 'Ex: 3.5',
                        border: OutlineInputBorder(),
                        suffixText: 'min',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite o tempo';
                        }
                        final time = double.tryParse(
                          value.replaceAll(',', '.'),
                        );
                        if (time == null || time <= 0) {
                          return 'Digite um valor válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Input potência da embalagem (em %)
                    TextFormField(
                      controller: _packagePowerController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Potência indicada',
                        hintText: 'Ex: 100',
                        border: OutlineInputBorder(),
                        suffixText: '%',
                        helperText: 'Potência indicada na embalagem',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite a potência';
                        }
                        final power = int.tryParse(value);
                        if (power == null || power <= 0 || power > 100) {
                          return 'Digite um valor entre 1 e 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Botões
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clear,
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Limpar'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            onPressed: _calculate,
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Calcular',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Resultado
                    if (_adjustedTime != null && _adjustedPower != null)
                      Card(
                        elevation: 4,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 48,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Use uma destas opções:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${FormatHelper.formatTimeToMinutesSeconds(_adjustedTime!)} em 100%',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('ou', style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text(
                                '${_packageTimeController.text} min em $_adjustedPower%',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
