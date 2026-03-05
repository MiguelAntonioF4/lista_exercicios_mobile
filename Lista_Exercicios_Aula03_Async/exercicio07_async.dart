// Exercício 7: StreamController - Chat Simulado
// Simula um chat com StreamController, enviando 5 mensagens

import 'dart:async';

void main() async {
  // Criação do controller
  final controller = StreamController<String>();

  // Listener: imprime cada mensagem recebida
  controller.stream.listen(
    (mensagem) {
      final agora = DateTime.now();
      final hora = '${agora.hour}:${agora.minute.toString().padLeft(2, '0')}';
      print('[$hora]  $mensagem');
    },
    onDone: () => print('\nChat encerrado.'),
    onError: (e) => print('Erro no chat: $e'),
  );

  // Simula envio de mensagens com intervalo de 1 segundo
  final mensagens = [
    'Olá, tudo bem?',
    'Tudo ótimo! E você?',
    'Bem também, obrigado!',
    'Que bom! Vamos estudar Dart?',
    'Claro, adoro programação assíncrona! ',
  ];

  for (final msg in mensagens) {
    await Future.delayed(Duration(seconds: 1));
    controller.sink.add(msg); // Envia mensagem ao stream
  }

  // Fecha o controller ao final
  await controller.close();
}