// Exercício 10: Stream de Eventos do Usuário com Debounce
// Simula eventos aleatórios e processa apenas o último após 1s de inatividade

import 'dart:async';
import 'dart:math';

// Tipos de eventos simulados
enum TipoEvento { clique, scroll, input }

// Gera um evento aleatório a cada 500ms
Stream<String> streamEventos() async* {
  final random = Random();
  final tipos = TipoEvento.values;

  for (int i = 0; i < 15; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    final tipo = tipos[random.nextInt(tipos.length)];
    final evento = '${tipo.name.toUpperCase()} #${i + 1}';
    yield evento;
  }
}

// Implementação manual de debounce usando Timer
Stream<String> debounce(Stream<String> source, Duration delay) {
  late StreamController<String> controller;
  Timer? timer;

  controller = StreamController<String>(
    onListen: () {
      source.listen(
        (evento) {
          // Cancela o timer anterior e reinicia
          timer?.cancel();
          timer = Timer(delay, () {
            controller.add(evento); // Só emite após inatividade
          });
        },
        onDone: () {
          timer?.cancel();
          controller.close();
        },
      );
    },
  );

  return controller.stream;
}

void main() async {
  print('📡 Monitorando eventos do usuário...\n');

  final eventos = streamEventos();

  // Ouve os eventos brutos
  eventos.listen((e) => print('  [RAW] Evento detectado: $e'));

  // Aplica debounce de 1 segundo e processa apenas o último
  print('\n⏳ Aguardando debounce (1s de inatividade)...\n');

  final eventosComDebounce = debounce(streamEventos(), Duration(seconds: 1));

  await for (final evento in eventosComDebounce) {
    print('✅ [PROCESSADO após debounce]: $evento\n');
  }

  print('Monitoramento encerrado.');
}