// Exercício 2 (Grupo): API de Clima com Future e Tratamento de Erros
// Simula chamadas assíncronas a uma API de clima com múltiplos cenários de erro

import 'dart:math';

// =====================
// MODELOS DE DADOS
// =====================

class DadosClima {
  final String cidade;
  final double temperatura;
  final double umidade;
  final String condicao;
  final double sensacaoTermica;
  final double velocidadeVento;

  DadosClima({
    required this.cidade,
    required this.temperatura,
    required this.umidade,
    required this.condicao,
    required this.sensacaoTermica,
    required this.velocidadeVento,
  });

  void exibir() {
    print('🌤️  Clima em $cidade');
    print('   🌡️  Temperatura:      ${temperatura.toStringAsFixed(1)}°C');
    print('   🌡️  Sensação Térmica: ${sensacaoTermica.toStringAsFixed(1)}°C');
    print('   💧 Umidade:          ${umidade.toStringAsFixed(0)}%');
    print('   💨 Vento:            ${velocidadeVento.toStringAsFixed(1)} km/h');
    print('   🌥️  Condição:         $condicao');
  }
}

class PrevisaoSemanal {
  final String cidade;
  final List<Map<String, dynamic>> dias;

  PrevisaoSemanal({required this.cidade, required this.dias});

  void exibir() {
    print('\n📅 Previsão Semanal — $cidade');
    print('─────────────────────────────────────');
    for (final dia in dias) {
      print(
        '   ${dia['dia']}: ${dia['min']}°C / ${dia['max']}°C — ${dia['condicao']}',
      );
    }
  }
}

// =====================
// EXCEÇÕES CUSTOMIZADAS
// =====================

class CidadeNaoEncontradaException implements Exception {
  final String cidade;
  CidadeNaoEncontradaException(this.cidade);

  @override
  String toString() => 'CidadeNaoEncontradaException: "$cidade" não encontrada.';
}

class LimiteRequisicaoException implements Exception {
  @override
  String toString() => 'LimiteRequisicaoException: limite de requisições atingido. Tente mais tarde.';
}

class ErroServidorException implements Exception {
  final int codigo;
  ErroServidorException(this.codigo);

  @override
  String toString() => 'ErroServidorException: erro interno do servidor (HTTP $codigo).';
}

// =====================
// SERVIÇO DE CLIMA (simulado)
// =====================

class ServicoClima {
  final Random _random = Random();

  // Banco de dados simulado de cidades
  final Map<String, Map<String, dynamic>> _bancoCidades = {
    'joinville': {
      'temperatura': 22.5,
      'umidade': 80.0,
      'condicao': 'Parcialmente nublado',
      'sensacaoTermica': 21.0,
      'velocidadeVento': 15.0,
    },
    'florianópolis': {
      'temperatura': 26.0,
      'umidade': 75.0,
      'condicao': 'Ensolarado',
      'sensacaoTermica': 28.0,
      'velocidadeVento': 20.0,
    },
    'curitiba': {
      'temperatura': 18.0,
      'umidade': 85.0,
      'condicao': 'Chuvoso',
      'sensacaoTermica': 15.0,
      'velocidadeVento': 25.0,
    },
    'são paulo': {
      'temperatura': 28.0,
      'umidade': 65.0,
      'condicao': 'Nublado',
      'sensacaoTermica': 30.0,
      'velocidadeVento': 10.0,
    },
  };

  // Simula busca de clima atual
  Future<DadosClima> buscarClimaAtual(String cidade) async {
    print('[API] Buscando clima para "$cidade"...');
    await Future.delayed(Duration(seconds: 2));

    // Simula erro de servidor ocasional (20% de chance)
    if (_random.nextInt(10) < 2) {
      throw ErroServidorException(500);
    }

    final chave = cidade.toLowerCase();

    if (!_bancoCidades.containsKey(chave)) {
      throw CidadeNaoEncontradaException(cidade);
    }

    final dados = _bancoCidades[chave]!;

    // Adiciona variação aleatória pequena para simular dados reais
    return DadosClima(
      cidade: cidade,
      temperatura: dados['temperatura'] + (_random.nextDouble() * 2 - 1),
      umidade: dados['umidade'] + (_random.nextDouble() * 4 - 2),
      condicao: dados['condicao'],
      sensacaoTermica: dados['sensacaoTermica'] + (_random.nextDouble() * 2 - 1),
      velocidadeVento: dados['velocidadeVento'],
    );
  }

