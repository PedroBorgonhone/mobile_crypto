import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/pages/tela_menu.dart';
import 'package:pedropaulo_cryptos/pages/tela_recuperar_senha.dart';
import 'package:pedropaulo_cryptos/pages/tela_registro.dart';
import 'package:pedropaulo_cryptos/repositories/usuario_repositorio.dart';

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
        MaterialPageRoute(builder: (context) => const TelaMenu()),
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
          color: Color(0xFF165873),
          width: double.infinity,
          margin: EdgeInsets.all(30),
          padding: const EdgeInsets.all(30),

          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                // Texto de Bem Vindo

                Text('Bem Vindo!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2EBDF),
                  ),
                ),
                SizedBox(height: 6),
                Text('Faça o login para continuar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFF2EBDF),
                  ),
                ),

                // Campos de Usuário

                SizedBox(height: 26),
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Usuário',
                    labelStyle: TextStyle(
                      color: Color(0xFFF2EBDF),
                    ),
                  ),
                ),

                // Campo de Senha

                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                    labelStyle: TextStyle(
                      color: Color(0xFFF2EBDF),
                    ),
                  ),
                ),

                // Botão de Entrar

                SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF307B8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFF2EBDF),
                      ),
                    ),
                  ),
                ),

                // Botão de Recuperar Senha

                SizedBox(height: 26),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaRecuperarSenha())
                      );
                  },
                  child: Text(
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

                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaRegistro())
                      );
                  },
                  child: Text(
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