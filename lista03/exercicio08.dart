// Exercício 8: Lista de Objetos e Filtros
void main() {
  print('=== Exercício 8: Lista de Frutas e Filtros ===\n');

  var frutas = ['maçã', 'banana', 'manga', 'uva', 'morango', 'melancia', 'laranja', 'melão'];
  print('Lista original: $frutas');

  // Filtrar frutas que começam com 'm'
  var comM = frutas.where((f) => f.startsWith('m')).toList();
  print('\nFrutas que começam com "m": $comM');

  // Converter para maiúsculas
  var emMaiusculas = frutas.map((f) => f.toUpperCase()).toList();
  print('\nTodas em maiúsculas: $emMaiusculas');
}