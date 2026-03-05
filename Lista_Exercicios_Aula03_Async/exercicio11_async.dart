// Exercício 11: Operadores Null Safety em Async
// Busca configuração com cache local, usando ?. ?? e !

// Cache local simulando armazenamento em memória
Map<String, String> cache = {
  'tema': 'escuro',
  'idioma': 'pt-BR',
};

// Simula busca de configuração em uma API remota
Future<String?> buscarDaAPI(String chave) async {
  await Future.delayed(Duration(seconds: 1));

  // Configurações disponíveis na "API"
  final configsAPI = {
    'notificacoes': 'ativadas',
    'tamanhoFonte': '16',
    'resolucao': '1080p',
  };

  return configsAPI[chave]; // Retorna null se não existir
}

// Busca configuração: primeiro no cache, depois na API
Future<String?> buscarConfiguracao(String chave) async {
  // Usa ?? para verificar cache antes de chamar a API
  final valorCache = cache[chave];

  if (valorCache != null) {
    print('[$chave]  Encontrado no cache: $valorCache');
    return valorCache;
  }

  print('[$chave]  Não encontrado no cache, buscando na API...');
  final valorAPI = await buscarDaAPI(chave);

  if (valorAPI != null) {
    // Armazena no cache para próximas consultas
    cache[chave] = valorAPI;
    print('[$chave] Salvo no cache: $valorAPI');
  } else {
    print('[$chave]  Configuração não encontrada em nenhuma fonte.');
  }

  return valorAPI;
}

void main() async {
  print('=== Sistema de Configurações ===\n');

  final chaves = ['tema', 'idioma', 'notificacoes', 'tamanhoFonte', 'corPrimaria'];

  for (final chave in chaves) {
    final valor = await buscarConfiguracao(chave);

    // Uso do operador ?? para valor padrão quando null
    final exibir = valor ?? 'valor padrão';
    print('  → $chave = $exibir\n');
  }

  // Demonstração do operador ?. (acesso seguro a método de nullable)
  String? configuracaoNula;
  print('Tamanho de configuração nula: ${configuracaoNula?? 0}');

  // Demonstração do operador ! (quando temos certeza que não é null)
  String? configuracaoSegura = await buscarConfiguracao('tema');
  if (configuracaoSegura != null) {
    print('Tema em maiúsculo: ${configuracaoSegura.toUpperCase()}');
  }
}