import '../models/usuario.dart';

class UsuarioRepositorio {

  static final UsuarioRepositorio _instancia = UsuarioRepositorio._interno();
  factory UsuarioRepositorio() => _instancia;

  final Map<String, Usuario> _usuarios = {};

  Usuario? _usuarioLogado;
  Usuario? get usuarioLogado => _usuarioLogado;

  UsuarioRepositorio._interno() {
    registrarUsuario(
      usuario: 'teste',
      email: 'teste@gmail.com',
      senha: '123',
    );
  }

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

  Usuario? atualizarUsuario({
    required String usuarioAntigo,
    required String novoUsuario,
    required String novoEmail,
  }) {
    final usuarioAux = _usuarios[usuarioAntigo];

    if (usuarioAux == null) {
      return null;
    }

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

  Usuario? encontraUsuario(String email) {
    try {
      return _usuarios.values.firstWhere((usuario) => usuario.email == email);
    } catch (e) {
      return null;
    }
  }

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

  bool updateProfileImagePath({
    required String email, 
    required String newPath,
  }) {
    final usuarioAux = encontraUsuario(email);

    if (usuarioAux != null) {
      usuarioAux.profileImagePath = newPath;
      print('Caminho da imagem atualizado para o usuário ${usuarioAux.usuario}');
      
      return true;
    }
    return false;
  }

  void addUserLoginInfo({required String email, required String username}) {
    // 1. Verifica se o usuário já existe usando o método encontraUsuario
    final Usuario? usuarioExistente = encontraUsuario(email); // <--- CORREÇÃO AQUI

    if (usuarioExistente == null) {
        // Se não existir (a busca retornou null), cria um novo objeto Usuario no mock
        
        final novoUsuario = Usuario(
            usuario: username,
            email: email,
            senha: 'FirebaseAuth', // Senha Mockada
            profileImagePath: null,
        );
        
        // O UsuarioRepositorio usa o username como chave primária no map _usuarios
        _usuarios[username] = novoUsuario; 
        print('Sincronizado novo usuário Firebase: $username');

    } else {
        // Se existir, apenas atualiza o username (e-mail e senha mockada permanecem)
        usuarioExistente.usuario = username;
        print('Usuário Firebase $username atualizado no Repositório.');
    }
  }
}