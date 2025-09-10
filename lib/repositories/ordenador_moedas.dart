import 'package:pedropaulo_cryptos/models/moeda.dart';
import 'package:pedropaulo_cryptos/models/opcoes_sort.dart';

void sortList({required List<Moeda> list, required SortOptions option}) {
  switch (option) {
    case SortOptions.porPrecoCrescente:
      list.sort((a, b) => a.preco.compareTo(b.preco));
      break;
    case SortOptions.porPrecoDecrescente:
      list.sort((a, b) => b.preco.compareTo(a.preco));
      break;
    case SortOptions.porNomeCrescente:
      list.sort((a, b) => a.nome.compareTo(b.nome));
      break;
    case SortOptions.porNomeDecrescente:
      list.sort((a, b) => b.nome.compareTo(a.nome));
      break;
  }
}
