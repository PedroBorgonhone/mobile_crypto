import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/my_app.dart';

// 1. Importar o Firebase Core
import 'package:firebase_core/firebase_core.dart';

// 2. Importar o arquivo de configuração gerado pela CLI
// (Este é o arquivo que o 'flutterfire configure' criou)
import 'firebase_options.dart'; 

// 3. Transformar o main em 'async'
void main() async {
  
  // 4. Garantir que o Flutter esteja pronto
  WidgetsFlutterBinding.ensureInitialized();
  
  // 5. Inicializar o Firebase
  // Ele usa o arquivo 'firebase_options.dart' para saber quais chaves usar
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 6. Rodar seu App (como antes)
  runApp(const MyApp());
}