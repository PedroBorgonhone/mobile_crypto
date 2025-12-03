class Usuario {
  String usuario;
  String email;
  final String senha;
  String? profileImagePath;

  Usuario({
    required this.usuario,
    required this.email,
    required this.senha,
    this.profileImagePath,
  });
}