// lib/pages/tela_carteira_menu.dart

import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/models/acao.dart';
import 'package:pedropaulo_cryptos/models/moeda.dart';
import 'package:pedropaulo_cryptos/repositories/acao_repositorio.dart';
import 'package:pedropaulo_cryptos/repositories/moeda_repositorio.dart';
import 'package:pedropaulo_cryptos/repositories/carteira_repositorio.dart';

class TelaCarteira extends StatefulWidget {
  const TelaCarteira({super.key});

  @override
  State<TelaCarteira> createState() => _TelaCarteiraState();
}

class _TelaCarteiraState extends State<TelaCarteira> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Moeda> _moedasDisponiveis = MoedaRepositorio.tabela;
  final List<Acao> _acoesDisponiveis = AcaoRepositorio.tabela;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _removerMoeda(Moeda moeda) {
    setState(() {
      CarteiraRepositorio.carteiraCripto.remove(moeda);
    });
  }

  void _mostrarDialogAdicionarMoeda() {
    // AJUSTE: Variáveis movidas para dentro do showDialog para garantir o escopo correto
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
                      autofocus: true, // Melhora a experiência do usuário
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
                          final jaPossui = CarteiraRepositorio.carteiraCripto.any((m) => m.sigla == moeda.sigla);
                          
                          return ListTile(
                            leading: Image.asset(moeda.icone, width: 40),
                            title: Text(moeda.nome),
                            subtitle: Text(moeda.sigla),
                            trailing: jaPossui ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.add),
                            onTap: () {
                              if (!jaPossui) {
                                setState(() {
                                  CarteiraRepositorio.carteiraCripto.add(moeda);
                                });
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

  void _removerAcao(Acao acao) {
    setState(() {
      CarteiraRepositorio.carteiraAcoes.remove(acao);
    });
  }

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
                          final jaPossui = CarteiraRepositorio.carteiraAcoes.any((a) => a.sigla == acao.sigla);
                          
                          return ListTile(
                            title: Text(acao.nome),
                            subtitle: Text(acao.sigla),
                            trailing: jaPossui ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.add),
                            onTap: () {
                              if (!jaPossui) {
                                setState(() {
                                  CarteiraRepositorio.carteiraAcoes.add(acao);
                                });
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
          _buildCarteiraCripto(),
          _buildCarteiraAcoes(),
        ],
      ),
    );
  }

  Widget _buildCarteiraCripto() {
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
            child: ListView.separated(
              itemCount: CarteiraRepositorio.carteiraCripto.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.transparent, height: 8),
              itemBuilder: (context, index) {
                final moeda = CarteiraRepositorio.carteiraCripto[index];
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

  Widget _buildCarteiraAcoes() {
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
            child: ListView.separated(
              itemCount: CarteiraRepositorio.carteiraAcoes.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.transparent, height: 8),
              itemBuilder: (context, index) {
                final acao = CarteiraRepositorio.carteiraAcoes[index];
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