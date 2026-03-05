// Exercício 5: Timeout e Cancelamento
// Cancela operação que demora mais de 3 segundos

import 'dart:async';

Future<String> buscarDadosLentos() async {
  // Simula uma API lenta com delay de 5 segundos
  await Future.delayed(Duration(seconds: 5));
  return 'Dados recebidos com sucesso!';
}

void main() async {
  print('Iniciando busca de dados...');

  try {
    final resultado = await buscarDadosLentos().timeout(
      Duration(seconds: 3),
    );
    print('Resultado: $resultado');
  } on TimeoutException {
    print('⏱️ Operação cancelada: a requisição demorou mais de 3 segundos.');
    print('Por favor, verifique sua conexão ou tente novamente mais tarde.');
  } catch (e) {
    print('Erro inesperado: $e');
  }
}