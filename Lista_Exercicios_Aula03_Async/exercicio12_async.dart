// Exercício 12: Projeto Integrador - Dashboard Assíncrono
// Integra: autenticação, Future.wait, Stream e null safety

import 'dart:async';
import 'dart:math';

// =====================
// MODELOS DE DADOS
// =====================

class Usuario {
  final String id;
  final String nome;
  final String? email; // Nullable para demonstrar null safety

  Usuario({required this.id, required this.nome, this.email});

  @override
  String toString() => 'Usuario(id: $id, nome: $nome, email: ${email ?? "não informado"})';
}

class DadosDashboard {
  final List<String> vendas;
  final List<String> notificacoes;
  final Map<String, dynamic> metricas;
  final List<String>? alertas; // Nullable

  DadosDashboard({
    required this.vendas,
    required this.notificacoes,
    required this.metricas,
    this.alertas,
  });
}

// =====================
// ETAPA 1 — AUTENTICAÇÃO
// =====================

Future<String> autenticar(String usuario, String senha) async {
  print('[Auth] Autenticando usuário "$usuario"...');
  await Future.delayed(Duration(seconds: 1));

  if (senha.length < 4) {
    throw Exception('Senha muito curta. Mínimo de 4 caracteres.');
  }

  final token = 'jwt_token_${Random().nextInt(9999).toString().padLeft(4, '0')}';
  print('[Auth] ✅ Token gerado: $token\n');
  return token;
}

// =====================
// ETAPA 2 — DADOS PARALELOS
// =====================

Future<List<String>> buscarVendas(String token) async {
  await Future.delayed(Duration(seconds: 2));
  return ['Venda #001 - R\$150,00', 'Venda #002 - R\$320,00', 'Venda #003 - R\$89,90'];
}

Future<List<String>> buscarNotificacoes(String token) async {
  await Future.delayed(Duration(seconds: 1));
  return ['Novo pedido recebido', 'Estoque baixo: Produto X', 'Meta mensal atingida! 🎉'];
}

Future<Map<String, dynamic>> buscarMetricas(String token) async {
  await Future.delayed(Duration(seconds: 2));
  return {
    'totalVendas': 559.90,
    'pedidosPendentes': 4,
    'clientesAtivos': 127,
    'ticketMedio': 186.63,
  };
}

Future<List<String>?> buscarAlertas(String token) async {
  await Future.delayed(Duration(seconds: 1));
  // Simula que alertas podem ser nulos (nenhum alerta ativo)
  if (Random().nextBool()) return null;
  return ['Servidor com alta carga', 'Pagamento pendente: Cliente #42'];
}

// =====================
// ETAPA 3 — STREAM DE ATUALIZAÇÕES
// =====================

Stream<String> streamAtualizacoes() async* {
  final atualizacoes = [
    '📦 Novo pedido: Cliente João Silva - R\$210,00',
    '✅ Pedido #045 confirmado e enviado',
    '💳 Pagamento aprovado: Cliente Ana Costa',
    '⚠️ Devolução solicitada: Pedido #032',
    '🎯 Meta diária atingida!',
  ];

  for (final update in atualizacoes) {
    await Future.delayed(Duration(milliseconds: 800));
    yield update;
  }
}

// =====================
// ETAPA 4 — EXIBIÇÃO DO DASHBOARD
// =====================

void exibirDashboard(DadosDashboard dados) {
  print('\n╔══════════════════════════════════╗');
  print('║        DASHBOARD RESUMO          ║');
  print('╚══════════════════════════════════╝\n');

  print('📊 MÉTRICAS:');
  dados.metricas.forEach((chave, valor) {
    print('   • $chave: $valor');
  });

  print('\n🛒 VENDAS RECENTES:');
  for (final venda in dados.vendas) {
    print('   • $venda');
  }

  print('\n🔔 NOTIFICAÇÕES:');
  for (final notif in dados.notificacoes) {
    print('   • $notif');
  }

  // Uso de null safety com ?.
  final alertas = dados.alertas;
  if (alertas != null && alertas.isNotEmpty) {
    print('\n🚨 ALERTAS:');
    for (final alerta in alertas) {
      print('   ⚠️ $alerta');
    }
  } else {
    print('\n✅ Nenhum alerta ativo no momento.');
  }
}

// =====================
// MAIN
// =====================

void main() async {
  print('🚀 Inicializando Dashboard...\n');

  try {
    // --- Etapa 1: Autenticação ---
    final token = await autenticar('admin', 'senha123');

    // --- Etapa 2: Busca paralela de dados ---
    print('[Dashboard] Carregando dados em paralelo...');
    final inicio = DateTime.now();

    final resultados = await Future.wait([
      buscarVendas(token),
      buscarNotificacoes(token),
      buscarMetricas(token),
      buscarAlertas(token),
    ]);

    final tempo = DateTime.now().difference(inicio).inMilliseconds;
    print('[Dashboard] ✅ Dados carregados em ${tempo}ms\n');

    final dados = DadosDashboard(
      vendas: resultados[0] as List<String>,
      notificacoes: resultados[1] as List<String>,
      metricas: resultados[2] as Map<String, dynamic>,
      alertas: resultados[3] as List<String>?,
    );

    // Exibe o dashboard
    exibirDashboard(dados);

    // --- Etapa 3: Stream de atualizações em tempo real ---
    print('\n\n📡 ATUALIZAÇÕES EM TEMPO REAL:');
    print('─────────────────────────────────\n');

    await for (final atualizacao in streamAtualizacoes()) {
      print(atualizacao);
    }

    print('\n─────────────────────────────────');
    print('Dashboard encerrado com sucesso!');
  } on FormatException catch (e) {
    print('❌ Erro de formato: $e');
  } on TimeoutException {
    print('❌ Timeout: o servidor demorou muito para responder.');
  } catch (e) {
    print('❌ Erro geral: $e');
  }
}