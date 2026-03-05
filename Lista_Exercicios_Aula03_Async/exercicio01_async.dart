// Exercício 1: Simulando Chamada de API
// Função que retorna um Future<String> com delay de 2 segundos

Future<String> buscarUsuario() {
  return Future.delayed(
    Duration(seconds: 2),
    () => 'Maria Silva',
  );
}

void main() {
  print('Buscando usuário...');

  buscarUsuario().then((nome) {
    print('Usuário encontrado: $nome');
  });
}