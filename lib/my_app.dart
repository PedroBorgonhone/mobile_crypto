import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/pages/auth_gate.dart';


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
      home: const AuthGate(),
    );
  }
}