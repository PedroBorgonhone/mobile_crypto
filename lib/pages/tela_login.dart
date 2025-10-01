import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/pages/tela_menu.dart';
import 'package:pedropaulo_cryptos/pages/tela_recuperar_senha.dart';
import 'package:pedropaulo_cryptos/pages/tela_registro.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Container(
          color: Color(0xFF165873),
          width: double.infinity,
          margin: EdgeInsets.all(30),
          padding: const EdgeInsets.all(30),

          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                // Texto de Bem Vindo

                Text('Bem Vindo!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2EBDF),
                  ),
                ),
                SizedBox(height: 6),
                Text('Faça o login para continuar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFF2EBDF),
                  ),
                ),

                // Campos de Usuário

                SizedBox(height: 26),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Usuário',
                    labelStyle: TextStyle(
                      color: Color(0xFFF2EBDF),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                // Campo de Senha

                SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(
                      color: Color(0xFFF2EBDF),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                // Botão de Entrar

                SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const TelaMenu()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF307B8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFF2EBDF),
                      ),
                    ),
                  ),
                ),

                // Botão de Recuperar Senha

                SizedBox(height: 26),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaRecuperarSenha())
                      );
                  },
                  child: Text(
                    'Esqueceu a Senha?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF2EBDF),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFF2EBDF),
                    ),
                  ),
                ),

                // Botão de Registro

                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaRegistro())
                      );
                  },
                  child: Text(
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