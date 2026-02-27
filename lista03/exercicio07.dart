// Exercício 7: Manipulação de Listas
void main() {
  print('=== Exercício 7: Manipulação de Listas ===\n');

  List<int> numeros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  print('Lista inicial: $numeros');

  // Adicionar 11 ao final
  numeros.add(11);
  print('Após adicionar 11: $numeros');

  // Remover o número 5
  numeros.remove(5);
  print('Após remover o 5: $numeros');

  print('\nTamanho da lista: ${numeros.length}');
  print('Primeiro elemento: ${numeros.first}');
  print('Último elemento: ${numeros.last}');

  print('\nTodos os elementos:');
  numeros.forEach((n) => print('  $n'));
}