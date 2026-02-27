// Exercício 12: Construtores Nomeados
class Produto {
  String nome;
  double preco;
  int estoque;

  // Construtor padrão
  Produto(this.nome, this.preco, this.estoque);

  // Construtor nomeado: produto sem estoque
  Produto.semEstoque(String nome, double preco) : this(nome, preco, 0);

  // Construtor nomeado: produto com 20% de desconto
  Produto.promocao(String nome, double precoOriginal, int estoque)
      : this(nome, precoOriginal * 0.8, estoque);

  void exibirInfo() {
    print('Produto: $nome | R\$ ${preco.toStringAsFixed(2)} | Estoque: $estoque unidades');
  }
}

void main() {
  print('=== Exercício 12: Construtores Nomeados ===\n');

  var p1 = Produto('Notebook Dell', 3499.90, 10);
  print('Produto normal:');
  p1.exibirInfo();

  var p2 = Produto.semEstoque('Monitor LG', 899.90);
  print('\nProduto sem estoque:');
  p2.exibirInfo();

  var p3 = Produto.promocao('Teclado Mecânico', 349.90, 15);
  print('\nProduto em promoção (20% off):');
  p3.exibirInfo();
}