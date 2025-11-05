// lib/pages/auth_gate.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/pages/tela_login.dart';
import 'package:pedropaulo_cryptos/repositories/motion_bar_repositorio.dart'; // Onde está sua MainTabNavigator

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder é um widget que se reconstrói sozinho
    // toda vez que recebe uma nova informação do "stream"
    return StreamBuilder<User?>(
      // 1. O "canal" que estamos ouvindo: o status de login do Firebase
      stream: FirebaseAuth.instance.authStateChanges(),
      
      builder: (context, snapshot) {
        
        // 2. ENQUANTO VERIFICA:
        // Se o snapshot ainda não tem dados (está "waiting")
        // mostramos uma tela de carregamento.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF163E73), // Cor de fundo do seu app
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        // 3. SE O USUÁRIO ESTÁ LOGADO:
        // Se o snapshot TEM dados (snapshot.hasData), significa
        // que o stream enviou um objeto 'User'.
        if (snapshot.hasData && snapshot.data != null) {
          // Manda para a tela principal
          return const MainTabNavigator();
        }

        // 4. SE O USUÁRIO ESTÁ DESLOGADO:
        // Se o snapshot NÃO tem dados, o stream enviou 'null'.
        // Manda para a tela de login
        return const TelaLogin();
      },
    );
  }
}