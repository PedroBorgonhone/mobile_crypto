import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/pages/tela_login.dart';
import 'package:pedropaulo_cryptos/repositories/usuario_repositorio.dart';

class TelaTrocarSenha extends StatefulWidget {
  final String userEmail;
  
  const TelaTrocarSenha({super.key, required this.userEmail});

  @override
  State<TelaTrocarSenha> createState() => _TelaTrocarSenhaState();
}

class _TelaTrocarSenhaState extends State<TelaTrocarSenha> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userRepository = UsuarioRepositorio();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final email = widget.userEmail;

    // 1. Validação
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      showCustomSnackbar(context, 'Por favor, preencha a nova senha e a confirmação.', isError: true);
      return;
    }
    if (newPassword != confirmPassword) {
      showCustomSnackbar(context, 'As novas senhas não coincidem.', isError: true);
      return;
    }
    if (newPassword.length < 3) {
      showCustomSnackbar(context, 'A nova senha deve ter pelo menos 3 caracteres (apenas para demonstração).', isError: true);
      return;
    }

    final success = _userRepository.trocaSenha(
      email: email,
      novaSenha: newPassword,
    );

    if (success) {
      showCustomSnackbar(context, 'Senha trocada com sucesso! Faça login com a nova senha.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TelaLogin()),
      );
    } else {
      showCustomSnackbar(context, 'Erro ao trocar a senha. Usuário não encontrado.', isError: true);
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

                // Texto de Trocar Senha

                const Text('Trocar Senha',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2EBDF),
                  ),
                ),

                // Campo de Nova Senha

                const SizedBox(height: 26),
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  decoration: InputDecoration(
                    labelText: 'Nova Senha',
                    labelStyle: const TextStyle(color: Color(0xFFF2EBDF),),
                    border: OutlineInputBorder(),
                  ),
                ),

                // Campo de Confirmar Nova Senha

                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  decoration: InputDecoration(
                    labelText: 'Confirmar Nova Senha',
                    labelStyle: const TextStyle(color: Color(0xFFF2EBDF),),
                    border: OutlineInputBorder(),
                  ),
                ),

                // Botão Trocar Senha

                const SizedBox(height: 32.0),
                SizedBox( 
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF307B8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Trocar Senha',
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const TelaLogin()),
                      );
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
