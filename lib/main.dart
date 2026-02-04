import 'package:flutter/material.dart';
import 'services/calculator_service.dart';
import 'models/calculation_result.dart';

void main() {
  runApp(const GendecApp());
}

class GendecApp extends StatelessWidget {
  const GendecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gendec',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CalculatorService _calculatorService = CalculatorService();
  final TextEditingController _decimalController = TextEditingController(text: '0.345');
  int _periodo = 1;
  CalculationResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    final decimal = double.tryParse(_decimalController.text) ?? 0.0;
    setState(() {
      _result = _calculatorService.calcula(decimal, _periodo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generador de Fracciones'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _decimalController,
              decoration: const InputDecoration(
                labelText: 'Decimal',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Período: ', style: TextStyle(fontSize: 16)),
                Text('$_periodo', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: _periodo.toDouble(),
              min: 0,
              max: 6,
              divisions: 6,
              onChanged: (value) {
                setState(() {
                  _periodo = value.toInt();
                });
                _calculate();
              },
            ),
            const SizedBox(height: 24),
            if (_result != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _result!.hasError ? Colors.red[100] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Decimal: ${_result!.decimalMostrar}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    if (_result!.hasError)
                      Text(_result!.resultado as String, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                    else ...[
                      Text('Entero: ${_result!.entero}', style: const TextStyle(fontSize: 16)),
                      Text('Parte Decimal: ${_result!.parteDecimal}', style: const TextStyle(fontSize: 16)),
                      Text('Ante-período: ${_result!.antePeriodo}', style: const TextStyle(fontSize: 16)),
                      Text('Período: ${_result!.periodoRep}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      Text('Fracción: ${_result!.numeradorC} / ${_result!.denominadorC}${_result!.finalStr}', 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Resultado: ${_result!.resultado}', style: const TextStyle(fontSize: 16)),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
