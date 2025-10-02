import 'package:pedropaulo_cryptos/models/prazo_indicador.dart';

class Noticia {
  final String fonte;
  final String titulo;
  final String subtitulo;
  final String imagemAsset;
  final PrazoIndicador prazo;
  final String conteudo;  

  Noticia({
    required this.fonte,
    required this.titulo,
    required this.subtitulo,
    required this.imagemAsset,
    required this.prazo,
    required this.conteudo, 
  });
}
