import 'package:flutter/material.dart';

class CarteiraMoedas extends StatelessWidget{
  const CarteiraMoedas({super.key});

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar (
        title: Text('Carteira de Crypto Moedas'),
      ),
      body: Center(
        child: Text('Conteúdo da Carteira de Crypto Moedas'),
      ),
    );
  }
}