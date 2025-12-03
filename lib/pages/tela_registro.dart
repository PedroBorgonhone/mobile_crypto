import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedropaulo_cryptos/services/auth_service.dart';
import 'package:pedropaulo_cryptos/services/firestore_service.dart';
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
  
  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
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
    if (password.length < 6) {
      showCustomSnackbar(context, 'A senha deve ter pelo menos 6 caracteres.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      User? newUser = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (newUser != null) {
        
        await _firestoreService.saveUserData(
          uid: newUser.uid,
          username: username,
          email: email,
        );
        
        showCustomSnackbar(context, 'Registro bem-sucedido! Faça login agora.');
        
        if (mounted) Navigator.pop(context);
      }

    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Ocorreu um erro no registro.';
      if (e.code == 'weak-password') {
        errorMessage = 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Este e-mail já está em uso.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'O e-mail fornecido é inválido.';
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
                  const Text(
                    'Registrar-se',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF2EBDF),
                    ),
                  ),

                  const SizedBox(height: 26),
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Color(0xFFF2EBDF)),
                    decoration: InputDecoration(
                        labelText: 'Nome de Usuário',
                        labelStyle: const TextStyle(
                          color: Color(0xFFF2EBDF),
                        ),
                        border: OutlineInputBorder()),
                  ),

                  const SizedBox(height: 26),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress, // Bônus: teclado de email
                    style: const TextStyle(color: Color(0xFFF2EBDF)),
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                          color: Color(0xFFF2EBDF),
                        ),
                        border: OutlineInputBorder()),
                  ),

                  const SizedBox(height: 26),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Color(0xFFF2EBDF)),
                    decoration: InputDecoration(
                        labelText: 'Senha (mín. 6 caracteres)',
                        labelStyle: const TextStyle(
                          color: Color(0xFFF2EBDF),
                        ),
                        border: OutlineInputBorder()),
                  ),

                  const SizedBox(height: 26),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    style: const TextStyle(color: Color(0xFFF2EBDF)),
                    decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        labelStyle: const TextStyle(
                          color: Color(0xFFF2EBDF),
                        ),
                        border: OutlineInputBorder()),
                  ),

                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF307B8C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Registrar-se',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFFF2EBDF),
                              ),
                            ),
                    ),
                  ),
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
                ]),
          ),
        ),
      ),
    );
  }
}