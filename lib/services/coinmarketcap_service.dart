import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/moeda.dart'; 
import '../repositories/moeda_repositorio.dart'; 

class MoedaService {
  final String _apiKey = 'aa5e287d495a43558feb0d5f5809739d'; 
  final String _baseUrl = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest';
  
  final List<String> _simbolosSuportados = MoedaRepositorio.tabela.map((m) => m.sigla).toList(); 

  Future<List<Moeda>> fetchCryptos() async {
    final String symbols = _simbolosSuportados.join(',');
    final url = Uri.parse('$_baseUrl?symbol=$symbols&convert=BRL');

    final response = await http.get(
      url,
      headers: {
        'X-CMC_PRO_API_KEY': _apiKey, 
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<Moeda> listaAtualizada = [];
      
      for (var moedaEstatica in MoedaRepositorio.tabela) {
        final String simbolo = moedaEstatica.sigla;
        final Map<String, dynamic>? dadosAPI = json['data']?[simbolo];

        if (dadosAPI != null) {
          final Map<String, dynamic> quote = dadosAPI['quote']['BRL'];
          
          listaAtualizada.add(Moeda(
            icone: moedaEstatica.icone,
            nome: dadosAPI['name'] as String,
            sigla: simbolo,
            preco: quote['price'] as double,
          ));
        }
      }
      return listaAtualizada;
    } else {
      throw Exception('Falha ao carregar dados da CoinMarketCap: ${response.statusCode}');
    }
  }
}