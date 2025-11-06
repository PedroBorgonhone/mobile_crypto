// lib/pages/tela_perfil.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedropaulo_cryptos/pages/tela_login.dart'; // Para o snackbar e navegação
import 'package:pedropaulo_cryptos/services/auth_service.dart'; // Para o Logout
import 'package:pedropaulo_cryptos/services/firestore_service.dart'; // Para Salvar

class TelaPerfil extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> userData;
  final VoidCallback onProfileUpdated; 

  const TelaPerfil({
    super.key,
    required this.uid,
    required this.userData,
    required this.onProfileUpdated, 
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

  // FUNÇÃO _salvarAlteracoes (Atualizada para usar o callback)
  void _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    setState(() => _isLoading = true);

    final String novoUsername = _usernameController.text.trim();
    final String novoEmail = _emailController.text.trim();

    final bool emailMudou = novoEmail != widget.userData['email'];

    try {
      if (emailMudou) {
        // OPERAÇÃO SENSÍVEL: Pede a senha
        await _mostrarDialogReautenticacaoEmail(novoUsername, novoEmail);
        showCustomSnackbar(context, 'Sucesso! Verifique seu *novo* e-mail para confirmar a mudança.');
        
        await _firestoreService.updateUserData(
          uid: widget.uid,
          newUsername: novoUsername,
          newEmail: novoEmail,
        );

      } else {
        // OPERAÇÃO SEGURA: Só mudou o username
        await _firestoreService.updateUserData(
          uid: widget.uid,
          newUsername: novoUsername,
          newEmail: novoEmail, 
        );
        showCustomSnackbar(context, 'Perfil atualizado com sucesso!');
      }

      widget.onProfileUpdated(); 

    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao salvar.';
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        msg = 'Senha incorreta. Alterações não salvas.';
      }
      showCustomSnackbar(context, msg, isError: true);
    } catch (e) {
      // Captura o "Operação cancelada" do dialog
      showCustomSnackbar(context, 'Erro: ${e.toString()}', isError: true);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  // (A função de re-autenticação do Email)
  Future<void> _mostrarDialogReautenticacaoEmail(String novoUsername, String novoEmail) async {
    final passwordController = TextEditingController();
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
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
                Navigator.of(context).pop(); 
                throw Exception('Operação cancelada pelo usuário.'); 
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                final password = passwordController.text.trim();
                if (password.isEmpty) return;

                try {
                  await _authService.reauthenticateWithPassword(password);
                  await _authService.currentUser!.verifyBeforeUpdateEmail(novoEmail);
                  
                  if (mounted) Navigator.of(context).pop(); 

                } on FirebaseAuthException catch (e) {
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

  // --- NOVA FUNÇÃO (Pop-up de Alterar Senha) ---
  void _mostrarDialogAlterarSenha() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alterar Senha'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: true,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Senha Antiga'),
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Nova Senha'),
                  validator: (v) {
                    if (v!.isEmpty) return 'Campo obrigatório';
                    if (v.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirmar Nova Senha'),
                  validator: (v) {
                    if (v! != newPasswordController.text) return 'Senhas não batem';
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              child: const Text('Alterar'),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                
                final oldPass = oldPasswordController.text;
                final newPass = newPasswordController.text;
                
                try {
                  await _authService.updatePassword(
                    oldPassword: oldPass,
                    newPassword: newPass,
                  );
                  if (mounted) {
                    Navigator.of(context).pop();
                    showCustomSnackbar(context, 'Senha alterada com sucesso!');
                  }
                } on FirebaseAuthException catch (e) {
                  String msg = 'Erro ao alterar senha.';
                  if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
                    msg = 'Senha antiga incorreta.';
                  } else if (e.code == 'weak-password') {
                    msg = 'Nova senha é muito fraca.';
                  }
                  showCustomSnackbar(context, msg, isError: true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  // --- NOVA FUNÇÃO (Pop-up de Excluir Conta) ---
  void _mostrarDialogExcluirConta() {
    final passwordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Conta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Isso é permanente! Todos os seus dados (carteira e perfil) serão perdidos. Para confirmar, digite sua senha.',
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Sua Senha Atual'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir Permanentemente'),
              onPressed: () async {
                final password = passwordController.text.trim();
                if (password.isEmpty) {
                  showCustomSnackbar(context, 'Senha é obrigatória', isError: true);
                  return;
                }

                try {
                  // 1. Re-autentica
                  await _authService.reauthenticateWithPassword(password);
                  
                  // 2. Deleta os dados do "Arquivo" (Firestore)
                  await _firestoreService.deleteUserData(widget.uid);
                  
                  // 3. Deleta o usuário da "Portaria" (Auth)
                  await _authService.deleteAccount();
                  
                  // 4. Manda de volta para o Login
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const TelaLogin()),
                      (route) => false,
                    );
                    showCustomSnackbar(context, 'Conta excluída com sucesso.');
                  }

                } on FirebaseAuthException catch (e) {
                  String msg = 'Erro ao excluir conta.';
                  if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
                    msg = 'Senha incorreta.';
                  }
                  showCustomSnackbar(context, msg, isError: true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  // (O seu método de Logout, Build e InputDecoration continuam iguais)
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
              // ... (Foto, campos de username e email... tudo igual)
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

              // Botão Salvar Alterações
              ElevatedButton(
                onPressed: _isLoading ? null : _salvarAlteracoes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF90CAF9),
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
              
              const SizedBox(height: 20),
              const Divider(color: Colors.white24),
              const SizedBox(height: 20),
              
              // --- NOVO BOTÃO (Alterar Senha) ---
              OutlinedButton(
                onPressed: _mostrarDialogAlterarSenha,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Alterar Senha',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // --- NOVO BOTÃO (Excluir Conta) ---
              OutlinedButton(
                onPressed: _mostrarDialogExcluirConta,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Excluir Conta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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