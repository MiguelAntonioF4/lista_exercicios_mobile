// Exercício 8: Transformando Streams
// Filtra pares, multiplica por 2 e pega os 5 primeiros resultados

Stream<int> numerosStream() async* {
  for (int i = 1; i <= 20; i++) {
    yield i;
  }
}

void main() async {
  print('Processando stream de números (1 a 20)...');
  print('Filtro: apenas pares → multiplicados por 2 → primeiros 5\n');

  await numerosStream()
      .where((n) => n % 2 == 0)   // Filtra somente números pares
      .map((n) => n * 2)           // Multiplica cada par por 2
      .take(5)                     // Pega apenas os 5 primeiros
      .forEach((n) => print('Resultado: $n'));

  print('\nProcessamento concluído!');
}