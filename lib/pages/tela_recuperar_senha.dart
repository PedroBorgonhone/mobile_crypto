import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/pages/tela_trocar_senha.dart';
import 'package:pedropaulo_cryptos/repositories/usuario_repositorio.dart';
import 'package:pedropaulo_cryptos/pages/tela_login.dart';

class TelaRecuperarSenha extends StatefulWidget {
  const TelaRecuperarSenha({super.key});

  @override
  State<TelaRecuperarSenha> createState() => _TelaRecuperarSenhaState();
}

class _TelaRecuperarSenhaState extends State<TelaRecuperarSenha> {
  final _emailController = TextEditingController();
  final _userRepository = UsuarioRepositorio();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _recoverPassword() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showCustomSnackbar(context, 'Por favor, insira seu e-mail.', isError: true);
      return;
    }

    final user = _userRepository.encontraUsuario(email);

    if (user != null) {
      showCustomSnackbar(context, 'E-mail encontrado! Redirecionando para a troca de senha.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaTrocarSenha(userEmail: email),
        ),
      );
    } else {
      showCustomSnackbar(context, 'E-mail não encontrado no sistema.', isError: true);
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

                // Texto de Recuperação de Senha

                const Text('Redefinição de Senha!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2EBDF),
                  ),
                ),

                // Campo explicativo

                const SizedBox(height: 6),
                const Text('Insira seu email para receber o link de redefinição de senha',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFFF2EBDF),
                  ),
                ),

                // Campo de Email

                const SizedBox(height: 32.0),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Color(0xFFF2EBDF)),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),

                // Botão Enviar

                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _recoverPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF307B8C),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Enviar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFF2EBDF),
                    ),
                  ),
                ),

                // Botão Cancelar

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
              ],
            ),
          )
        ),
      ),
    );
  }
}
