// Exercício 3: Sequência de Operações Assíncronas
// Cada função depende do resultado da anterior

Future<String> autenticar() async {
  await Future.delayed(Duration(seconds: 1));
  print('[1] Autenticado com sucesso.');
  return 'token_abc123';
}

Future<Map<String, dynamic>> buscarPerfil(String token) async {
  await Future.delayed(Duration(seconds: 1));

  if (token.isEmpty) throw Exception('Token inválido!');

  print('[2] Perfil carregado.');
  return {'id': 'user_42', 'nome': 'Carlos Souza', 'email': 'carlos@email.com'};
}

Future<List<String>> buscarPedidos(String userId) async {
  await Future.delayed(Duration(seconds: 1));

  if (userId.isEmpty) throw Exception('UserId inválido!');

  print('[3] Pedidos carregados.');
  return ['Pedido #001 - Tênis', 'Pedido #002 - Camiseta', 'Pedido #003 - Mochila'];
}

void main() async {
  print('Iniciando fluxo de autenticação...\n');

  try {
    final token = await autenticar();
    final perfil = await buscarPerfil(token);
    final pedidos = await buscarPedidos(perfil['id']);

    print('\n--- Resumo ---');
    print('Usuário: ${perfil['nome']} (${perfil['email']})');
    print('Pedidos:');
    for (final pedido in pedidos) {
      print('  - $pedido');
    }
  } catch (e) {
    print('Erro no fluxo: $e');
  }
}