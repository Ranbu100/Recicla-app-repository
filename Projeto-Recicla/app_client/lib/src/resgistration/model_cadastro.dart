class User {
  final String nome;
  final String email;
  final String senha;
  final String rua;
  final String numCasa;
  final String bairro;
  final String cep;
  final String? cpf;
  final String? cnpj;
  final String role;

  User({
    required this.nome,
    required this.email,
    required this.senha,
    required this.rua,
    required this.numCasa,
    required this.bairro,
    required this.cep,
    required this.cpf,
    this.cnpj,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'rua': rua,
      'num_casa': numCasa,
      'bairro': bairro,
      'cep': cep,
      'cpf': cpf,
      'cnpj': cnpj,
      'role': role,
    };
  }
}
