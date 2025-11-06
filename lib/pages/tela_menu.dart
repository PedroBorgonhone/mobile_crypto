// lib/pages/tela_menu.dart

import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/models/noticia.dart';
import 'package:pedropaulo_cryptos/models/prazo_indicador.dart';
// 1. IMPORTAR OS SERVIÇOS
import 'package:pedropaulo_cryptos/services/firestore_service.dart';
// O import da 'tela_login.dart' (para o snackbar) foi removido pois não é mais necessário

class TelaMenu extends StatefulWidget {
  // RECEBER OS DADOS DO USUÁRIO (A CARTEIRA)
  final Map<String, dynamic> userData;
  
  const TelaMenu({super.key, required this.userData});

  @override
  State<TelaMenu> createState() => _TelaMenuState();
}

class _TelaMenuState extends State<TelaMenu> {
  final _searchController = TextEditingController();
  
  // INSTANCIAR O SERVIÇO
  final FirestoreService _firestoreService = FirestoreService();
  
  // LISTAS PARA CONTROLAR AS NOTÍCIAS
  List<Noticia> _noticiasDaCarteira = []; // A lista vinda do banco
  List<Noticia> _noticiasExibidas = []; // A lista filtrada pela pesquisa
  
  bool _isLoading = true; // Começa carregando

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filtrarNoticiasPorPesquisa);
    // CHAMA A CONSULTA AO FIRESTORE (Automaticamente)
    _carregarNoticiasFiltradas();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filtrarNoticiasPorPesquisa);
    _searchController.dispose();
    super.dispose();
  }

  // FUNÇÃO DE CARREGAMENTO (Sua ideia!)
  void _carregarNoticiasFiltradas() async {
    // Pega as siglas da carteira que o "Pai" (motion_bar) nos deu
    final criptoSymbols = List<String>.from(widget.userData['carteiraCripto'] ?? []);
    final acaoSymbols = List<String>.from(widget.userData['carteiraAcoes'] ?? []);
    final todasSiglas = [...criptoSymbols, ...acaoSymbols]; // Junta as duas listas

    // Chama o serviço para buscar no Firestore
    final noticias = await _firestoreService.getNoticiasFiltradas(todasSiglas);

    // Atualiza a tela
    setState(() {
      _noticiasDaCarteira = noticias;
      _noticiasExibidas = noticias;
      _isLoading = false;
    });
  }
  
  // FUNÇÃO DE PESQUISA
  void _filtrarNoticiasPorPesquisa() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        _noticiasExibidas = _noticiasDaCarteira;
      } else {
        _noticiasExibidas = _noticiasDaCarteira.where((noticia) {
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

  // (O resto do seu código: _showDetailsDialog e _buildPrazoChip)
  
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

  // --- BUILD DA TELA ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Notícias'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        
        // --- O BOTÃO "actions" FOI REMOVIDO DAQUI ---
        
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar nas suas notícias...',
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
              // (A lógica de loading e lista vazia)
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : _noticiasExibidas.isEmpty
                      ? Center(
                          child: Text(
                            _noticiasDaCarteira.isEmpty
                              ? 'Nenhuma notícia encontrada para os ativos em sua carteira.\n\nAdicione ativos na aba "Carteira" para ver suas notícias.'
                              : 'Nenhum resultado para "${_searchController.text}"',
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.separated(
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