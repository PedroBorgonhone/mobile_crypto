// lib/pages/tela_perfil.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedropaulo_cryptos/pages/tela_login.dart'; // Para o snackbar e navegação
import 'package:pedropaulo_cryptos/services/auth_service.dart'; // Para o Logout
import 'package:pedropaulo_cryptos/services/firestore_service.dart'; // Para Salvar

class TelaPerfil extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> userData;

  const TelaPerfil({
    super.key,
    required this.uid,
    required this.userData,
  });

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userData['username']);
    _emailController = TextEditingController(text: widget.userData['email']);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // 1. FUNÇÃO _salvarAlteracoes (AGORA É SÓ O "GERENTE")
  void _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) {
      return; // Se o formulário for inválido, não faz nada
    }

    setState(() => _isLoading = true);

    final String novoUsername = _usernameController.text.trim();
    final String novoEmail = _emailController.text.trim();

    // 2. VERIFICA SE O EMAIL MUDOU
    final bool emailMudou = novoEmail != widget.userData['email'];

    try {
      if (emailMudou) {
        // 3. OPERAÇÃO SENSÍVEL: Pede a senha
        await _mostrarDialogReautenticacao(novoUsername, novoEmail);
        
        // Se a re-autenticação foi bem-sucedida, o e-mail foi verificado
        showCustomSnackbar(context, 'Sucesso! Verifique seu *novo* e-mail para confirmar a mudança.');
        
        // Atualiza os dados no Firestore (isso é seguro)
        await _firestoreService.updateUserData(
          uid: widget.uid,
          newUsername: novoUsername,
          newEmail: novoEmail,
        );

      } else {
        // 4. OPERAÇÃO SEGURA: Só mudou o username
        // Apenas atualiza o Firestore (Auth não precisa ser chamado)
        await _firestoreService.updateUserData(
          uid: widget.uid,
          newUsername: novoUsername,
          newEmail: novoEmail, // Envia o email (que é o mesmo)
        );
        showCustomSnackbar(context, 'Perfil atualizado com sucesso!');
      }

    } on FirebaseAuthException catch (e) {
      // 5. Trata erros da re-autenticação (ex: senha errada)
      String msg = 'Erro ao salvar.';
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        msg = 'Senha incorreta. Alterações não salvas.';
      }
      showCustomSnackbar(context, msg, isError: true);
    } catch (e) {
      showCustomSnackbar(context, 'Erro: $e', isError: true);
    }

    setState(() => _isLoading = false);
  }

  // 6. NOVA FUNÇÃO (Pop-up de Senha)
  Future<void> _mostrarDialogReautenticacao(String novoUsername, String novoEmail) async {
    final passwordController = TextEditingController();
    
    // 'Completer' é usado para esperar o usuário fechar o dialog
    // É uma forma avançada de 'await'
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // O usuário NÃO PODE fechar clicando fora
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Operação Sensível'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Para mudar seu e-mail, por favor, insira sua senha atual.'),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Sua Senha Atual',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                // Lança um erro para o _salvarAlteracoes saber que foi cancelado
                throw Exception('Operação cancelada pelo usuário.'); 
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                final password = passwordController.text.trim();
                if (password.isEmpty) return;

                try {
                  // 7. TENTA RE-AUTENTICAR
                  await _authService.reauthenticateWithPassword(password);
                  
                  // 8. SE DEU CERTO, CHAMA A TROCA DE EMAIL
                  await _authService.currentUser!.verifyBeforeUpdateEmail(novoEmail);
                  
                  if (mounted) Navigator.of(context).pop(); // Fecha o dialog

                } on FirebaseAuthException catch (e) {
                  // Se a senha estiver errada, fecha o dialog e lança o erro
                  if (mounted) Navigator.of(context).pop();
                  throw e;
                }
              },
            ),
          ],
        );
      },
    );
  }

  // ... (O resto do seu arquivo: _logout, build, _inputDecoration... continua igual)
  void _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const TelaLogin()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF003366),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Foto do Usuário (Ícone Enorme)
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white54, width: 3),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              TextFormField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Username', Icons.person_outline),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O username não pode ser vazio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Email', Icons.email_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O email não pode ser vazio';
                  }
                  if (!value.contains('@')) {
                    return 'Insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _isLoading ? null : _salvarAlteracoes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF90CAF9), // Cor de destaque
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        'Salvar Alterações',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 2),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }
}