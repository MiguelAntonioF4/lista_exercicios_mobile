// Exercício 11: Classe Básica - Produto
class Produto {
  String nome;
  double preco;
  int estoque;

  Produto(this.nome, this.preco, this.estoque);

  void exibirInfo() {
    print('Produto: $nome | R\$ ${preco.toStringAsFixed(2)} | Estoque: $estoque unidades');
  }
}

void main() {
  print('=== Exercício 11: Classe Produto ===\n');

  var p1 = Produto('Notebook Dell', 3499.90, 10);
  var p2 = Produto('Mouse Logitech', 129.90, 50);
  var p3 = Produto('Teclado Mecânico', 349.90, 25);

  p1.exibirInfo();
  p2.exibirInfo();
  p3.exibirInfo();
}