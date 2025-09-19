import 'package:flutter/material.dart';

class TelaCarteiraAcoes extends StatelessWidget {
  const TelaCarteiraAcoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF236bcb),
      appBar: AppBar(
        title: const Text('Carteira de Ações'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              // Ações para adicionar ações (futuramente)
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            child: const Text(
              'Adicionar Ação',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}