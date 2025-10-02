import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/models/noticia.dart';
import 'package:pedropaulo_cryptos/models/prazo_indicador.dart';
import 'package:pedropaulo_cryptos/repositories/noticia_repositorio.dart';
import 'package:pedropaulo_cryptos/pages/tela_carteira_menu.dart';
import 'package:pedropaulo_cryptos/repositories/usuario_repositorio.dart'; 
import 'package:pedropaulo_cryptos/pages/tela_perfil.dart'; 

class TelaMenu extends StatefulWidget {
  const TelaMenu({super.key});

  @override
  State<TelaMenu> createState() => _TelaMenuState();
}

class _TelaMenuState extends State<TelaMenu> {
  final _searchController = TextEditingController();
  List<Noticia> _noticiasExibidas = [];
  final List<Noticia> _listaOriginal = NoticiaRepositorio.tabela;

  @override
  void initState() {
    super.initState();
    _noticiasExibidas = _listaOriginal;
    _searchController.addListener(_filtrarNoticias);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filtrarNoticias);
    _searchController.dispose();
    super.dispose();
  }

  void _filtrarNoticias() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        _noticiasExibidas = _listaOriginal;
      } else {
        _noticiasExibidas = _listaOriginal.where((noticia) {
          final tituloLower = noticia.titulo.toLowerCase();
          final subtituloLower = noticia.subtitulo.toLowerCase();
          final conteudoLower = noticia.conteudo.toLowerCase();
          return tituloLower.contains(query) || 
                 subtituloLower.contains(query) ||
                 conteudoLower.contains(query);
        }).toList();
      }
    });
  }

  void _showDetailsDialog(Noticia noticia) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF003366),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            noticia.titulo,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Text(
              noticia.conteudo,
              style: const TextStyle(color: Colors.white70, height: 1.5),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Fechar',
                style: TextStyle(color: Color(0xFF90CAF9), fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrazoChip(PrazoIndicador prazo) {
    String text;
    Color color;

    switch (prazo) {
      case PrazoIndicador.curto:
        text = 'CURTO PRAZO';
        color = Colors.orange.shade700;
        break;
      case PrazoIndicador.medio:
        text = 'MÉDIO PRAZO';
        color = Colors.blue.shade700;
        break;
      case PrazoIndicador.longo:
        text = 'LONGO PRAZO';
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
          // Localização: Dentro de AppBar -> actions: [...]

          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Perfil do Usuário',
            onPressed: () {
              final usuarioLogado = UsuarioRepositorio().usuarioLogado;

              if (usuarioLogado != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaPerfil(usuario: usuarioLogado),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erro: Nenhum usuário logado.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
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
                itemCount: _noticiasExibidas.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final noticia = _noticiasExibidas[index];
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
                        _showDetailsDialog(noticia);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                      const SizedBox(width: 8),
                                      _buildPrazoChip(noticia.prazo),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    noticia.titulo,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
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