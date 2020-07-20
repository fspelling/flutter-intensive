abstract class RequestImc {
  RequestImc next;

  RequestImc(this.next);

  String executeMessageIMC(double imc);
}

class LowWeight extends RequestImc {
  LowWeight(RequestImc next) : super(next);

  @override
  String executeMessageIMC(double imc) {
    if (imc < 18.6) return 'Abaixo do peso (${imc.toStringAsPrecision(4)})';
    return next?.executeMessageIMC(imc);
  }
}

class IdealWeight extends RequestImc {
  IdealWeight(RequestImc next) : super(next);

  @override
  String executeMessageIMC(double imc) {
    if (imc >= 18.6 && imc < 24.9)
      return 'Peso ideal (${imc.toStringAsPrecision(4)})';

    return next?.executeMessageIMC(imc);
  }
}

class AboveWeight extends RequestImc {
  AboveWeight(RequestImc next) : super(next);

  @override
  String executeMessageIMC(double imc) {
    if (imc >= 24.9 && imc < 29.9)
      return 'Levemente acima do peso (${imc.toStringAsPrecision(4)})';

    return next?.executeMessageIMC(imc);
  }
}

class ObesidadeOneWeight extends RequestImc {
  ObesidadeOneWeight(RequestImc next) : super(next);

  @override
  String executeMessageIMC(double imc) {
    if (imc >= 29.9 && imc < 34.9)
      return 'Obesidade grau I (${imc.toStringAsPrecision(4)})';

    return next?.executeMessageIMC(imc);
  }
}

class ObesidadeTwoWeight extends RequestImc {
  ObesidadeTwoWeight(RequestImc next) : super(next);

  @override
  String executeMessageIMC(double imc) {
    if (imc >= 34.9 && imc < 39.9)
      return 'Obesidade grau II (${imc.toStringAsPrecision(4)})';

    return next?.executeMessageIMC(imc);
  }
}

class ObesidadeThreeWeight extends RequestImc {
  ObesidadeThreeWeight(RequestImc next) : super(next);

  @override
  String executeMessageIMC(double imc) {
    if (imc > 40) return 'Obesidade grau III (${imc.toStringAsPrecision(4)})';
    return 'Margem nao encontrada';
  }
}
