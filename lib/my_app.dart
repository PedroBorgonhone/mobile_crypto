import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/pages/tela_login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypto Paulo e Pedro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF074973),
      ),
      home: TelaLogin(),
    );
  }
}
