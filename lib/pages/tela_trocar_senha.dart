import 'package:flutter/material.dart';

class TelaTrocarSenha extends StatelessWidget {
  const TelaTrocarSenha({super.key});

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
                ElevatedButton(
                  onPressed: () {
                    // Lógica para trocar a senha
                  },
                  child: const Text('Trocar Senha'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}