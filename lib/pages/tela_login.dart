// lib/pages/tela_login.dart

import 'package:flutter/material.dart';
// 1. IMPORTAR OS NOVOS SERVIÇOS
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedropaulo_cryptos/services/auth_service.dart'; // Nosso serviço

import 'package:pedropaulo_cryptos/repositories/motion_bar_repositorio.dart';
import 'tela_recuperar_senha.dart';
import 'tela_registro.dart';
// import '../repositories/usuario_repositorio.dart'; // <- REMOVIDO

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
  // 2. MUDAR 'USERNAME' PARA 'EMAIL'
  // final _usernameController = TextEditingController(); // <- REMOVIDO
  final _emailController = TextEditingController(); // <- ADICIONADO
  final _passwordController = TextEditingController();
  
  // 3. TROCAR O REPOSITÓRIO ANTIGO PELO NOVO SERVIÇO
  // final _userRepository = UsuarioRepositorio(); // <- REMOVIDO
  final _authService = AuthService(); // <- ADICIONADO

  bool _isLoading = false; // Estado de loading

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 4. ATUALIZAR A FUNÇÃO DE LOGIN
  void _login() async {
    // final username = _usernameController.text.trim(); // <- REMOVIDO
    final email = _emailController.text.trim(); // <- ADICIONADO
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showCustomSnackbar(context, 'Por favor, preencha e-mail e senha.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // --- NOVA LÓGICA COM FIREBASE ---
    try {
      // 5. Tenta fazer login com o serviço
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 6. Se deu certo (usuário não é nulo)
      if (user != null) {
        showCustomSnackbar(context, 'Login bem-sucedido! Bem-vindo.');
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainTabNavigator()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // 7. Trata erros específicos do Firebase
      String errorMessage = 'Erro ao fazer login.';
      if (e.code == 'invalid-email') {
        errorMessage = 'O formato do e-mail é inválido.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Credenciais inválidas. Verifique seu e-mail e senha.';
      }
      showCustomSnackbar(context, errorMessage, isError: true);
    } catch (e) {
      showCustomSnackbar(context, 'Erro desconhecido: $e', isError: true);
    }

    setState(() => _isLoading = false);
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
                // ... (Texto de 'Bem Vindo' continua igual)
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
                
                // 8. ATUALIZAR CAMPO DE USUÁRIO PARA EMAIL
                const SizedBox(height: 26),
                TextField(
                  controller: _emailController, // <- MUDADO
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  keyboardType: TextInputType.emailAddress, // Bônus
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email', // <- MUDADO
                    labelStyle: TextStyle(
                      color: Color(0xFFF2EBDF),
                    ),
                  ),
                ),

                // Campo de Senha (continua igual)
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

                // Botão de Entrar (MODIFICADO)
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    // 9. Desativa o botão se estiver carregando
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF307B8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // 10. Mostra 'loading' ou o texto
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFF2EBDF),
                            ),
                          ),
                  ),
                ),
                
                // ... (Restante dos botões 'Esqueceu a Senha' e 'Registre-se' continuam iguais)
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