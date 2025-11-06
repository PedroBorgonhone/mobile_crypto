// lib/models/noticia.dart
import 'package:pedropaulo_cryptos/models/prazo_indicador.dart';

class Noticia {
  final String fonte;
  final String titulo;
  final String subtitulo;
  final String imagemAsset;
  final PrazoIndicador prazo;
  final String conteudo;
  final String ativoTag; // <-- O campo que faltava

  Noticia({
    required this.fonte,
    required this.titulo,
    required this.subtitulo,
    required this.imagemAsset,
    required this.prazo,
    required this.conteudo,
    required this.ativoTag, // <-- O parâmetro que faltava
  });

  // A FUNÇÃO "toMap()" QUE FALTAVA
  // Converte este objeto Noticia em um Mapa (para o Firestore entender)
  Map<String, dynamic> toMap() {
    return {
      'fonte': fonte,
      'titulo': titulo,
      'subtitulo': subtitulo,
      'imagemAsset': imagemAsset,
      'prazo': prazo.name, // Salva o enum como string (ex: 'longo')
      'conteudo': conteudo,
      'ativoTag': ativoTag,
    };
  }
}