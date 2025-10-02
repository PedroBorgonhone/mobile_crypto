import 'package:pedropaulo_cryptos/models/acao.dart';
import 'package:pedropaulo_cryptos/models/moeda.dart';
import 'package:pedropaulo_cryptos/repositories/acao_repositorio.dart';
import 'package:pedropaulo_cryptos/repositories/moeda_repositorio.dart';

class CarteiraRepositorio {
  
  static List<Moeda> carteiraCripto = MoedaRepositorio.tabela.sublist(0, 3);
  
  static List<Acao> carteiraAcoes = AcaoRepositorio.tabela.sublist(0, 2);
}