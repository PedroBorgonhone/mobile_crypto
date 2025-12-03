import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/models/acao.dart';
import 'package:pedropaulo_cryptos/models/moeda.dart';
import 'package:pedropaulo_cryptos/repositories/acao_repositorio.dart';
import 'package:pedropaulo_cryptos/repositories/moeda_repositorio.dart';
import 'package:pedropaulo_cryptos/services/firestore_service.dart';
import 'package:pedropaulo_cryptos/pages/tela_login.dart';
import 'package:pedropaulo_cryptos/services/coinmarketcap_service.dart';
import 'package:pedropaulo_cryptos/services/alpha_vantage_service.dart';

class TelaCarteira extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> userData;

  const TelaCarteira({
    super.key,
    required this.uid,
    required this.userData,
  });

  @override
  State<TelaCarteira> createState() => _TelaCarteiraState();
}

class _TelaCarteiraState extends State<TelaCarteira> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final MoedaService _moedaService = MoedaService(); 
  final AcaoService _acaoService = AcaoService();

  bool _isLoading = false;
  String? _errorMessage;

  List<Moeda> _moedasDisponiveisComPreco = [];
  List<Acao> _acoesDisponiveisComPreco = [];

  late List<Moeda> _carteiraCripto = [];
  late List<Acao> _carteiraAcoes = [];

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 2, vsync: this);
    
    _carteiraCripto = [];
    _carteiraAcoes = [];

    _loadInitialDataFromRepositories();
  }
  
  void _updateCarteiraFromPrices() {
  final criptoSymbols = Set.from(List.from(widget.userData['carteiraCripto'] ?? []));
  final acaoSymbols = Set.from(List.from(widget.userData['carteiraAcoes'] ?? []));

  _carteiraCripto = _moedasDisponiveisComPreco
      .where((moeda) => criptoSymbols.contains(moeda.sigla))
      .toList();
      
  _carteiraAcoes = _acoesDisponiveisComPreco
      .where((acao) => acaoSymbols.contains(acao.sigla))
      .toList();
}
  void _loadInitialDataFromRepositories() {
  
  final List<Moeda> moedasEstaticas = MoedaRepositorio.tabela;
  final List<Acao> acoesEstaticas = AcaoRepositorio.tabela;
  
  final criptoSymbols = Set.from(List.from(widget.userData['carteiraCripto'] ?? []));
  final acaoSymbols = Set.from(List.from(widget.userData['carteiraAcoes'] ?? []));

  _moedasDisponiveisComPreco = moedasEstaticas;
  _acoesDisponiveisComPreco = acoesEstaticas;

  setState(() {
    _carteiraCripto = _moedasDisponiveisComPreco
        .where((moeda) => criptoSymbols.contains(moeda.sigla))
        .toList();
        
    _carteiraAcoes = _acoesDisponiveisComPreco
        .where((acao) => acaoSymbols.contains(acao.sigla))
        .toList();
  });
}
  
  Future<void> _fetchAndRefreshPrices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; 
    });

    try {
      final List<Moeda> moedasAtualizadas = await _moedaService.fetchCryptos();
      final List<Acao> acoesAtualizadas = await _acaoService.fetchCurrentQuotes();

      MoedaRepositorio.updatePrices(moedasAtualizadas);
      AcaoRepositorio.updatePrices(acoesAtualizadas);
      
      _moedasDisponiveisComPreco = moedasAtualizadas;
      _acoesDisponiveisComPreco = acoesAtualizadas;
      
      _updateCarteiraFromPrices();
      
      setState(() {
        _updateCarteiraFromPrices();
        _isLoading = false;
      });
      
    } catch (e) {
      print('ERRO AO ATUALIZAR PREÇOS: $e');
      
      setState(() {
        _isLoading = false;
        _errorMessage = 'Falha ao buscar preços. Verifique sua conexão ou API Keys.';
        _carteiraCripto = [];
        _carteiraAcoes = [];
        _moedasDisponiveisComPreco = [];
        _acoesDisponiveisComPreco = [];
      });
    }
  }

@override
void dispose() {
   _tabController.dispose();
  super.dispose();
}

