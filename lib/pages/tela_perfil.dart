// lib/pages/tela_perfil.dart

import 'package:flutter/material.dart';
import 'package:pedropaulo_cryptos/models/usuario.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  // Usuário de exemplo agora não tem mais imagem
  final Usuario _usuario = Usuario(
    nome: 'Paulo',
    email: 'paulo@email.com',
  );

  late TextEditingController _nomeController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: _usuario.nome);
    _emailController = TextEditingController(text: _usuario.email);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar agora mostra a inicial do nome
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue.shade800,
              child: Text(
                // Pega a primeira letra do nome do usuário para mostrar como inicial
                _usuario.nome.isNotEmpty ? _usuario.nome[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 48), // Aumentei o espaço aqui

            // Campos de texto e botões
            TextField(
              controller: _nomeController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nome',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final novoNome = _nomeController.text;
                final novoEmail = _emailController.text;
                
                setState(() {
                  _usuario.nome = novoNome;
                  _usuario.email = novoEmail;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Perfil atualizado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'Salvar Alterações',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            
            TextButton(
              onPressed: () {
                print('Usuário deslogado!');
              },
              child: const Text(
                'Sair da Conta',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}