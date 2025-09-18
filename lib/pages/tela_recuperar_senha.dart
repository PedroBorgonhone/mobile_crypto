import 'package:flutter/material.dart';

class TelaRecuperarSenha extends StatelessWidget {
  const TelaRecuperarSenha({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF236bcb),
      appBar: AppBar(
        title: const Text('Redefinir Senha'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 32.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Lógica para enviar o email de redefinição
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}