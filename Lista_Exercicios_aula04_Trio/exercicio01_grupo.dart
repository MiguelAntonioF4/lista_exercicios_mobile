// Exercício 1 (Grupo): Sistema de Biblioteca
// Classes, herança, construtores nomeados e polimorfismo

// =====================
// CLASSE BASE — Item de Acervo
// =====================

abstract class ItemAcervo {
  final String titulo;
  final String autor;
  final int anoPublicacao;
  bool disponivel;

  ItemAcervo({
    required this.titulo,
    required this.autor,
    required this.anoPublicacao,
    this.disponivel = true,
  });

  // Método abstrato — cada tipo exibe suas informações próprias
  void exibirInfo();

  void emprestar() {
    if (disponivel) {
      disponivel = false;
      print('✅ "$titulo" emprestado com sucesso!');
    } else {
      print('❌ "$titulo" já está emprestado.');
    }
  }

  void devolver() {
    if (!disponivel) {
      disponivel = true;
      print('✅ "$titulo" devolvido com sucesso!');
    } else {
      print('⚠️  "$titulo" já está disponível no acervo.');
    }
  }
}

// =====================
// SUBCLASSE — Livro
// =====================

class Livro extends ItemAcervo {
  final int numeroPaginas;
  final String genero;

  Livro({
    required super.titulo,
    required super.autor,
    required super.anoPublicacao,
    required this.numeroPaginas,
    required this.genero,
    super.disponivel,
  });

  // Construtor nomeado para livros clássicos (antes de 1980)
  Livro.classico({
    required String titulo,
    required String autor,
    required int anoPublicacao,
    required int numeroPaginas,
  }) : numeroPaginas = numeroPaginas,
       genero = 'Clássico',
       super(titulo: titulo, autor: autor, anoPublicacao: anoPublicacao);

  @override
  void exibirInfo() {
    final status = disponivel ? '📗 Disponível' : '📕 Emprestado';
    print('📖 LIVRO: $titulo');
    print('   Autor: $autor | Ano: $anoPublicacao');
    print('   Gênero: $genero | Páginas: $numeroPaginas');
    print('   Status: $status');
  }
}

// =====================
// SUBCLASSE — Revista
// =====================

class Revista extends ItemAcervo {
  final int edicao;
  final String periodicidade; // mensal, semanal, etc.

  Revista({
    required super.titulo,
    required super.autor,
    required super.anoPublicacao,
    required this.edicao,
    required this.periodicidade,
    super.disponivel,
  });

  @override
  void exibirInfo() {
    final status = disponivel ? '📗 Disponível' : '📕 Emprestado';
    print('📰 REVISTA: $titulo');
    print('   Editora: $autor | Ano: $anoPublicacao');
    print('   Edição: #$edicao | Periodicidade: $periodicidade');
    print('   Status: $status');
  }
}

// =====================
// SUBCLASSE — DVD
// =====================

class DVD extends ItemAcervo {
  final int duracaoMinutos;
  final String classificacao;

  DVD({
    required super.titulo,
    required super.autor,
    required super.anoPublicacao,
    required this.duracaoMinutos,
    required this.classificacao,
    super.disponivel,
  });

  @override
  void exibirInfo() {
    final status = disponivel ? '📗 Disponível' : '📕 Emprestado';
    print('🎬 DVD: $titulo');
    print('   Diretor: $autor | Ano: $anoPublicacao');
    print('   Duração: ${duracaoMinutos}min | Classificação: $classificacao');
    print('   Status: $status');
  }
}

// =====================
// CLASSE — Usuário da Biblioteca
// =====================

class Usuario {
  final String nome;
  final String matricula;
  final List<ItemAcervo> itensEmprestados = [];

  Usuario({required this.nome, required this.matricula});

  void pegarEmprestado(ItemAcervo item) {
    if (itensEmprestados.length >= 3) {
      print('⚠️  $nome já possui o limite de 3 itens emprestados.');
      return;
    }
    item.emprestar();
    if (!item.disponivel) {
      itensEmprestados.add(item);
    }
  }

  void devolverItem(ItemAcervo item) {
    item.devolver();
    itensEmprestados.remove(item);
  }

