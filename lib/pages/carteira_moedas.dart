import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/repositories/moeda_repositorio.dart';

class CarteiraMoedas extends StatelessWidget{
  const CarteiraMoedas({super.key});

  @override
  Widget build (BuildContext context){
    final tabela = MoedaRepositorio.tabela;

    return Scaffold(
      appBar: AppBar (
        title: Text('Carteira de Crypto Moedas'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int moeda) {
          // ignore: non_constant_identifier_names
          final Moeda = tabela[moeda];
          return ListTile(
            leading: Image.asset(Moeda.icone, width: 40,),
            title: Text(Moeda.nome),
            trailing: Text('R\$ ${Moeda.preco.toStringAsFixed(2)}'),
          );
        },
        padding: EdgeInsets.all(16),
        separatorBuilder: (_,__) => Divider(), 
        itemCount: tabela.length)
    );
  }
}