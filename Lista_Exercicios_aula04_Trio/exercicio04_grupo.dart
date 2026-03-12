// Exercício 4 (Grupo): Refatorando Código com Null Safety
// Demonstra o ANTES (sem null safety) e o DEPOIS (com null safety correto)
// usando ?., ??, !, late e tipos nullable/non-nullable

// =====================
// ANTES DA REFATORAÇÃO
// (comentado — apenas para referência didática)
// =====================
//
// class Usuario {
//   String nome;         // Poderia ser null sem aviso
//   String email;        // Mesma situação
//   String? telefone;    // Intencionalmente nullable
//   Endereco endereco;   // Poderia causar null pointer em runtime
//
//   Usuario(this.nome, this.email, this.endereco);
// }
//
// void exibirUsuario(Usuario u) {
//   // Sem verificação de null — poderia crashar
//   print(u.nome.toUpperCase());
//   print(u.telefone.length); // CRASH se telefone for null
//   print(u.endereco.cidade); // CRASH se endereco for null
// }

// =====================
// DEPOIS DA REFATORAÇÃO — com null safety correto
// =====================

// --- Modelo de Endereço ---

class Endereco {
  final String rua;
  final String cidade;
  final String estado;
  final String? complemento; // Nullable — complemento é opcional

  const Endereco({
    required this.rua,
    required this.cidade,
    required this.estado,
    this.complemento,
  });

  @override
  String toString() {
    // ?? para fornecer fallback quando complemento é null
    final comp = complemento != null ? ', $complemento' : '';
    return '$rua$comp — $cidade/$estado';
  }
}

// --- Modelo de Perfil (inicialização lazy com late) ---

class Perfil {
  late String bio; // late: será inicializado antes do primeiro uso
  final List<String> interesses;

  Perfil({required this.interesses}) {
    // bio é inicializado aqui — garantimos que nunca será nulo ao ser lido
    bio = interesses.isEmpty
        ? 'Sem biografia informada.'
        : 'Interessado em: ${interesses.join(', ')}.';
  }
}

// --- Modelo de Usuário completamente null-safe ---

class Usuario {
  final String nome;             // Non-nullable — sempre obrigatório
  final String email;            // Non-nullable — sempre obrigatório
  final String? telefone;        // Nullable — pode não ter telefone
  final String? apelido;         // Nullable — pode não ter apelido
  final Endereco? endereco;      // Nullable — endereço é opcional
  final Perfil? perfil;          // Nullable — perfil é opcional

  const Usuario({
    required this.nome,
    required this.email,
    this.telefone,
    this.apelido,
    this.endereco,
    this.perfil,
  });

  // Getter null-safe: usa ?? para valor padrão
  String get nomeExibicao => apelido ?? nome;

  // Getter usando ?. (acesso seguro a nullable)
  String get cidadeOuDesconhecida => endereco?.cidade ?? 'Cidade não informada';

  void exibirInfo() {
    print('👤 Usuário: $nomeExibicao');
    print('   📧 Email:    $email');

    // ?. — não crasha se telefone for null
    // ?? — valor padrão caso seja null
    print('   📱 Telefone: ${telefone ?? "Não informado"}');

    // Acesso aninhado seguro com ?.
    print('   📍 Endereço: ${endereco?.toString() ?? "Não informado"}');

    // Acesso ao complemento dentro do endereço — duplo null-safe
    print('   🏠 Compl.:   ${endereco?.complemento ?? "Sem complemento"}');

    // Acesso a bio dentro do perfil — com ?.
    print('   📝 Bio:      ${perfil?.bio ?? "Sem perfil cadastrado"}');

    // Usando ?. para acessar lista dentro de nullable
    final qtdInteresses = perfil?.interesses.length ?? 0;
    print('   🏷️  Interesses: $qtdInteresses cadastrado(s)');
  }
}

// =====================
// FUNÇÕES NULL-SAFE
// =====================

// Retorna Future<String?> — pode não encontrar o usuário
Future<String?> buscarEmailPorNome(String nome, List<Usuario> usuarios) async {
  await Future.delayed(Duration(milliseconds: 300));
  try {
    return usuarios.firstWhere((u) => u.nome == nome).email;
  } catch (_) {
    return null; // null quando não encontrado — null safety explícito
  }
}

// Formata telefone de forma segura
String formatarTelefone(String? telefone) {
  // Uso de ?? para fallback
  final t = telefone ?? '';
  if (t.isEmpty) return 'Não informado';

  // ! seguro aqui: já garantimos que t não está vazio
  if (t.length == 11) {
    return '(${t.substring(0, 2)}) ${t.substring(2, 7)}-${t.substring(7)}';
  }
  return t;
}

// Processa lista nullable de interesses com segurança
void exibirInteresses(List<String>? interesses) {
  // Uso de ?? para lista vazia como fallback
  final lista = interesses ?? [];
  if (lista.isEmpty) {
    print('   Nenhum interesse cadastrado.');
    return;
  }
  for (final i in lista) {
    print('   • $i');
  }
}