  void exibirEmprestimos() {
    print('\n📋 Empréstimos de $nome (matrícula: $matricula):');
    if (itensEmprestados.isEmpty) {
      print('   Nenhum item emprestado.');
    } else {
      for (var item in itensEmprestados) {
        print('   - ${item.titulo}');
      }
    }
  }
}

// =====================
// CLASSE — Biblioteca (gerenciadora do acervo)
// =====================

class Biblioteca {
  final String nome;
  final List<ItemAcervo> acervo = [];

  Biblioteca(this.nome);

  void adicionarItem(ItemAcervo item) {
    acervo.add(item);
    print('➕ "${item.titulo}" adicionado ao acervo.');
  }

  void listarAcervo() {
    print('\n╔══════════════════════════════════════╗');
    print('║   ACERVO — $nome');
    print('╚══════════════════════════════════════╝\n');
    for (var item in acervo) {
      item.exibirInfo();
      print('');
    }
  }

  void listarDisponiveis() {
    final disponiveis = acervo.where((i) => i.disponivel).toList();
    print('\n📚 Itens disponíveis: ${disponiveis.length}/${acervo.length}');
    for (var item in disponiveis) {
      print('   - ${item.titulo} (${item.runtimeType})');
    }
  }

  ItemAcervo? buscarPorTitulo(String titulo) {
    try {
      return acervo.firstWhere(
        (i) => i.titulo.toLowerCase().contains(titulo.toLowerCase()),
      );
    } catch (_) {
      return null;
    }
  }
}

// =====================
// MAIN
// =====================

void main() {
  print('📚 Sistema de Biblioteca\n');

  // --- Montando o acervo ---
  final biblioteca = Biblioteca('Biblioteca Senac Joinville');

  final livro1 = Livro(
    titulo: 'Clean Code',
    autor: 'Robert C. Martin',
    anoPublicacao: 2008,
    numeroPaginas: 431,
    genero: 'Tecnologia',
  );

  final livro2 = Livro.classico(
    titulo: 'Dom Casmurro',
    autor: 'Machado de Assis',
    anoPublicacao: 1899,
    numeroPaginas: 256,
  );

  final revista = Revista(
    titulo: 'Revista Info',
    autor: 'Editora Abril',
    anoPublicacao: 2024,
    edicao: 412,
    periodicidade: 'Mensal',
  );

  final dvd = DVD(
    titulo: 'Matrix',
    autor: 'Lana Wachowski',
    anoPublicacao: 1999,
    duracaoMinutos: 136,
    classificacao: '14 anos',
  );

  biblioteca.adicionarItem(livro1);
  biblioteca.adicionarItem(livro2);
  biblioteca.adicionarItem(revista);
  biblioteca.adicionarItem(dvd);

  // --- Exibindo acervo completo ---
  biblioteca.listarAcervo();

  // --- Simulando empréstimos ---
  print('=== Simulando Empréstimos ===\n');

  final usuario1 = Usuario(nome: 'Ana Costa', matricula: 'ADS-2026-001');
  final usuario2 = Usuario(nome: 'Bruno Lima', matricula: 'ADS-2026-002');

  usuario1.pegarEmprestado(livro1);
  usuario1.pegarEmprestado(revista);
  usuario1.pegarEmprestado(livro1); // Já emprestado

  print('');
  usuario2.pegarEmprestado(livro2);
  usuario2.pegarEmprestado(dvd);

  // --- Exibindo empréstimos por usuário ---
  usuario1.exibirEmprestimos();
  usuario2.exibirEmprestimos();

  // --- Disponíveis após empréstimos ---
  biblioteca.listarDisponiveis();

  // --- Devolução ---
  print('\n=== Devolvendo Itens ===\n');
  usuario1.devolverItem(livro1);
  biblioteca.listarDisponiveis();

  // --- Busca por título ---
  print('\n=== Busca por Título ===\n');
  final encontrado = biblioteca.buscarPorTitulo('clean');
  if (encontrado != null) {
    print('🔍 Encontrado:');
    encontrado.exibirInfo();
  } else {
    print('❌ Item não encontrado.');
  }
}