void _removerMoeda(Moeda moeda) async {
  try {
    await _firestoreService.removeAssetFromCarteira(
      uid: widget.uid,
      assetSymbol: moeda.sigla,
      type: 'cripto',
     );
      
    setState(() {
      _carteiraCripto.remove(moeda);
      (widget.userData['carteiraCripto'] as List).remove(moeda.sigla);
    });

    showCustomSnackbar(context, '${moeda.nome} removida da carteira.');
  } catch (e) {
    showCustomSnackbar(context, 'Erro ao remover moeda: $e', isError: true);
  }
}

  void _mostrarDialogAdicionarMoeda() {
    final searchController = TextEditingController();
    List<Moeda> moedasFiltradas = List.from(_moedasDisponiveisComPreco);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            void filtrar(String query) {
              setStateInDialog(() {
                if (query.isEmpty) {
                  moedasFiltradas = List.from(_moedasDisponiveisComPreco);
                } else {
                  moedasFiltradas = _moedasDisponiveisComPreco.where((moeda) {
                    return moeda.nome.toLowerCase().contains(query.toLowerCase()) ||
                           moeda.sigla.toLowerCase().contains(query.toLowerCase());
                  }).toList();
                }
              });
            }

            return AlertDialog(
              title: const Text('Adicionar Criptomoeda'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      onChanged: filtrar,
                      autofocus: true, 
                      decoration: const InputDecoration(
                        labelText: 'Pesquisar',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: moedasFiltradas.length,
                        itemBuilder: (context, index) {
                          final moeda = moedasFiltradas[index];
                          final jaPossui = _carteiraCripto.any((m) => m.sigla == moeda.sigla);
                          
                          return ListTile(
                            leading: Image.asset(moeda.icone, width: 40),
                            title: Text(moeda.nome),
                            subtitle: Text(moeda.sigla),
                            trailing: jaPossui ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.add),
                            onTap: () async {
                              if (!jaPossui) {
                                try {
                                  await _firestoreService.addAssetToCarteira(
                                    uid: widget.uid,
                                    assetSymbol: moeda.sigla,
                                    type: 'cripto',
                                  );

                                  setState(() {
                                    _carteiraCripto.add(moeda);
                                    (widget.userData['carteiraCripto'] as List).add(moeda.sigla);
                                    // -----------------------
                                  });
                                  
                                  showCustomSnackbar(context, '${moeda.nome} adicionada à carteira.');

                                } catch (e) {
                                  showCustomSnackbar(context, 'Erro ao adicionar: $e', isError: true);
                                }
                              }
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _removerAcao(Acao acao) async {
    try {
      await _firestoreService.removeAssetFromCarteira(
        uid: widget.uid,
        assetSymbol: acao.sigla,
        type: 'acao',
      );
      
      setState(() {
        _carteiraAcoes.remove(acao);
        (widget.userData['carteiraAcoes'] as List).remove(acao.sigla);
        // -----------------------
      });

      showCustomSnackbar(context, '${acao.nome} removida da carteira.');
    } catch (e) {
      showCustomSnackbar(context, 'Erro ao remover ação: $e', isError: true);
    }
  }

  void _mostrarDialogAdicionarAcao() {
    final searchController = TextEditingController();
    List<Acao> acoesFiltradas = List.from(_acoesDisponiveisComPreco);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            void filtrar(String query) {
              setStateInDialog(() {
                if (query.isEmpty) {
                  acoesFiltradas = List.from(_acoesDisponiveisComPreco);
                } else {
                  acoesFiltradas = _acoesDisponiveisComPreco.where((acao) {
                    return acao.nome.toLowerCase().contains(query.toLowerCase()) ||
                           acao.sigla.toLowerCase().contains(query.toLowerCase());
                  }).toList();
                }
              });
            }

            return AlertDialog(
              title: const Text('Adicionar Ação'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      onChanged: filtrar,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Pesquisar',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: acoesFiltradas.length,
                        itemBuilder: (context, index) {
                          final acao = acoesFiltradas[index];
                          final jaPossui = _carteiraAcoes.any((a) => a.sigla == acao.sigla);
                          
                          return ListTile(
                            title: Text(acao.nome),
                            subtitle: Text(acao.sigla),
                            trailing: jaPossui ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.add),
                            onTap: () async { // <-- MUDANÇA PARA ASYNC
                              if (!jaPossui) {
                                try {
                                  await _firestoreService.addAssetToCarteira(
                                    uid: widget.uid,
                                    assetSymbol: acao.sigla,
                                    type: 'acao',
                                  );

                                  setState(() {
                                    _carteiraAcoes.add(acao);
                                    (widget.userData['carteiraAcoes'] as List).add(acao.sigla);
                                    // -----------------------
                                  });
                                  
                                  showCustomSnackbar(context, '${acao.nome} adicionada à carteira.');

                                } catch (e) {
                                  showCustomSnackbar(context, 'Erro ao adicionar: $e', isError: true);
                                }
                              }
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

  if (_errorMessage != null) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchAndRefreshPrices,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Carteiras'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
        IconButton(
          icon: Icon(
            _isLoading ? Icons.hourglass_top_outlined : Icons.refresh, 
            color: Colors.white,
          ),
          tooltip: 'Atualizar Preços',
          onPressed: _isLoading ? null : _fetchAndRefreshPrices,
        ),
      ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Criptomoedas'),
            Tab(text: 'Ações'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCarteiraCripto(_carteiraCripto),
          _buildCarteiraAcoes(_carteiraAcoes),
        ],
      ),
    );
  }

  Widget _buildCarteiraCripto(List<Moeda> carteira) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Cripto'),
            onPressed: _mostrarDialogAdicionarMoeda,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Meus Ativos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: carteira.isEmpty
              ? const Center(
                  child: Text(
                    'Sua carteira de criptos está vazia.\nClique em "Adicionar Cripto" para começar.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  itemCount: carteira.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.transparent, height: 8),
                  itemBuilder: (context, index) {
                    final moeda = carteira[index];
                    return Card(
                      color: const Color(0xFF003366),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Image.asset(moeda.icone, width: 40),
                        title: Text(moeda.nome, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(moeda.sigla, style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text(
                              'R\$ ${moeda.preco.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          tooltip: 'Remover da carteira',
                          onPressed: () => _removerMoeda(moeda),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarteiraAcoes(List<Acao> carteira) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Ação'),
            onPressed: _mostrarDialogAdicionarAcao,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Meus Ativos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: carteira.isEmpty
              ? const Center(
                  child: Text(
                    'Sua carteira de ações está vazia.\nClique em "Adicionar Ação" para começar.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  itemCount: carteira.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.transparent, height: 8),
                  itemBuilder: (context, index) {
                    final acao = carteira[index];
                    return Card(
                      color: const Color(0xFF003366),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(acao.nome, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(acao.sigla, style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text(
                              'R\$ ${acao.preco.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.redAccent),
                          tooltip: 'Remover da carteira',
                          onPressed: () => _removerAcao(acao),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}