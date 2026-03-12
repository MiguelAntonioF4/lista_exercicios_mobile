// Exercício 3 (Grupo): Chat em Tempo Real com Stream
// StreamController, broadcast, múltiplos canais, histórico e notificações

import 'dart:async';
import 'dart:math';

// =====================
// MODELOS
// =====================

enum TipoMensagem { texto, entrada, saida, sistema }

class Mensagem {
  final String remetente;
  final String conteudo;
  final DateTime timestamp;
  final TipoMensagem tipo;

  Mensagem({
    required this.remetente,
    required this.conteudo,
    required this.timestamp,
    this.tipo = TipoMensagem.texto,
  });

  String get horaFormatada {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    final s = timestamp.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  String toString() {
    switch (tipo) {
      case TipoMensagem.entrada:
        return '[$horaFormatada] 🟢 $conteudo';
      case TipoMensagem.saida:
        return '[$horaFormatada] 🔴 $conteudo';
      case TipoMensagem.sistema:
        return '[$horaFormatada] ⚙️  $conteudo';
      case TipoMensagem.texto:
        return '[$horaFormatada] 💬 $remetente: $conteudo';
    }
  }
}

// =====================
// CANAL DE CHAT
// =====================

class CanalChat {
  final String nome;
  final StreamController<Mensagem> _controller =
      StreamController<Mensagem>.broadcast();

  final List<Mensagem> historico = [];
  final Set<String> _usuarios = {};

  CanalChat(this.nome) {
    print('📢 Canal "#$nome" criado.\n');
  }

  Stream<Mensagem> get stream => _controller.stream;

  void entrar(String usuario) {
    if (_usuarios.add(usuario)) {
      final msg = Mensagem(
        remetente: 'Sistema',
        conteudo: '$usuario entrou no canal #$nome',
        timestamp: DateTime.now(),
        tipo: TipoMensagem.entrada,
      );
      _emitir(msg);
    }
  }

  void sair(String usuario) {
    if (_usuarios.remove(usuario)) {
      final msg = Mensagem(
        remetente: 'Sistema',
        conteudo: '$usuario saiu do canal #$nome',
        timestamp: DateTime.now(),
        tipo: TipoMensagem.saida,
      );
      _emitir(msg);
    }
  }

  void enviarMensagem(String remetente, String conteudo) {
    if (!_usuarios.contains(remetente)) {
      print('⚠️  $remetente não está no canal #$nome.');
      return;
    }
    final msg = Mensagem(
      remetente: remetente,
      conteudo: conteudo,
      timestamp: DateTime.now(),
    );
    _emitir(msg);
  }

  void _emitir(Mensagem msg) {
    historico.add(msg);
    _controller.sink.add(msg);
  }

  void exibirHistorico() {
    print('\n📜 Histórico do canal #$nome (${historico.length} mensagens):');
    print('─────────────────────────────────────');
    for (final msg in historico) {
      print('  $msg');
    }
    print('─────────────────────────────────────');
  }

  List<String> get usuariosAtivos => _usuarios.toList();

  Future<void> fechar() async {
    final msg = Mensagem(
      remetente: 'Sistema',
      conteudo: 'Canal #$nome encerrado.',
      timestamp: DateTime.now(),
      tipo: TipoMensagem.sistema,
    );
    _emitir(msg);
    await _controller.close();
  }
}

// =====================
// BOT AUTOMÁTICO
// =====================

class BotChat {
  final String nome;
  final Random _random = Random();

  final List<String> _respostas = [
    'Boa pergunta! Deixa eu pensar...',
    'Concordo totalmente!',
    'Hmm, interessante ponto de vista.',
    'Alguém mais quer comentar sobre isso?',
    'Flutter é incrível mesmo! 🚀',
    'Dart e async são top demais!',
    'Boa! Bora codar mais exercícios?',
  ];

  BotChat(this.nome);

