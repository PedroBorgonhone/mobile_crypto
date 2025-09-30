import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/pages/tela_menu.dart';
import 'package:pedropaulo_cryptos/pages/tela_recuperar_senha.dart';
import 'package:pedropaulo_cryptos/pages/tela_registro.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Color(0xFF307B8C),
        height: 600,
        width: double.infinity,
        margin: EdgeInsets.only(top: 100, left: 30, right: 30, bottom: 100),

        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Usuário',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaRegistro())
                  );
              },
              child: Text(
                'Registrar',
                style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaRecuperarSenha())
                  );
              },
              child: Text(
                'Recuperar Senha',
                style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaMenu()),
                  );
                },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}