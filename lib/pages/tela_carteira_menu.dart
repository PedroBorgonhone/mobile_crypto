import 'package:flutter/material.dart';

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
                // Lógica para ir para a Carteira Crypto
              },
              child: const Text('Carteira Crypto'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica para ir para a Carteira de Ações
              },
              child: const Text('Carteira de Ações'),
            ),
          ],
        ),
      ),
    );
  }
}