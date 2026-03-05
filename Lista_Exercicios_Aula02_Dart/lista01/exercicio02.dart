// Exercício 2: const vs final na Prática
void main() {
  const pi = 3.14159;
  final dataAtual = DateTime.now();

  print('=== Exercício 2: const vs final ===');
  print('pi = $pi (const)');
  print('dataAtual = $dataAtual (final)');

  // Tentativa de reatribuição:
  // pi = 3.14;       // ERRO: const não pode ser reatribuído em tempo algum.
  //                  // 'pi' é uma constante de compilação — seu valor é fixado
  //                  // antes mesmo do programa rodar.

  // dataAtual = DateTime.now(); // ERRO: final só pode ser atribuído uma vez.
  //                             // Diferente de const, final é resolvido em
  //                             // tempo de execução, mas após a primeira
  //                             // atribuição não pode ser alterado.

  print('\n--- Diferença principal ---');
  print('const: valor fixo em tempo de COMPILAÇÃO.');
  print('final: valor fixo em tempo de EXECUÇÃO (mas apenas na primeira atribuição).');
}