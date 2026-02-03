import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/preferences_helper.dart';
import '../utils/microwave_calculator.dart';
import '../utils/time_input_helper.dart';
import 'settings_screen.dart';
import 'result_screen.dart';

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

    final packageTime = parseTimeToSeconds(_packageTimeController.text);
    if (packageTime == null) return;

    final packagePowerPercent = int.parse(_packagePowerController.text);

    final adjustedTime = MicrowaveCalculator.calculateAdjustedTime(
      packageTime: packageTime,
      packagePowerPercent: packagePowerPercent,
      referencePower: _referencePower!,
      microwavePower: _microwavePower!,
    );

    final adjustedPower = MicrowaveCalculator.calculateAdjustedPower(
      packagePowerPercent: packagePowerPercent,
      referencePower: _referencePower!,
      microwavePower: _microwavePower!,
    );

    // Fecha o teclado antes de navegar
    FocusScope.of(context).unfocus();

    // Navega para a tela de resultado
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          adjustedTime: adjustedTime,
          adjustedPower: adjustedPower,
          packageTime: _packageTimeController.text,
        ),
      ),
    );
  }

  void _clear() {
    _formKey.currentState?.reset();
    setState(() {
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [TimeInputFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Tempo indicado',
                        hintText: 'Ex: 3:30',
                        border: OutlineInputBorder(),
                        helperText: 'Formato: SS, M:SS ou MM:SS',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite o tempo';
                        }
                        final time = parseTimeToSeconds(value);
                        if (time == null || time <= 0) {
                          return 'Digite um tempo válido';
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
                      decoration: InputDecoration(
                        labelText: 'Potência indicada',
                        hintText: 'Ex: 100',
                        border: const OutlineInputBorder(),
                        suffixText: '%',
                        helperText: 'Potência indicada na embalagem',
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.help_outline),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Referência de Potência'),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Se a embalagem indica:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text('Alta: 80-100%'),
                                    SizedBox(height: 8),
                                    Text('Média: 50-70%'),
                                    SizedBox(height: 8),
                                    Text('Baixa: 30-40%'),
                                    SizedBox(height: 8),
                                    Text('Descongelar: 10-20%'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Entendi'),
                                  ),
                                ],
                              ),
                            );
                          },
                          tooltip: 'Ver referência de potência',
                        ),
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
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                            ),
                            child: const Text(
                              'Limpar',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            onPressed: _calculate,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                            ),
                            child: const Text(
                              'Calcular',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
