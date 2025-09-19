import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/pages/tela_menu.dart';
import 'package:pedropaulo_cryptos/pages/tela_recuperar_senha.dart';
import 'package:pedropaulo_cryptos/pages/tela_registro.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color(0xFF0074D9),
        elevation: 10.0,
      ),

      body: Padding(
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
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaMenu()),
                  );
                },
              child: Text('Entrar'),
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
          ],
        ),
      ),
    );
  }
}