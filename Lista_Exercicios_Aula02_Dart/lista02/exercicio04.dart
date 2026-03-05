// Exercício 4: Função Tradicional e Arrow Function
void main() {
  print('=== Exercício 4: Funções ===');

  print('\n--- Função tradicional ---');
  double resultado1 = calcularArea(5, 10);
  print('Área (5 x 10) = $resultado1');

  print('\n--- Arrow function ---');
  double resultado2 = calcularAreaArrow(5, 10);
  print('Área (5 x 10) = $resultado2');
}

// Função tradicional
double calcularArea(double largura, double altura) {
  return largura * altura;
}

// Arrow function
double calcularAreaArrow(double largura, double altura) => largura * altura;