import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/repositories/motion_bar_repositorio.dart';
import 'tela_recuperar_senha.dart';
import 'tela_registro.dart';
import '../repositories/usuario_repositorio.dart'; 

void showCustomSnackbar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red.shade700 : const Color(0xFF307B8C),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userRepository = UsuarioRepositorio();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showCustomSnackbar(context, 'Por favor, preencha todos os campos.', isError: true);
      return;
    }

    final user = _userRepository.login(usuario: username, senha: password);

    if (user != null) {
      showCustomSnackbar(context, 'Login bem-sucedido! Bem-vindo, ${user.usuario}.');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainTabNavigator()),
      );
    } else {
      showCustomSnackbar(context, 'Usuário ou senha inválidos.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: const Color(0xFF165873),
          width: double.infinity,
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(30),

          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                // Texto de Bem Vindo

                const Text('Bem Vindo!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2EBDF),
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Faça o login para continuar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFF2EBDF),
                  ),
                ),

                // Campos de Usuário

                const SizedBox(height: 26),
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Usuário',
                    labelStyle: TextStyle(
                      color: Color(0xFFF2EBDF),
                    ),
                  ),
                ),

                // Campo de Senha

                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                    labelStyle: TextStyle(
                      color: Color(0xFFF2EBDF),
                    ),
                  ),
                ),

                // Botão de Entrar

                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF307B8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFF2EBDF),
                      ),
                    ),
                  ),
                ),

                // Botão de Recuperar Senha

                const SizedBox(height: 26),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaRecuperarSenha())
                      );
                  },
                  child: const Text(
                    'Esqueceu a Senha?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF2EBDF),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFF2EBDF),
                    ),
                  ),
                ),

                // Botão de Registro

                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaRegistro())
                      );
                  },
                  child: const Text(
                    'Não possui uma conta? Registre-se',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF2EBDF),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFF2EBDF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
