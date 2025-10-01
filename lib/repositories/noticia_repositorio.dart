// lib/repositories/noticia_repositorio.dart

import 'package:pedropaulo_cryptos/models/noticia.dart';
import 'package:pedropaulo_cryptos/models/prazo_indicador.dart';

class NoticiaRepositorio {
  static List<Noticia> tabela = [
  
    Noticia(
      fonte: 'Diário Cripto',
      titulo: 'Bitcoin se Consolida como "Ouro Digital" em Meio a Incertezas Econômicas Globais',
      subtitulo: 'Investidores institucionais aumentam exposição ao BTC como reserva de valor, buscando proteção contra a inflação.',
      imagemAsset: 'images/bitcoin_news.png',
      prazo: PrazoIndicador.longo,
    ),

    Noticia(
      fonte: 'Indústria & Energia Global',
      titulo: 'WEG Anuncia Expansão e Fecha Contrato Bilionário para Parque Eólico na Europa',
      subtitulo: 'Gigante brasileira consolida liderança no setor de energia renovável com novo projeto que fornecerá energia limpa.',
      imagemAsset: 'images/weg_news.png',
      prazo: PrazoIndicador.longo,
    ),
    
    Noticia(
      fonte: 'Tech Stocks Today',
      titulo: 'Nvidia Surpreende o Mercado com Nova Geração de GPUs para IA e Anuncia Desdobramento de Ações',
      subtitulo: 'Ações disparam com a expectativa de domínio contínuo no setor de IA e maior acessibilidade para investidores.',
      imagemAsset: 'images/nvidia_news.png',
      prazo: PrazoIndicador.medio,
    ),

    Noticia(
      fonte: 'Future of Finance',
      titulo: 'Atualização "Dencun" do Ethereum Reduz Drasticamente as Taxas de Transação em Redes de Camada 2',
      subtitulo: 'Analistas preveem uma explosão de novos usuários e DApps na rede, mas alertam para a volatilidade no curto prazo.',
      imagemAsset: 'images/ethereum_news.png',
      prazo: PrazoIndicador.curto,
    ),

    Noticia(
      fonte: 'Automotive Innovations',
      titulo: 'Tesla Anuncia Investimento de \$2 Bilhões em Nova Fábrica de Baterias para Impulsionar o "Model 2"',
      subtitulo: 'A empresa visa garantir a produção em massa de seu veículo mais acessível, mirando a liderança no mercado de elétricos populares.',
      imagemAsset: 'images/tesla_news.png',
      prazo: PrazoIndicador.longo,
    ),

    Noticia(
      fonte: 'Blockchain Futurist',
      titulo: 'Cardano Lança Nova Fase de Contratos Inteligentes Focada em Identidade Digital na África',
      subtitulo: 'A atualização visa empoderar milhões com um sistema de identidade soberana na blockchain, facilitando acesso a serviços.',
      imagemAsset: 'images/cardano_news.png',
      prazo: PrazoIndicador.medio,
    ),
  ];
}