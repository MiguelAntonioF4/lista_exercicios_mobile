// Exercício 14: Interface e Implementação - Classe Abstrata
abstract class Veiculo {
  String modelo;

  Veiculo(this.modelo);

  void acelerar(); // método abstrato
}

class Carro extends Veiculo {
  Carro(String modelo) : super(modelo);

  @override
  void acelerar() {
    print('$modelo: Acelerando com motor a combustão — Vroooom!');
  }
}

class Moto extends Veiculo {
  Moto(String modelo) : super(modelo);

  @override
  void acelerar() {
    print('$modelo: Acelerando na moto — Niaaaaw!');
  }
}

void main() {
  print('=== Exercício 14: Classe Abstrata e Polimorfismo ===\n');

  List<Veiculo> veiculos = [
    Carro('Civic'),
    Carro('Corolla'),
    Moto('CB 600'),
    Moto('Ninja 400'),
  ];

  for (var veiculo in veiculos) {
    veiculo.acelerar();
  }
}