import '../models/usuario.dart';

class UsuarioRepositorio {

  static final UsuarioRepositorio _instancia = UsuarioRepositorio._interno();
  factory UsuarioRepositorio() => _instancia;

  UsuarioRepositorio._interno() {
    // Usuário teste
    registrarUsuario(
      usuario: 'teste',
      email: 'teste@gmail.com',
      senha: '123',
    );
  }

  // Banco de dados em memória

  final Map<String, Usuario> _usuarios = {};

  // Usuario Logado

  Usuario? _usuarioLogado;
  Usuario? get usuarioLogado => _usuarioLogado;

  // Função Registrar

  bool registrarUsuario({
    required String usuario,
    required String email,
    required String senha,
  }) {

    if (_usuarios.containsKey(usuario) || 
        _usuarios.values.any((user) => user.email == email)) {
      return false;
    }

    final novoUsuario = Usuario(
      usuario: usuario,
      email: email,
      senha: senha,
    );

    _usuarios[usuario] = novoUsuario;
    print('Usuário registrado: $usuario');
    return true; // Registro bem-sucedido
  }

  // Função Login

  Usuario? login({
    required String usuario,
    required String senha,
  }) {
    final usuarioAux = _usuarios[usuario];
    if (usuarioAux != null && usuarioAux.senha == senha) {
      _usuarioLogado = usuarioAux;
      return usuarioAux;
    }
    return null;
  }

  // Função atualizar

  Usuario? atualizarUsuario({
    required String usuarioAntigo,
    required String novoUsuario,
    required String novoEmail,
  }) {
    final usuarioAux = _usuarios[usuarioAntigo];

    if (usuarioAux == null) {
      return null;
    }

    // Verifica nome
    if (usuarioAntigo != novoUsuario && _usuarios.containsKey(novoUsuario)) {
      return null;
    }

    // Verifica email
    if (usuarioAux.email != novoEmail && _usuarios.values.any((user) => user.email == novoEmail)) {
      return null;
    }

    if (usuarioAntigo != novoUsuario) {
      _usuarios.remove(usuarioAntigo);
    }
    
    usuarioAux.usuario = novoUsuario; 
    usuarioAux.email = novoEmail;

    _usuarios[novoUsuario] = usuarioAux;
    
    if (_usuarioLogado?.usuario == usuarioAntigo || _usuarioLogado?.usuario == novoUsuario) {
      _usuarioLogado = usuarioAux;
    }

    print('Usuário atualizado: ${usuarioAux.usuario}');
    return usuarioAux;
  }

  // Função Recuperar Senha

  Usuario? encontraUsuario(String email) {
    try {
      return _usuarios.values.firstWhere((usuario) => usuario.email == email);
    } catch (e) {
      return null;
    }
  }

  // Função Troca Senha

  bool trocaSenha({
    required String email,
    required String novaSenha,
  }) {
    final usuarioAux = encontraUsuario(email);

    if (usuarioAux != null) {
      _usuarios.remove(usuarioAux.usuario); 

      final novoUsuario = Usuario(
        usuario: usuarioAux.usuario,
        email: usuarioAux.email,
        senha: novaSenha, 
      );

      _usuarios[novoUsuario.usuario] = novoUsuario; 
      print('Senha atualizada para o usuário: ${novoUsuario.usuario}');
      return true;
    }
    return false;
  }
}