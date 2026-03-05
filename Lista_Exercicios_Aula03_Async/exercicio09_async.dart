// Exercício 9: Broadcast Stream
// Múltiplos listeners recebendo os mesmos dados de formas diferentes

import 'dart:async';

void main() async {
  // Broadcast permite múltiplos ouvintes no mesmo stream
  final controller = StreamController<int>.broadcast();

  int contador = 0;
  int soma = 0;

  // Listener 1: imprime cada número recebido
  controller.stream.listen((n) {
    print('[Listener 1 - Impressão] Número recebido: $n');
  });

  // Listener 2: conta quantos números foram emitidos
  controller.stream.listen((n) {
    contador++;
    print('[Listener 2 - Contador] Total de números recebidos até agora: $contador');
  });

  // Listener 3: acumula a soma dos números
  controller.stream.listen((n) {
    soma += n;
    print('[Listener 3 - Soma] Soma acumulada: $soma');
  });

  // Emite 10 números com pequeno intervalo
  for (int i = 1; i <= 10; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    print('\n--- Emitindo: $i ---');
    controller.sink.add(i);
  }

  await controller.close();

  print('\n=== Resultado Final ===');
  print('Total emitido: $contador números');
  print('Soma total: $soma');
}