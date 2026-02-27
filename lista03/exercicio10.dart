// Exercício 10: Set e Operações de Conjunto
void main() {
  print('=== Exercício 10: Set e Operações de Conjunto ===\n');

  Set<int> a = {1, 2, 3, 4, 5};
  Set<int> b = {4, 5, 6, 7, 8};

  print('Conjunto A: $a');
  print('Conjunto B: $b');

  print('\n(1) União (A ∪ B):        ${a.union(b)}');
  print('(2) Interseção (A ∩ B):   ${a.intersection(b)}');
  print('(3) Diferença (A - B):    ${a.difference(b)}');
  print('(4) 3 está no conjunto A? ${a.contains(3)}');
}