// =====================
// SIMULAÇÃO ASYNC COM NULL SAFETY
// =====================

Future<Usuario?> buscarUsuarioRemoto(String email) async {
  await Future.delayed(Duration(milliseconds: 500));
  // Simula que apenas um email é encontrado
  if (email == 'ana@email.com') {
    return Usuario(
      nome: 'Ana Costa',
      email: email,
      telefone: '47999990001',
      endereco: Endereco(
        rua: 'Rua das Flores, 123',
        cidade: 'Joinville',
        estado: 'SC',
        complemento: 'Apto 42',
      ),
      perfil: Perfil(interesses: ['Flutter', 'Dart', 'Mobile']),
    );
  }
  return null; // Retorno nullable explícito
}

// =====================
// MAIN
// =====================

void main() async {
  print('╔══════════════════════════════════════╗');
  print('║    NULL SAFETY — ANTES E DEPOIS      ║');
  print('╚══════════════════════════════════════╝\n');

  // --- Usuário completo ---
  final u1 = Usuario(
    nome: 'Ana Costa',
    email: 'ana@email.com',
    telefone: '47999990001',
    apelido: 'Aninha',
    endereco: Endereco(
      rua: 'Rua das Flores, 123',
      cidade: 'Joinville',
      estado: 'SC',
      complemento: 'Apto 42',
    ),
    perfil: Perfil(interesses: ['Flutter', 'Dart', 'UI/UX']),
  );

  // --- Usuário com campos opcionais nulos ---
  final u2 = Usuario(
    nome: 'Bruno Lima',
    email: 'bruno@email.com',
    // telefone: null (omitido)
    // apelido: null (omitido)
    // endereco: null (omitido)
    // perfil: null (omitido)
  );

  // --- Usuário parcialmente preenchido ---
  final u3 = Usuario(
    nome: 'Carlos Mendes',
    email: 'carlos@email.com',
    telefone: '11988880002',
    endereco: Endereco(
      rua: 'Av. Paulista, 900',
      cidade: 'São Paulo',
      estado: 'SP',
      // complemento omitido — null por padrão
    ),
  );

  final usuarios = [u1, u2, u3];

  // --- Exibindo informações de cada usuário ---
  print('=== Informações dos Usuários ===\n');
  for (final u in usuarios) {
    u.exibirInfo();
    print('');
  }

  // --- Demonstração dos operadores null safety ---
  print('=== Demonstração dos Operadores ===\n');

  // ?. — acesso seguro
  print('?. (Null-aware access):');
  print('   u1.telefone?.length = ${u1.telefone?.length}');
  print('   u2.telefone?.length = ${u2.telefone?.length} (telefone é null)');

  // ?? — coalescência nula
  print('\n?? (Null coalescing):');
  print('   u1.apelido ?? "Sem apelido" = ${u1.apelido ?? "Sem apelido"}');
  print('   u2.apelido ?? "Sem apelido" = ${u2.apelido ?? "Sem apelido"}');

  // ! — null assertion (apenas quando temos certeza)
  print('\n! (Null assertion — usar com cuidado):');
  if (u1.telefone != null) {
    // Verificamos antes de usar ! — nunca use sem garantia!
    print('   u1.telefone! = ${u1.telefone!}');
    print('   Formatado: ${formatarTelefone(u1.telefone!)}');
  }

  // Acesso aninhado ?.
  print('\n?. encadeado (nullable dentro de nullable):');
  print('   u1.endereco?.complemento = ${u1.endereco?.complemento}');
  print('   u2.endereco?.complemento = ${u2.endereco?.complemento}');
  print('   u3.endereco?.complemento = ${u3.endereco?.complemento}');

  // --- Busca assíncrona com nullable ---
  print('\n=== Busca Assíncrona com Null Safety ===\n');

  final emailEncontrado = await buscarEmailPorNome('Ana Costa', usuarios);
  print('Email de Ana: ${emailEncontrado ?? "Não encontrado"}');

  final emailNaoEncontrado = await buscarEmailPorNome('João', usuarios);
  print('Email de João: ${emailNaoEncontrado ?? "Não encontrado"}');

  // --- Busca remota nullable ---
  print('\n=== Busca Remota (Future<Usuario?>) ===\n');

  final usuarioRemoto = await buscarUsuarioRemoto('ana@email.com');
  // Verificação segura antes de usar o resultado
  if (usuarioRemoto != null) {
    print('✅ Usuário encontrado remotamente:');
    usuarioRemoto.exibirInfo();
  }

  final naoEncontrado = await buscarUsuarioRemoto('inexistente@email.com');
  print('\n🔍 Busca por email inexistente:');
  print('   Resultado: ${naoEncontrado?.nome ?? "Usuário não encontrado"}');

  // --- Interesses com null safety ---
  print('\n=== Lista Nullable de Interesses ===\n');
  print('Interesses de Ana:');
  exibirInteresses(u1.perfil?.interesses);

  print('Interesses de Bruno (sem perfil):');
  exibirInteresses(u2.perfil?.interesses);

  print('\n✅ Código null-safe executado sem crashes!');
}
