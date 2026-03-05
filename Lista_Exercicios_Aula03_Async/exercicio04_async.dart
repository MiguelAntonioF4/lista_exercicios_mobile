// Exercício 4: Future.wait - Requisições Paralelas
// Compara tempo de execução sequencial vs paralelo

Future<List<String>> buscarProdutos() async {
  await Future.delayed(Duration(seconds: 2));
  return ['Produto A', 'Produto B', 'Produto C'];
}

Future<List<String>> buscarCategorias() async {
  await Future.delayed(Duration(seconds: 1));
  return ['Eletrônicos', 'Roupas', 'Esportes'];
}

Future<List<String>> buscarPromocoes() async {
  await Future.delayed(Duration(seconds: 3));
  return ['10% OFF em Eletrônicos', 'Frete grátis acima de R\$200'];
}

Future<List<String>> buscarDestaques() async {
  await Future.delayed(Duration(seconds: 2));
  return ['Smartphone XYZ', 'Tênis Runner Pro'];
}

void main() async {
  // --- Execução SEQUENCIAL ---
  print('=== Execução Sequencial ===');
  final inicioSeq = DateTime.now();

  final produtosSeq = await buscarProdutos();
  final categoriasSeq = await buscarCategorias();
  final promocoesSeq = await buscarPromocoes();
  final destaquesSeq = await buscarDestaques();

  final fimSeq = DateTime.now();
  final tempoSeq = fimSeq.difference(inicioSeq).inMilliseconds;
  print('Tempo sequencial: ${tempoSeq}ms');
  print('Produtos: $produtosSeq');
  print('Categorias: $categoriasSeq');
  print('Promoções: $promocoesSeq');
  print('Destaques: $destaquesSeq\n');

  // --- Execução PARALELA ---
  print('=== Execução Paralela (Future.wait) ===');
  final inicioPar = DateTime.now();

  final resultados = await Future.wait([
    buscarProdutos(),
    buscarCategorias(),
    buscarPromocoes(),
    buscarDestaques(),
  ]);

  final fimPar = DateTime.now();
  final tempoPar = fimPar.difference(inicioPar).inMilliseconds;
  print('Tempo paralelo: ${tempoPar}ms');
  print('Produtos: ${resultados[0]}');
  print('Categorias: ${resultados[1]}');
  print('Promoções: ${resultados[2]}');
  print('Destaques: ${resultados[3]}\n');

  print('⚡ Ganho de tempo: ${tempoSeq - tempoPar}ms mais rápido com paralelismo!');
}