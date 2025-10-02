// lib/repositories/acao_repositorio.dart

import 'package:pedropaulo_cryptos/models/acao.dart';

class AcaoRepositorio {
  static List<Acao> tabela = [
    Acao(
      sigla: 'PETR4',
      nome: 'Petrobras',
      preco: 38.45,
    ),
    Acao(
      sigla: 'MGLU3',
      nome: 'Magazine Luiza',
      preco: 12.80,
    ),
    Acao(
      sigla: 'WEGE3',
      nome: 'WEG',
      preco: 35.15,
    ),
    Acao(
      sigla: 'ITUB4',
      nome: 'Itaú Unibanco',
      preco: 31.90,
    ),
    Acao(
      sigla: 'AAPL',
      nome: 'Apple Inc.',
      preco: 170.50, // Preço em USD para exemplo
    ),
    Acao(
      sigla: 'TSLA',
      nome: 'Tesla, Inc.',
      preco: 177.80, // Preço em USD para exemplo
    ),
    Acao(
      sigla: 'NVDA',
      nome: 'NVIDIA Corp.',
      preco: 121.79, // Preço em USD para exemplo
    ),
  ];
}