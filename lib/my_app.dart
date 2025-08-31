import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/paginas/carteira_moedas.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypto Paulo e Pedro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: CarteiraMoedas(),
    );
  }
}