// lib/pages/tela_carteira_menu.dart

import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/models/acao.dart';
import 'package:pedropaulo_cryptos/models/moeda.dart';
import 'package:pedropaulo_cryptos/repositories/acao_repositorio.dart';
import 'package:pedropaulo_cryptos/repositories/moeda_repositorio.dart';
// 1. IMPORTAR OS NOVOS SERVIÇOS E O SNACKBAR
import 'package:pedropaulo_cryptos/services/firestore_service.dart';
import 'package:pedropaulo_cryptos/pages/tela_login.dart'; // Para o showCustomSnackbar

class TelaCarteira extends StatefulWidget {
  // 2. RECEBER OS DADOS DO USUÁRIO DA MainTabNavigator
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
  
  // Listas de todos os ativos disponíveis (como antes)
  final List<Moeda> _moedasDisponiveis = MoedaRepositorio.tabela;
  final List<Acao> _acoesDisponiveis = AcaoRepositorio.tabela;

  // 3. NOVAS LISTAS (O ESTADO LOCAL DA CARTEIRA)
  // Elas serão preenchidas com os dados do Firestore
  late List<Moeda> _carteiraCripto;
  late List<Acao> _carteiraAcoes;

  // 4. INSTANCIAR O SERVIÇO DO FIRESTORE
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // 5. CARREGAR AS CARTEIRAS A PARTIR DOS DADOS RECEBIDOS
    _loadCarteirasFromUserData();
  }

  // 6. NOVA FUNÇÃO PARA PROCESSAR OS DADOS DO USUÁRIO
  void _loadCarteirasFromUserData() {
    // Pega as listas de SÍMBOLOS (Strings) do Firestore
    // (Usa '?? []' para garantir que não seja nulo se o campo não existir)
    // Usamos List.from para garantir que é uma lista modificável
    final criptoSymbols = Set.from(List.from(widget.userData['carteiraCripto'] ?? []));
    final acaoSymbols = Set.from(List.from(widget.userData['carteiraAcoes'] ?? []));

    // Filtra as listas "master" para pegar os objetos completos
    setState(() {
      _carteiraCripto = _moedasDisponiveis
          .where((moeda) => criptoSymbols.contains(moeda.sigla))
          .toList();
          
      _carteiraAcoes = _acoesDisponiveis
          .where((acao) => acaoSymbols.contains(acao.sigla))
          .toList();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 7. ATUALIZAR FUNÇÃO DE REMOVER MOEDA
  void _removerMoeda(Moeda moeda) async {
    try {
      // 7.1. Remove do Firestore
      await _firestoreService.removeAssetFromCarteira(
        uid: widget.uid,
        assetSymbol: moeda.sigla,
        type: 'cripto',
      );
      
      // 7.2. Remove do estado local (para a tela atualizar)
      setState(() {
        _carteiraCripto.remove(moeda);
        
        // --- CORREÇÃO DE BUG ---
        // Atualiza a lista do "Pai" (MainTabNavigator) para que
        // ela não recrie a tela com a lista antiga.
        (widget.userData['carteiraCripto'] as List).remove(moeda.sigla);
        // -----------------------
      });

      showCustomSnackbar(context, '${moeda.nome} removida da carteira.');
    } catch (e) {
      showCustomSnackbar(context, 'Erro ao remover moeda: $e', isError: true);
    }
  }

  // 8. ATUALIZAR FUNÇÃO DE ADICIONAR MOEDA
  void _mostrarDialogAdicionarMoeda() {
    final searchController = TextEditingController();
    List<Moeda> moedasFiltradas = List.from(_moedasDisponiveis);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            void filtrar(String query) {
              setStateInDialog(() {
                if (query.isEmpty) {
                  moedasFiltradas = List.from(_moedasDisponiveis);
                } else {
                  moedasFiltradas = _moedasDisponiveis.where((moeda) {
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
                          // 8.1. Verifica se já possui no ESTADO LOCAL
                          final jaPossui = _carteiraCripto.any((m) => m.sigla == moeda.sigla);
                          
                          return ListTile(
                            leading: Image.asset(moeda.icone, width: 40),
                            title: Text(moeda.nome),
                            subtitle: Text(moeda.sigla),
                            trailing: jaPossui ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.add),
                            onTap: () async { // <-- MUDANÇA PARA ASYNC
                              if (!jaPossui) {
                                try {
                                  // 8.2. Adiciona no FIRESTORE
                                  await _firestoreService.addAssetToCarteira(
                                    uid: widget.uid,
                                    assetSymbol: moeda.sigla,
                                    type: 'cripto',
                                  );

                                  // 8.3. Adiciona no ESTADO LOCAL
                                  setState(() {
                                    _carteiraCripto.add(moeda);
                                    
                                    // --- CORREÇÃO DE BUG ---
                                    // Atualiza a lista do "Pai" (MainTabNavigator)
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

  // 9. ATUALIZAR FUNÇÃO DE REMOVER AÇÃO
  void _removerAcao(Acao acao) async {
    try {
      await _firestoreService.removeAssetFromCarteira(
        uid: widget.uid,
        assetSymbol: acao.sigla,
        type: 'acao',
      );
      
      setState(() {
        _carteiraAcoes.remove(acao);
        
        // --- CORREÇÃO DE BUG ---
        // Atualiza a lista do "Pai" (MainTabNavigator)
        (widget.userData['carteiraAcoes'] as List).remove(acao.sigla);
        // -----------------------
      });

      showCustomSnackbar(context, '${acao.nome} removida da carteira.');
    } catch (e) {
      showCustomSnackbar(context, 'Erro ao remover ação: $e', isError: true);
    }
  }

  // 10. ATUALIZAR FUNÇÃO DE ADICIONAR AÇÃO
  void _mostrarDialogAdicionarAcao() {
    final searchController = TextEditingController();
    List<Acao> acoesFiltradas = List.from(_acoesDisponiveis);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            void filtrar(String query) {
              setStateInDialog(() {
                if (query.isEmpty) {
                  acoesFiltradas = List.from(_acoesDisponiveis);
                } else {
                  acoesFiltradas = _acoesDisponiveis.where((acao) {
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
                                    
                                    // --- CORREÇÃO DE BUG ---
                                    // Atualiza a lista do "Pai" (MainTabNavigator)
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
    return Scaffold(
      appBar: AppBar(
        // ... (Seu AppBar continua 100% igual)
        title: const Text('Minhas Carteiras'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
          // 11. PASSAR AS NOVAS LISTAS LOCAIS PARA OS MÉTODOS DE BUILD
          _buildCarteiraCripto(_carteiraCripto),
          _buildCarteiraAcoes(_carteiraAcoes),
        ],
      ),
    );
  }

  // 12. ATUALIZAR MÉTODO DE BUILD CRIPTO
  Widget _buildCarteiraCripto(List<Moeda> carteira) { // Recebe a lista como parâmetro
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Cripto'),
            onPressed: _mostrarDialogAdicionarMoeda, // Função de adicionar
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
            child: carteira.isEmpty // 12.1. Mostra msg se a carteira estiver vazia
              ? const Center(
                  child: Text(
                    'Sua carteira de criptos está vazia.\nClique em "Adicionar Cripto" para começar.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  itemCount: carteira.length, // Usa a lista do parâmetro
                  separatorBuilder: (_, __) => const Divider(color: Colors.transparent, height: 8),
                  itemBuilder: (context, index) {
                    final moeda = carteira[index]; // Usa a lista do parâmetro
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
                          onPressed: () => _removerMoeda(moeda), // Função de remover
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

  // 13. ATUALIZAR MÉTODO DE BUILD AÇÕES
  Widget _buildCarteiraAcoes(List<Acao> carteira) { // Recebe a lista como parâmetro
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Ação'),
            onPressed: _mostrarDialogAdicionarAcao, // Função de adicionar
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
            child: carteira.isEmpty // 13.1. Mostra msg se a carteira estiver vazia
              ? const Center(
                  child: Text(
                    'Sua carteira de ações está vazia.\nClique em "Adicionar Ação" para começar.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  itemCount: carteira.length, // Usa a lista do parâmetro
                  separatorBuilder: (_, __) => const Divider(color: Colors.transparent, height: 8),
                  itemBuilder: (context, index) {
                    final acao = carteira[index]; // Usa a lista do parâmetro
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
                          onPressed: () => _removerAcao(acao), // Função de remover
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