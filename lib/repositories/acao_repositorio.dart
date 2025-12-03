// lib/repositories/acao_repositorio.dart

import 'package:pedropaulo_cryptos/models/acao.dart';

class AcaoRepositorio {
  static List<Acao> tabela = [

    Acao(
      sigla: 'AAPL',
      nome: 'Apple Inc.',
      preco: 0.0, // Preço em USD para exemplo
    ),
    Acao(
      sigla: 'TSLA',
      nome: 'Tesla, Inc.',
      preco: 0.0, // Preço em USD para exemplo
    ),
    Acao(
      sigla: 'NVDA',
      nome: 'NVIDIA Corp.',
      preco: 0.0, // Preço em USD para exemplo
    ),
  ];

  static void updatePrices(List<Acao> acoesAtualizadas) {
    for (var acaoApi in acoesAtualizadas) {
      int index = tabela.indexWhere((acao) => acao.sigla == acaoApi.sigla);
      
      if (index != -1) {
        tabela[index] = Acao(
          sigla: acaoApi.sigla,
          nome: acaoApi.nome,
          preco: acaoApi.preco,
        );
      }
    }
  }
}

