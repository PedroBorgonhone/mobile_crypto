import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/models/moeda.dart';
import 'package:pedropaulo_cryptos/models/opcoes_sort.dart';
import 'package:pedropaulo_cryptos/repositories/moeda_repositorio.dart';
import 'package:pedropaulo_cryptos/repositories/ordenador_moedas.dart';
import 'package:pedropaulo_cryptos/services/coinmarketcap_service.dart';

class CarteiraMoedas extends StatefulWidget {
  const CarteiraMoedas({super.key});

  @override
  State<CarteiraMoedas> createState() => _CarteiraMoedasState();
}

class _CarteiraMoedasState extends State<CarteiraMoedas> {
  final MoedaService _moedaService = MoedaService();

  late List<Moeda> tabela;
  SortOptions _currentSortOption = SortOptions.porPrecoDecrescente;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    tabela = MoedaRepositorio.tabela;
    _loadAllMoedas();
  }

  void _loadAllMoedas() async {
    setState(() => _isLoading = true);
    try {
      tabela = await _moedaService.fetchCryptos();
      _sortList();
    } catch (e) {
      print("Erro ao carregar lista de moedas na CarteiraMoedas: $e");
      tabela = []; 
    }
    setState(() => _isLoading = false);
  }

  void _sortList({SortOptions? newSortOption}) {
    if (newSortOption != null) {
      _currentSortOption = newSortOption;
    }

    setState(() {
      sortList(list: tabela, option: _currentSortOption);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carteira de Crypto Moedas'),
        backgroundColor: Colors.blueGrey,
        actions: [
          PopupMenuButton<SortOptions>(
            onSelected: (option) => _sortList(newSortOption: option),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOptions>>[
              const PopupMenuItem(
                value: SortOptions.porPrecoCrescente,
                child: Text('Ordenar por Preço Crescente'),
              ),
              const PopupMenuItem(
                value: SortOptions.porPrecoDecrescente,
                child: Text('Ordenar por Preço Decrescente'),
              ),
              const PopupMenuItem(
                value: SortOptions.porNomeCrescente,
                child: Text('Ordenar por Nome Crescente'),
              ),
              const PopupMenuItem(
                value: SortOptions.porNomeDecrescente,
                child: Text('Ordenar por Nome Decrescente'),
              ),
            ],
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              final moeda = tabela[index];
              return ListTile(
                leading: Image.asset(moeda.icone, width: 40),
                title: Text(moeda.nome),
                subtitle: Text(moeda.sigla),
                trailing: Text('R\$ ${moeda.preco.toStringAsFixed(2)}'),
              );
            },
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: tabela.length,
          ),
    );
  }
}