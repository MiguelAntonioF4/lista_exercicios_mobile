// Exercício 6: Função de Alta Ordem
void main() {
  print('=== Exercício 6: Função de Alta Ordem ===\n');

  double a = 10;
  double b = 5;

  print('a = $a, b = $b');
  print('Soma:         ${executarOperacao(a, b, (x, y) => x + y)}');
  print('Subtração:    ${executarOperacao(a, b, (x, y) => x - y)}');
  print('Multiplicação:${executarOperacao(a, b, (x, y) => x * y)}');
  print('Divisão:      ${executarOperacao(a, b, (x, y) => x / y)}');
}

double executarOperacao(double a, double b, double Function(double, double) operacao) {
  return operacao(a, b);
}