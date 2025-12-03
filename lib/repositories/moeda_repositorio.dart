import 'package:pedropaulo_cryptos/models/moeda.dart';

class MoedaRepositorio {
  static List<Moeda> tabela = [
    Moeda(icone: 'images/avalanche.png',
    nome: 'Avalanche',
    sigla: 'AVAX',
    preco: 0.0),

    Moeda(icone: 'images/bitcoin.png', //noticias
    nome: 'Bitcoin', 
    sigla: 'BTC', 
    preco: 0.0),

    Moeda(icone: 'images/bnb.png',
    nome: 'Binance Coin',
    sigla: 'BNB',
    preco: 0.0),

    Moeda(icone: 'images/cardano.png', //noticias
    nome: 'Cardano',
    sigla: 'ADA',
    preco: 0.0),

    Moeda(icone: 'images/dogecoin.png',
    nome: 'Dogecoin',
    sigla: 'DOGE',
    preco: 0.0),

    Moeda(icone: 'images/ethereum.png', //noticias
    nome: 'Ethereum',
    sigla: 'ETH',
    preco: 0.0),

    Moeda(icone: 'images/polkadot.png',
    nome: 'Polkadot',
    sigla: 'DOT',
    preco: 0.0),

    Moeda(icone: 'images/shiba-inu.png',
    nome: 'Shiba Inu',
    sigla: 'SHIB',
    preco: 0.0),

    Moeda(icone: 'images/solana.png',
    nome: 'Solana',
    sigla: 'SOL',
    preco: 0.0),

    Moeda(icone: 'images/tether.png',
    nome: 'Tether',
    sigla: 'USDT',
    preco: 0.0),
  ];

  static void updatePrices(List<Moeda> moedasAtualizadas) {
    for (var moedaApi in moedasAtualizadas) {
      int index = tabela.indexWhere((moeda) => moeda.sigla == moedaApi.sigla);
      
      if (index != -1) {
        tabela[index] = Moeda(
          icone: tabela[index].icone,
          nome: moedaApi.nome,
          sigla: moedaApi.sigla,
          preco: moedaApi.preco,
        );
      }
    }
  }
}