  // Simula busca de previsão semanal
  Future<PrevisaoSemanal> buscarPrevisaoSemanal(String cidade) async {
    print('[API] Buscando previsão semanal para "$cidade"...');
    await Future.delayed(Duration(seconds: 1));

    final chave = cidade.toLowerCase();

    if (!_bancoCidades.containsKey(chave)) {
      throw CidadeNaoEncontradaException(cidade);
    }

    final base = _bancoCidades[chave]!['temperatura'] as double;
    final diasSemana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    final condicoes = ['Ensolarado', 'Nublado', 'Chuvoso', 'Parcialmente nublado'];

    final dias = diasSemana.map((dia) {
      final variacao = _random.nextDouble() * 6 - 3;
      return {
        'dia': dia,
        'min': (base + variacao - 4).toStringAsFixed(1),
        'max': (base + variacao + 2).toStringAsFixed(1),
        'condicao': condicoes[_random.nextInt(condicoes.length)],
      };
    }).toList();

    return PrevisaoSemanal(cidade: cidade, dias: dias);
  }

  // Simula busca com timeout (API lenta)
  Future<DadosClima> buscarClimaComTimeout(
    String cidade, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    return await buscarClimaAtual(cidade).timeout(timeout);
  }
}

// =====================
// CONTROLADOR PRINCIPAL
// =====================

Future<void> buscarClimaComRetry(
  ServicoClima servico,
  String cidade, {
  int tentativas = 3,
}) async {
  for (int i = 1; i <= tentativas; i++) {
    try {
      print('\n[Tentativa $i/$tentativas] Buscando clima de "$cidade"...');
      final clima = await servico.buscarClimaAtual(cidade);
      clima.exibir();
      return; // Sucesso — sai do loop
    } on CidadeNaoEncontradaException catch (e) {
      print('❌ $e');
      return; // Não adianta tentar novamente
    } on ErroServidorException catch (e) {
      print('⚠️  $e');
      if (i < tentativas) {
        print('   Aguardando 1s antes de tentar novamente...');
        await Future.delayed(Duration(seconds: 1));
      } else {
        print('❌ Todas as tentativas falharam para "$cidade".');
      }
    } catch (e) {
      print('❌ Erro inesperado: $e');
      return;
    }
  }
}

void main() async {
  final servico = ServicoClima();

  print('╔══════════════════════════════════════╗');
  print('║       APP DE CLIMA — DART            ║');
  print('╚══════════════════════════════════════╝\n');

  // --- Busca de múltiplas cidades em paralelo ---
  print('=== Buscando clima de múltiplas cidades em paralelo ===\n');
  final cidades = ['Joinville', 'Florianópolis', 'Curitiba'];

  final inicio = DateTime.now();

  final resultados = await Future.wait(
    cidades.map((cidade) => servico.buscarClimaAtual(cidade).catchError((e) {
      print('⚠️  Erro ao buscar $cidade: $e');
      return DadosClima(
        cidade: cidade,
        temperatura: 0,
        umidade: 0,
        condicao: 'Indisponível',
        sensacaoTermica: 0,
        velocidadeVento: 0,
      );
    })),
  );

  final tempo = DateTime.now().difference(inicio).inMilliseconds;
  print('\n✅ Dados carregados em ${tempo}ms\n');

  for (final clima in resultados) {
    clima.exibir();
    print('');
  }

  // --- Busca + Previsão semanal em paralelo ---
  print('\n=== Previsão Semanal + Clima Atual (paralelo) ===\n');
  try {
    final futures = await Future.wait([
      servico.buscarClimaAtual('São Paulo'),
      servico.buscarPrevisaoSemanal('São Paulo'),
    ]);

    (futures[0] as DadosClima).exibir();
    (futures[1] as PrevisaoSemanal).exibir();
  } on CidadeNaoEncontradaException catch (e) {
    print('❌ $e');
  } on ErroServidorException catch (e) {
    print('⚠️  $e');
  }

  // --- Busca com retry automático ---
  print('\n\n=== Busca com Retry Automático ===');
  await buscarClimaComRetry(servico, 'Joinville', tentativas: 3);

  // --- Cidade inválida ---
  print('\n=== Testando cidade inválida ===');
  await buscarClimaComRetry(servico, 'Cidade Inexistente');

  // --- Busca com timeout ---
  print('\n=== Busca com Timeout (3s) ===\n');
  try {
    final clima = await servico.buscarClimaComTimeout(
      'Curitiba',
      timeout: Duration(seconds: 3),
    );
    clima.exibir();
  } on CidadeNaoEncontradaException catch (e) {
    print('❌ $e');
  } on ErroServidorException catch (e) {
    print('⚠️  Erro de servidor: $e');
  } catch (e) {
    print('⏱️  Timeout: a requisição demorou mais de 3 segundos. $e');
  }

  print('\n✅ App encerrado com sucesso!');
}
