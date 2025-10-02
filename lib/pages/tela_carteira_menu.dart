// lib/pages/tela_carteira_menu.dart

import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/models/acao.dart';
import 'package:pedropaulo_cryptos/models/moeda.dart';
import 'package:pedropaulo_cryptos/repositories/acao_repositorio.dart';
import 'package:pedropaulo_cryptos/repositories/moeda_repositorio.dart';

class TelaCarteira extends StatefulWidget {
  const TelaCarteira({super.key});

  @override
  State<TelaCarteira> createState() => _TelaCarteiraState();
}

class _TelaCarteiraState extends State<TelaCarteira> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Carteira de Criptomoedas do usuário
  List<Moeda> _minhaCarteiraCripto = [];
  final List<Moeda> _moedasDisponiveis = MoedaRepositorio.tabela;
  
  // Carteira de Ações do usuário
  List<Acao> _minhaCarteiraAcoes = [];
  final List<Acao> _acoesDisponiveis = AcaoRepositorio.tabela;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Preenche as carteiras com alguns exemplos iniciais
    _minhaCarteiraCripto = _moedasDisponiveis.sublist(0, 3);
    _minhaCarteiraAcoes = _acoesDisponiveis.sublist(0, 2);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Funções para Criptomoedas ---
  void _removerMoeda(Moeda moeda) {
    setState(() {
      _minhaCarteiraCripto.remove(moeda);
    });
  }

  void _mostrarDialogAdicionarMoeda() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Criptomoeda'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _moedasDisponiveis.length,
              itemBuilder: (context, index) {
                final moeda = _moedasDisponiveis[index];
                final jaPossui = _minhaCarteiraCripto.any((m) => m.sigla == moeda.sigla);
                
                return ListTile(
                  leading: Image.asset(moeda.icone, width: 40),
                  title: Text(moeda.nome),
                  subtitle: Text(moeda.sigla),
                  trailing: jaPossui
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.add),
                  onTap: () {
                    if (!jaPossui) {
                      setState(() {
                        _minhaCarteiraCripto.add(moeda);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                );
              },
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
  }

  // --- Funções para Ações ---
  void _removerAcao(Acao acao) {
    setState(() {
      _minhaCarteiraAcoes.remove(acao);
    });
  }

  void _mostrarDialogAdicionarAcao() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Ação'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _acoesDisponiveis.length,
              itemBuilder: (context, index) {
                final acao = _acoesDisponiveis[index];
                final jaPossui = _minhaCarteiraAcoes.any((a) => a.sigla == acao.sigla);
                
                return ListTile(
                  title: Text(acao.nome),
                  subtitle: Text(acao.sigla),
                  trailing: jaPossui
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.add),
                  onTap: () {
                    if (!jaPossui) {
                      setState(() {
                        _minhaCarteiraAcoes.add(acao);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                );
              },
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
          // Conteúdo da Aba de Criptomoedas
          _buildCarteiraCripto(),
          
          // Conteúdo da Aba de Ações
          _buildCarteiraAcoes(),
        ],
      ),
    );
  }

  // --- Widgets de Construção de UI ---
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
              itemCount: _minhaCarteiraCripto.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.transparent, height: 8),
              itemBuilder: (context, index) {
                final moeda = _minhaCarteiraCripto[index];
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
              itemCount: _minhaCarteiraAcoes.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.transparent, height: 8),
              itemBuilder: (context, index) {
                final acao = _minhaCarteiraAcoes[index];
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