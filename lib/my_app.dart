// lib/my_app.dart

import 'package:flutter/material.dart';
// 1. IMPORTAR O NOVO "PORTEIRO"
import 'package:pedropaulo_cryptos/pages/auth_gate.dart';
// import 'package:pedropaulo_cryptos/pages/tela_login.dart'; // <- NÃO É MAIS NECESSÁRIO AQUI

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypto Paulo e Pedro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF163E73),
      ),
      
      // 2. MUDAR A "HOME" DO APP
      // home: const TelaLogin(), // <- ANTES
      home: const AuthGate(), // <- AGORA
    );
  }
}