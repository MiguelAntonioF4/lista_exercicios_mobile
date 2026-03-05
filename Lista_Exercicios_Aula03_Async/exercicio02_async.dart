// Exercício 2: Convertendo .then() para async/await
// Reescrita com async/await e tratamento de erros com try/catch

import 'dart:math';

Future<String> buscarUsuario() async {
  await Future.delayed(Duration(seconds: 2));

  // Simula erro aleatório (~50% de chance)
  if (Random().nextBool()) {
    throw Exception('Falha ao buscar usuário: servidor indisponível.');
  }

  return 'Maria Silva';
}

void main() async {
  print('Buscando usuário...');

  try {
    final nome = await buscarUsuario();
    print('Usuário encontrado: $nome');
  } catch (e) {
    print('Erro: $e');
  }
}