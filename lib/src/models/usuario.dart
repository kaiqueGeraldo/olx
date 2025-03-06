class Usuario {
  String? idUsuario;
  String? nome;
  String? email;
  String? senha;

  Usuario({
    this.idUsuario,
    this.nome,
    this.email,
    this.senha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'nome': nome,
      'email': email,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['id_usuario'],
      nome: map['nome'] ?? 'Usuário',
      email: map['email'] ?? '',
    );
  }
}
