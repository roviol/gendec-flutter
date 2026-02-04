import 'package:flutter_test/flutter_test.dart';
import 'package:gendec/services/calculator_service.dart';

void main() {
  group('CalculatorService', () {
    final calculatorService = CalculatorService();

    test('calcula fraction without period', () {
      final result = calculatorService.calcula(0.345, 0);
      expect(result.entero, '0');
      expect(result.parteDecimal, '.345');
      expect(result.hasError, false);
    });

    test('calcula fraction with period 1', () {
      final result = calculatorService.calcula(0.345, 1);
      expect(result.entero, '0');
      expect(result.periodoRep, '5');
      expect(result.hasError, false);
    });

    test('calcula fraction with period 2', () {
      final result = calculatorService.calcula(0.3456, 2);
      expect(result.periodoRep, '56');
      expect(result.hasError, false);
    });

    test('returns error when period too long', () {
      final result = calculatorService.calcula(0.34, 5);
      expect(result.hasError, true);
      expect(result.resultado, 'Periodo mayor que la parte decimal');
    });

    test('calculates integer value', () {
      final result = calculatorService.calcula(0.5, 0);
      expect(result.resultado, 5);
    });
  });
}
