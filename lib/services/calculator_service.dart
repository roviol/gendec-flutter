import '../models/calculation_result.dart';

class CalculatorService {
  String _padRight(String str, int length, [String char = ' ']) {
    while (str.length < length) {
      str += char;
    }
    return str;
  }

  int _safeEval(String expression) {
    final cleaned = expression.replaceAll(' ', '');
    if (RegExp(r'^\d+$').hasMatch(cleaned)) {
      return int.parse(cleaned);
    }
    if (RegExp(r'^\d+\-\d+$').hasMatch(cleaned)) {
      final parts = cleaned.split('-');
      return int.parse(parts[0]) - int.parse(parts[1]);
    }
    if (RegExp(r'^\d+\+\d+$').hasMatch(cleaned)) {
      final parts = cleaned.split('+');
      return int.parse(parts[0]) + int.parse(parts[1]);
    }
    return 0;
  }

  CalculationResult calcula(double decimal, int periodo) {
    final decimalStr = decimal.toString();
    final dotIndex = decimalStr.indexOf('.');
    final entero = dotIndex >= 0 ? decimalStr.substring(0, dotIndex) : decimalStr;
    final enteroStr = entero.toString();
    final periodoStr = decimalStr.substring(decimalStr.length - periodo);
    final periodoRep = periodoStr;
    final parteDecimal = decimalStr.substring(enteroStr.length);
    final antePeriodo = parteDecimal.substring(0, parteDecimal.length - periodoStr.length);

    if (parteDecimal.length > periodo) {
      if (periodo == 0) {
        final numeradorA = enteroStr;
        final numeradorB = antePeriodo.substring(1);
        final numeradorC = '${int.parse(numeradorA)}$numeradorB';
        const denominadorA = '1';
        final denominadorB = _padRight('0', parteDecimal.length - 1, '0');
        final denominadorC = '$denominadorA$denominadorB';

        return CalculationResult(
          decimalMostrar: decimalStr,
          entero: entero,
          parteDecimal: parteDecimal,
          antePeriodo: antePeriodo,
          periodoRep: periodoRep,
          numeradorA: numeradorA,
          numeradorB: numeradorB,
          numeradorC: numeradorC,
          denominadorA: denominadorA,
          denominadorB: denominadorB,
          denominadorC: denominadorC,
          resultado: _safeEval(numeradorC),
          finalStr: '',
        );
      } else {
        final decimalMostrar = '$decimalStr$periodoStr$periodoStr...';
        final numeradorA = '${int.parse(enteroStr + parteDecimal.substring(1))}';
        final numeradorB = '${int.parse(enteroStr + antePeriodo.substring(1))}';

        late String numeradorC;
        if (numeradorB == '0') {
          numeradorC = numeradorA;
        } else {
          numeradorC = '$numeradorA - $numeradorB';
        }

        final denominadorA = _padRight('9', periodoRep.length, '9');
        final denominadorB = _padRight('', antePeriodo.length - 1, '0');
        final denominadorC = '$denominadorA$denominadorB';

        return CalculationResult(
          decimalMostrar: decimalMostrar,
          entero: entero,
          parteDecimal: parteDecimal,
          antePeriodo: antePeriodo,
          periodoRep: periodoRep,
          numeradorA: numeradorA,
          numeradorB: numeradorB,
          numeradorC: numeradorC,
          denominadorA: denominadorA,
          denominadorB: denominadorB,
          denominadorC: denominadorC,
          resultado: _safeEval(numeradorC),
          finalStr: '...',
        );
      }
    } else {
      return CalculationResult(
        decimalMostrar: '',
        entero: entero,
        parteDecimal: parteDecimal,
        antePeriodo: antePeriodo,
        periodoRep: periodoRep,
        numeradorC: 'Error',
        denominadorC: '',
        resultado: 'Periodo mayor que la parte decimal',
        finalStr: '',
      );
    }
  }
}
