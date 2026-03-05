// Exercício 6: Stream Simples - Contador
// Emite números de 1 a 10 com intervalo de 1 segundo usando async* e yield

Stream<int> contadorStream() async* {
  for (int i = 1; i <= 10; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

void main() async {
  print('Iniciando contador...\n');

  await for (final numero in contadorStream()) {
    print('Número recebido: $numero');
  }

  print('\nContador finalizado!');
}