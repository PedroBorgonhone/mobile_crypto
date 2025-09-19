import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/pages/tela_carteira_menu.dart';
import 'package:pedropaulo_cryptos/pages/tela_noticia.dart';

class TelaMenu extends StatelessWidget {
  const TelaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF236bcb),
      appBar: AppBar(
        title: const Text('Menu Principal'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaNoticias()),
                );
              },
              child: const Text('Notícias'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaCarteira()),
                );
              },
              child: const Text('Acessar Carteira'),
            ),
          ],
        ),
      ),
    );
  }
}