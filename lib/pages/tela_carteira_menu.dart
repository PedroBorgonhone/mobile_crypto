import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/pages/tela_carteira_acoes.dart';
import 'package:pedropaulo_cryptos/pages/tela_carteira_moedas.dart';

class TelaCarteira extends StatelessWidget {
  const TelaCarteira({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF236bcb),
      appBar: AppBar(
        title: const Text('Minhas Carteiras'),
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
                  MaterialPageRoute(builder: (context) => const CarteiraMoedas()),
                );
              },
              child: const Text('Carteira Crypto'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaCarteiraAcoes()),
                );
              },
              child: const Text('Carteira de Ações'),
            ),
          ],
        ),
      ),
    );
  }
}