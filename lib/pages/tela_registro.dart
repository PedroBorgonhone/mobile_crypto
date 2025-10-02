import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/repositories/user_repository.dart';
import 'package:pedropaulo_cryptos/pages/tela_login.dart';

class TelaRegistro extends StatefulWidget {
  const TelaRegistro({super.key});

  @override
  State<TelaRegistro> createState() => _TelaRegistroState();
}

class _TelaRegistroState extends State<TelaRegistro> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userRepository = UsuarioRepositorio();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showCustomSnackbar(context, 'Por favor, preencha todos os campos.', isError: true);
      return;
    }
    if (password != confirmPassword) {
      showCustomSnackbar(context, 'As senhas não coincidem.', isError: true);
      return;
    }
    if (password.length < 3) {
      showCustomSnackbar(context, 'A senha deve ter pelo menos 3 caracteres (apenas para demonstração).', isError: true);
      return;
    }

    final success = _userRepository.registrarUsuario(
      usuario: username,
      email: email,
      senha: password,
    );

    if (success) {
      showCustomSnackbar(context, 'Registro bem-sucedido! Faça login agora.');
      Navigator.pop(context);
    } else {
      showCustomSnackbar(context, 'Falha no registro: Usuário ou E-mail já existe.', isError: true);
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

                // Texto de Registro

                const Text('Registrar-se',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2EBDF),
                  ),
                ),

                // Nome de Usuário

                const SizedBox(height: 26),
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  decoration: InputDecoration(
                    labelText: 'Nome de Usuário',
                    labelStyle: const TextStyle(color: Color(0xFFF2EBDF),),
                    border: OutlineInputBorder()
                  ),
                ),

                // Email do Usuário

                const SizedBox(height: 26),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      color: Color(0xFFF2EBDF),
                    ),
                    border: OutlineInputBorder()
                  ),
                ),

                // Senha do Usuário

                const SizedBox(height: 26),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: const TextStyle(color: Color(0xFFF2EBDF),),
                    border: OutlineInputBorder()
                  ),
                ),

                // Confirmar Senha do Usuário

                const SizedBox(height: 26),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    labelStyle: const TextStyle(color: Color(0xFFF2EBDF),),
                    border: OutlineInputBorder()
                  ),
                ),

                // Botão de Registro

                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF307B8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Registrar-se',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFF2EBDF),
                      ),
                    ),
                  ),
                ),

                // Botão de Cancelar
                
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF2EBDF),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFF2EBDF),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}