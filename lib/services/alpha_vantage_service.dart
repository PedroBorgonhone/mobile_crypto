import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/acao.dart';
import '../repositories/acao_repositorio.dart'; 

class AcaoService {
  final String _apiKey = 'XPOKQZI4ZPI601BP'; 
  final String _baseUrl = 'https://www.alphavantage.co/query?';

  final List<String> _simbolosSuportados = AcaoRepositorio.tabela.map((a) => a.sigla).toList();

  Future<List<Acao>> fetchCurrentQuotes() async {
    final List<Acao> listaAtualizada = [];

    for (var acaoEstatica in AcaoRepositorio.tabela) {
      final String symbol = acaoEstatica.sigla;
      final url = Uri.parse(
        '${_baseUrl}function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey'
      );

      final response = await http.get(url);
      
      await Future.delayed(Duration(seconds: 12)); 

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final Map<String, dynamic>? globalQuote = json['Global Quote'];

        if (globalQuote != null && globalQuote.isNotEmpty) {
          final double preco = double.tryParse(globalQuote['05. price'] as String) ?? 0.0;
          
          listaAtualizada.add(Acao(
            sigla: symbol,
            nome: acaoEstatica.nome,
            preco: preco,
          ));
        }
      } else {
        print('Falha ao carregar $symbol: ${response.statusCode}');
      }
    }

    return listaAtualizada;
  }
}