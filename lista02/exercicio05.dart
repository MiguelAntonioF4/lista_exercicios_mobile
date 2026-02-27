// Exercício 5: Parâmetros Nomeados e Opcionais
void main() {
  print('=== Exercício 5: Parâmetros Nomeados e Opcionais ===\n');

  // Apenas o nome (obrigatório)
  saudar(nome: 'Ana');

  // Com título personalizado
  saudar(nome: 'Carlos', titulo: 'Dr.');

  // Com hora
  saudar(nome: 'Maria', titulo: 'Profa.', mostrarHora: true);

  // Usando padrão sem título
  saudar(nome: 'Pedro', mostrarHora: true);
}

void saudar({
  required String nome,
  String titulo = 'Sr.',
  bool mostrarHora = false,
}) {
  String mensagem = 'Olá, $titulo $nome!';

  if (mostrarHora) {
    final agora = DateTime.now();
    mensagem += ' São ${agora.hour}h${agora.minute.toString().padLeft(2, '0')}.';
  }

  print(mensagem);
}