// lib/pages/tela_menu.dart

import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/models/noticia.dart';
import 'package:pedropaulo_cryptos/models/prazo_indicador.dart';
import 'package:pedropaulo_cryptos/repositories/noticia_repositorio.dart';
import 'package:pedropaulo_cryptos/pages/tela_carteira_menu.dart';

class TelaMenu extends StatefulWidget {
  const TelaMenu({super.key});

  @override
  State<TelaMenu> createState() => _TelaMenuState();
}

class _TelaMenuState extends State<TelaMenu> {
  final List<Noticia> tabela = NoticiaRepositorio.tabela;

  Widget _buildPrazoChip(PrazoIndicador prazo) {
    String text;
    Color color;

    switch (prazo) {
      case PrazoIndicador.curto:
        text = 'Curto prazo';
        color = Colors.orange.shade700;
        break;
      case PrazoIndicador.medio:
        text = 'Médio prazo';
        color = Colors.blue.shade700;
        break;
      case PrazoIndicador.longo:
        text = 'Longo prazo';
        color = Colors.green.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Últimas Notícias'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            child: const Text('Carteira'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, 
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaCarteira()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Perfil do Usuário',
            onPressed: () {
              print('Ícone de Perfil clicado!');
            },
          ),
        ],
      ),
      body: Padding( 
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar notícias...',
                hintStyle: const TextStyle(color: Colors.white70),
                fillColor: Colors.white.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ListView.separated(
                itemCount: tabela.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final noticia = tabela[index];
                  return Card(
                    elevation: 4.0,
                    color: const Color(0xFF003366),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(50),
                      onTap: () {
                        print("Clicou em: ${noticia.titulo}");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    noticia.fonte.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF90CAF9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          noticia.titulo,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildPrazoChip(noticia.prazo),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    noticia.subtitulo,
                                    style: const TextStyle(
                                      color: Color(0xD9FFFFFF),
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 90,
                              height: 90,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  noticia.imagemAsset,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}