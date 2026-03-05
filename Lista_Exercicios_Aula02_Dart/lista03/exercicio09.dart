// Exercício 9: Map de Produtos
Map<int, String> produtos = {
  1: 'Notebook',
  2: 'Mouse',
  3: 'Teclado',
  4: 'Monitor',
  5: 'Headset',
};

String? buscarProduto(int id) {
  if (produtos.containsKey(id)) {
    return produtos[id];
  }
  return null;
}

void listarProdutos() {
  print('\n--- Lista de Produtos ---');
  produtos.forEach((id, nome) => print('  ID $id: $nome'));
}

void removerProduto(int id) {
  if (produtos.containsKey(id)) {
    String nome = produtos[id]!;
    produtos.remove(id);
    print('Produto "$nome" (ID: $id) removido com sucesso.');
  } else {
    print('Produto com ID $id não encontrado.');
  }
}

void main() {
  print('=== Exercício 9: Map de Produtos ===');

  listarProdutos();

  print('\n--- Busca por ID ---');
  String? encontrado = buscarProduto(3);
  print('Busca ID 3: ${encontrado ?? "Não encontrado"}');

  String? naoEncontrado = buscarProduto(99);
  print('Busca ID 99: ${naoEncontrado ?? "Não encontrado"}');

  print('\n--- Remoção ---');
  removerProduto(2);
  removerProduto(10);

  listarProdutos();
}