import 'package:pedropaulo_cryptos/models/moeda.dart';

class MoedaRepositorio {
  static List<Moeda> tabela = [
    Moeda(icone: 'images/avalanche.png',
    nome: 'Avalanche',
    sigla: 'AVAX',
    preco: 120.00),

    Moeda(icone: 'images/bitcoin.png',
    nome: 'Bitcoin', 
    sigla: 'BTC', 
    preco: 134000.00),

    Moeda(icone: 'images/bnb.png',
    nome: 'Binance Coin',
    sigla: 'BNB',
    preco: 80.00),

    Moeda(icone: 'images/cardano.png',
    nome: 'Cardano',
    sigla: 'ADA',
    preco: 3.50),

    Moeda(icone: 'images/dogecoin.png',
    nome: 'Dogecoin',
    sigla: 'DOGE',
    preco: 1.20),

    Moeda(icone: 'images/ethereum.png',
    nome: 'Ethereum',
    sigla: 'ETH',
    preco: 9000.00),

    Moeda(icone: 'images/polkadot.png',
    nome: 'Polkadot',
    sigla: 'DOT',
    preco: 25.00),

    Moeda(icone: 'images/shiba-inu.png',
    nome: 'Shiba Inu',
    sigla: 'SHIB',
    preco: 0.000012),

    Moeda(icone: 'images/solana.png',
    nome: 'Solana',
    sigla: 'SOL',
    preco: 250.00),

    Moeda(icone: 'images/tether.png',
    nome: 'Tether',
    sigla: 'USDT',
    preco: 5.30),

    Moeda(icone: 'images/toncoin.png',
    nome: 'Toncoin',
    sigla: 'TON',
    preco: 550.00),

    Moeda(icone: 'images/tron.png',
    nome: 'Tron',
    sigla: 'TRX',
    preco: 7.00),

    Moeda(icone: 'images/usdc.png',
    nome: 'USD Coin',
    sigla: 'USDC',
    preco: 90.00),

    Moeda(icone: 'images/xrp.png',
    nome: 'XRP',
    sigla: 'XRP',
    preco: 3.80),
  ];
}