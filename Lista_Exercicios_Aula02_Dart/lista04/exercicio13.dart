// Exercício 13: Herança - ContaBancaria
class ContaBancaria {
  String titular;
  double saldo;

  ContaBancaria(this.titular, this.saldo);

  void depositar(double valor) {
    if (valor > 0) {
      saldo += valor;
      print('Depósito de R\$ ${valor.toStringAsFixed(2)} realizado. Saldo: R\$ ${saldo.toStringAsFixed(2)}');
    } else {
      print('Valor de depósito inválido.');
    }
  }

  void sacar(double valor) {
    if (valor > 0 && valor <= saldo) {
      saldo -= valor;
      print('Saque de R\$ ${valor.toStringAsFixed(2)} realizado. Saldo: R\$ ${saldo.toStringAsFixed(2)}');
    } else {
      print('Saldo insuficiente ou valor inválido.');
    }
  }

  void exibirSaldo() {
    print('Titular: $titular | Saldo: R\$ ${saldo.toStringAsFixed(2)}');
  }
}

class ContaPoupanca extends ContaBancaria {
  ContaPoupanca(String titular, double saldo) : super(titular, saldo);

  void aplicarRendimento(double taxa) {
    double rendimento = saldo * taxa;
    saldo += rendimento;
    print('Rendimento de ${(taxa * 100).toStringAsFixed(2)}% aplicado: +R\$ ${rendimento.toStringAsFixed(2)}. Saldo: R\$ ${saldo.toStringAsFixed(2)}');
  }
}

void main() {
  print('=== Exercício 13: Herança - ContaBancaria ===\n');

  print('--- Conta Bancária ---');
  var conta = ContaBancaria('João', 1000.00);
  conta.exibirSaldo();
  conta.depositar(500.00);
  conta.sacar(200.00);
  conta.sacar(2000.00);

  print('\n--- Conta Poupança ---');
  var poupanca = ContaPoupanca('Maria', 2000.00);
  poupanca.exibirSaldo();
  poupanca.depositar(500.00);
  poupanca.aplicarRendimento(0.005); // 0,5% de rendimento
}