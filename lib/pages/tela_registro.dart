// lib/pages/tela_registro.dart

import 'package:flutter/material.dart';
// 1. IMPORTAR OS NOVOS SERVIÇOS
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedropaulo_cryptos/services/auth_service.dart'; // Nosso serviço de Auth
import 'package:pedropaulo_cryptos/services/firestore_service.dart'; // NOSSO NOVO SERVIÇO DE DB
import 'package:pedropaulo_cryptos/pages/tela_login.dart'; // Para o showCustomSnackbar

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
  
  // 2. INSTANCIAR AMBOS OS SERVIÇOS
  final _authService = AuthService();
  final _firestoreService = FirestoreService(); // <- ADICIONADO

  // (novo) Estado de carregamento para o botão
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 3. ATUALIZAR A FUNÇÃO DE REGISTRO
  void _register() async {
    final username = _usernameController.text.trim(); 
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validações locais (continuam iguais)
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showCustomSnackbar(context, 'Por favor, preencha todos os campos.', isError: true);
      return;
    }
    if (password != confirmPassword) {
      showCustomSnackbar(context, 'As senhas não coincidem.', isError: true);
      return;
    }
    if (password.length < 6) { // Ajustado para 6, o mínimo do Firebase
      showCustomSnackbar(context, 'A senha deve ter pelo menos 6 caracteres.', isError: true);
      return;
    }

    // Ativa o loading
    setState(() => _isLoading = true);

    // --- NOVA LÓGICA COM FIREBASE (AUTH + FIRESTORE) ---
    try {
      // 4. PASSO 1: Criar usuário na "Portaria" (Auth)
      User? newUser = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 5. Se deu certo (usuário não é nulo)
      if (newUser != null) {
        
        // 6. PASSO 2: Salvar dados extras na "Pasta" (Firestore)
        // Usamos o UID (crachá) do usuário como link!
        await _firestoreService.saveUserData(
          uid: newUser.uid,
          username: username,
          email: email,
        );
        
        showCustomSnackbar(context, 'Registro bem-sucedido! Faça login agora.');
        
        // 7. Volta para a tela de Login
        if (mounted) Navigator.pop(context);
      }

    } on FirebaseAuthException catch (e) {
      // 8. Trata erros específicos do Firebase Auth
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
      // 9. Trata qualquer outro erro (ex: erro do Firestore)
      showCustomSnackbar(context, 'Erro desconhecido: $e', isError: true);
    }

    // Desativa o loading
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // O seu 'build' (parte visual) só tem uma pequena mudança no botão:
    
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
                  // ... (Seu texto de 'Registrar-se', etc. continuam aqui)
                  const Text(
                    'Registrar-se',
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
                        labelStyle: const TextStyle(
                          color: Color(0xFFF2EBDF),
                        ),
                        border: OutlineInputBorder()),
                  ),

                  // Email do Usuário
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

                  // Senha do Usuário
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

                  // Confirmar Senha do Usuário
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

                  // Botão de Registro (MODIFICADO)
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      // 10. Desativa o botão se _isLoading for true
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF307B8C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      // 11. Mostra um 'loading' ou o texto
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
                ]),
          ),
        ),
      ),
    );
  }
}