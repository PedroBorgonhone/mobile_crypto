import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedropaulo_cryptos/services/auth_service.dart';
import 'package:pedropaulo_cryptos/repositories/motion_bar_repositorio.dart';
import 'package:pedropaulo_cryptos/repositories/usuario_repositorio.dart'; // <-- NOVO IMPORT
import 'tela_recuperar_senha.dart';
import 'tela_registro.dart';

// [showCustomSnackbar function remains the same]
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  
  // Instância do repositório para sincronização
  final UsuarioRepositorio _usuarioRepositorio = UsuarioRepositorio(); // <-- NOVO

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showCustomSnackbar(context, 'Por favor, preencha e-mail e senha.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        // --- INÍCIO DA MODIFICAÇÃO CRÍTICA AQUI ---
        // 1. Sincroniza o usuário logado do Firebase com o Repositório/H2 em memória.
        // Assumimos que o username está armazenado no displayName do Firebase User
        // ou que ele será obtido no MainTabNavigator. Para o login, usaremos um placeholder
        // seguro, se o displayName for null, ou o email.
        final String username = user.displayName ?? user.email ?? 'Usuário Sem Nome';
        
        _usuarioRepositorio.addUserLoginInfo(
            email: user.email!, // O e-mail nunca será null no Firebase Auth se o user for != null
            username: username,
        );
        // --- FIM DA MODIFICAÇÃO CRÍTICA ---
        
        showCustomSnackbar(context, 'Login bem-sucedido! Bem-vindo.');
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainTabNavigator()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
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
                
                const SizedBox(height: 26),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  keyboardType: TextInputType.emailAddress, 
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Color(0xFFF2EBDF),
                    ),
                  ),
                ),

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

                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF307B8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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