  String gerarResposta() => _respostas[_random.nextInt(_respostas.length)];
}

// =====================
// SISTEMA DE NOTIFICAÇÕES (segundo listener)
// =====================

class SistemaNotificacoes {
  int totalMensagens = 0;
  int totalEntradas = 0;
  int totalSaidas = 0;

  void processar(Mensagem msg) {
    switch (msg.tipo) {
      case TipoMensagem.texto:
        totalMensagens++;
        break;
      case TipoMensagem.entrada:
        totalEntradas++;
        break;
      case TipoMensagem.saida:
        totalSaidas++;
        break;
      case TipoMensagem.sistema:
        break;
    }
  }

  void exibirEstatisticas() {
    print('\n📊 Estatísticas do Chat:');
    print('   💬 Mensagens enviadas: $totalMensagens');
    print('   🟢 Entradas no canal:  $totalEntradas');
    print('   🔴 Saídas do canal:    $totalSaidas');
  }
}

// =====================
// MAIN
// =====================

void main() async {
  print('╔══════════════════════════════════════╗');
  print('║     CHAT EM TEMPO REAL — DART        ║');
  print('╚══════════════════════════════════════╝\n');

  // Criando o canal e o sistema de notificações
  final canal = CanalChat('dart-estudos');
  final notificacoes = SistemaNotificacoes();
  final bot = BotChat('DartBot');

  // --- Listener 1: exibe mensagens no console ---
  canal.stream.listen((msg) {
    print('  $msg');
  });

  // --- Listener 2: sistema de notificações / estatísticas ---
  canal.stream.listen((msg) {
    notificacoes.processar(msg);
  });

  // --- Listener 3: bot que responde mensagens de texto ---
  canal.stream.where((msg) => msg.tipo == TipoMensagem.texto).listen((msg) async {
    if (msg.remetente != bot.nome) {
      await Future.delayed(Duration(milliseconds: 600));
      canal.enviarMensagem(bot.nome, bot.gerarResposta());
    }
  });

  // --- Usuários entram no canal ---
  await Future.delayed(Duration(milliseconds: 100));
  canal.entrar('Ana');
  await Future.delayed(Duration(milliseconds: 200));
  canal.entrar('Bruno');
  await Future.delayed(Duration(milliseconds: 200));
  canal.entrar(bot.nome);
  await Future.delayed(Duration(milliseconds: 200));
  canal.entrar('Carlos');

  print('\n👥 Usuários ativos: ${canal.usuariosAtivos.join(', ')}\n');

  // --- Conversas ---
  await Future.delayed(Duration(milliseconds: 300));
  canal.enviarMensagem('Ana', 'Olá pessoal! Prontos para estudar Dart?');

  await Future.delayed(Duration(milliseconds: 900));
  canal.enviarMensagem('Bruno', 'Com certeza! Streams são incríveis.');

  await Future.delayed(Duration(milliseconds: 900));
  canal.enviarMensagem('Carlos', 'Alguém conseguiu terminar os exercícios?');

  await Future.delayed(Duration(milliseconds: 900));
  canal.enviarMensagem('Ana', 'Quase! Só falta o exercício 4.');

  await Future.delayed(Duration(milliseconds: 900));
  canal.enviarMensagem('Bruno', 'Null safety é muito importante!');

  // --- Carlos sai ---
  await Future.delayed(Duration(milliseconds: 900));
  canal.sair('Carlos');

  await Future.delayed(Duration(milliseconds: 500));
  canal.enviarMensagem('Ana', 'Até logo, Carlos!');

  // --- Tentativa de enviar sem estar no canal ---
  await Future.delayed(Duration(milliseconds: 300));
  canal.enviarMensagem('Carlos', 'Ei, ainda consigo mandar mensagem?');

  // --- Aguarda as últimas respostas do bot ---
  await Future.delayed(Duration(seconds: 1));

  // --- Exibe histórico e estatísticas ---
  canal.exibirHistorico();
  notificacoes.exibirEstatisticas();

  // --- Encerra o canal ---
  await canal.fechar();

  print('\n✅ Chat encerrado!');
}
