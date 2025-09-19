import 'package:flutter/material.dart';

class TelaNoticias extends StatelessWidget {
  const TelaNoticias({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF236bcb),
      appBar: AppBar(
        title: const Text('Notícias'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Campo de Pesquisa
            TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar notícias...',
                hintStyle: TextStyle(color: Colors.white70),
                fillColor: Colors.white.withOpacity(0.2),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            // Lista de Artigos (Placeholder)
            Expanded(
              child: ListView(
                children: [
                  // Aqui serão adicionados os widgets para cada artigo
                  // Exemplo:
                  // Card(
                  //   child: ListTile(
                  //     title: Text('Título da Notícia'),
                  //     subtitle: Text('Breve descrição...'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}