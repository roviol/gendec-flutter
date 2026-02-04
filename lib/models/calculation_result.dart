class CalculationResult {
  String decimalMostrar;
  String entero;
  String parteDecimal;
  String antePeriodo;
  String periodoRep;
  String? numeradorA;
  String? numeradorB;
  String numeradorC;
  String? denominadorA;
  String? denominadorB;
  String denominadorC;
  dynamic resultado;
  String finalStr;

  CalculationResult({
    required this.decimalMostrar,
    required this.entero,
    required this.parteDecimal,
    required this.antePeriodo,
    required this.periodoRep,
    this.numeradorA,
    this.numeradorB,
    required this.numeradorC,
    this.denominadorA,
    this.denominadorB,
    required this.denominadorC,
    required this.resultado,
    required this.finalStr,
  });

  bool get hasError => resultado is String;
}
