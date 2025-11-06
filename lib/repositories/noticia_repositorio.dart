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
      conteudo: 'O Bitcoin (BTC) continua a solidificar sua posição como uma reserva de valor digital, atraindo a atenção de grandes investidores institucionais. Em um cenário de crescente inflação global e instabilidade nos mercados tradicionais, a criptomoeda é vista como uma forma de proteção de capital, similar ao papel historicamente desempenhado pelo ouro. Analistas apontam que a descentralização e a oferta limitada do Bitcoin são fatores-chave para essa percepção de segurança a longo prazo.',
      ativoTag: 'BTC', // <-- ADICIONADO
    ),

    Noticia(
      fonte: 'Indústria & Energia Global',
      titulo: 'WEG Anuncia Expansão e Fecha Contrato Bilionário para Parque Eólico na Europa',
      subtitulo: 'Gigante brasileira consolida liderança no setor de energia renovável com novo projeto que fornecerá energia limpa.',
      imagemAsset: 'images/weg_news.png',
      prazo: PrazoIndicador.longo,
      conteudo: 'A WEG, multinacional brasileira de equipamentos elétricos, anunciou hoje a assinatura de um contrato de 2 bilhões de euros para o fornecimento de turbinas para um novo parque eólico offshore no Mar do Norte. O projeto reforça a posição da empresa como uma líder global na transição energética e tem capacidade para fornecer energia limpa para mais de 500 mil residências, um marco para a indústria nacional.',
      ativoTag: 'WEGE3', // <-- ADICIONADO
    ),
    
    Noticia(
      fonte: 'Tech Stocks Today',
      titulo: 'Nvidia Surpreende o Mercado com Nova Geração de GPUs para IA e Anuncia Desdobramento de Ações',
      subtitulo: 'Ações disparam com a expectativa de domínio contínuo no setor de IA e maior acessibilidade para investidores.',
      imagemAsset: 'images/nvidia_news.png',
      prazo: PrazoIndicador.medio,
      conteudo: 'A Nvidia lançou sua nova arquitetura de GPUs, codinome "Prometheus", prometendo um salto de 5x no desempenho para cargas de trabalho de Inteligência Artificial. A notícia, somada ao anúncio de um desdobramento de ações de 10 por 1 para tornar os papéis mais acessíveis, fez as ações da empresa subirem mais de 8% no pré-mercado. O movimento sinaliza uma forte confiança da empresa em seu domínio no crescente mercado de IA.',
      ativoTag: 'NVDA', // <-- ADICIONADO
    ),

    Noticia(
      fonte: 'Future of Finance',
      titulo: 'Atualização "Dencun" do Ethereum Reduz Drasticamente as Taxas de Transação em Redes de Camada 2',
      subtitulo: 'Analistas preveem uma explosão de novos usuários e DApps na rede, mas alertam para a volatilidade no curto prazo.',
      imagemAsset: 'images/ethereum_news.png',
      prazo: PrazoIndicador.curto,
      conteudo: 'A mais recente atualização da rede Ethereum, conhecida como "Dencun", foi implementada com sucesso, introduzindo o "proto-danksharding". Essa melhoria técnica reduz em até 90% os custos de transação para os usuários de redes de camada 2, como Arbitrum e Optimism. A expectativa é que a mudança impulsione uma nova onda de adoção, embora o preço do ETH possa enfrentar volatilidade enquanto o mercado se ajusta à nova dinâmica.',
      ativoTag: 'ETH', // <-- ADICIONADO
    ),

    Noticia(
      fonte: 'Automotive Innovations',
      titulo: 'Tesla Anuncia Investimento de \$2 Bilhões em Nova Fábrica de Baterias para Impulsionar o "Model 2"',
      subtitulo: 'A empresa visa garantir a produção em massa de seu veículo mais acessível, mirando a liderança no mercado de elétricos populares.',
      imagemAsset: 'images/tesla_news.png',
      prazo: PrazoIndicador.longo,
      conteudo: 'Em um movimento estratégico para dominar o mercado de veículos elétricos de massa, a Tesla confirmou um investimento de \$2 bilhões na construção de uma nova Gigafábrica no México, focada exclusivamente na produção de baterias de nova geração. Essa produção verticalizada é essencial para viabilizar o "Model 2", o aguardado carro popular da marca, com preço estimado abaixo de \$25.000, o que poderia acelerar drasticamente a transição para a mobilidade elétrica.',
      ativoTag: 'TSLA', // <-- ADICIONADO
    ),

    Noticia(
      fonte: 'Blockchain Futurist',
      titulo: 'Cardano Lança Nova Fase de Contratos Inteligentes Focada em Identidade Digital na África',
      subtitulo: 'A atualização visa empoderar milhões com um sistema de identidade soberana na blockchain, facilitando acesso a serviços.',
      imagemAsset: 'images/cardano_news.png',
      prazo: PrazoIndicador.medio,
      conteudo: 'A Fundação Cardano, em parceria com ONGs locais, iniciou a implementação de um sistema de identidade digital soberana em blockchain para comunidades rurais na Etiópia. O projeto visa fornecer uma identidade digital verificável para cidadãos que não possuem documentação tradicional, permitindo-lhes acesso a serviços financeiros, registros de propriedade e votação. A iniciativa é um dos maiores testes de caso de uso real para a tecnologia blockchain em impacto social.',
      ativoTag: 'ADA', // <-- ADICIONADO
    ),
  ];
}