// Exercício 15: Mixins em Ação
mixin Voador {
  void voar() => print('$runtimeType está voando!');
}

mixin Nadador {
  void nadar() => print('$runtimeType está nadando!');
}

mixin Corredor {
  void correr() => print('$runtimeType está correndo!');
}

class Pato with Nadador, Voador {
  String nome;
  Pato(this.nome);
}

class Golfinho with Nadador {
  String nome;
  Golfinho(this.nome);
}

class Avestruz with Corredor {
  String nome;
  Avestruz(this.nome);
}

void main() {
  print('=== Exercício 15: Mixins em Ação ===\n');

  print('--- Pato (nada e voa) ---');
  var pato = Pato('Donald');
  pato.nadar();
  pato.voar();

  print('\n--- Golfinho (nada) ---');
  var golfinho = Golfinho('Flipper');
  golfinho.nadar();

  print('\n--- Avestruz (corre) ---');
  var avestruz = Avestruz('Bob');
  avestruz.correr();
}