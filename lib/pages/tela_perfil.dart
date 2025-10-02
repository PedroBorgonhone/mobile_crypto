import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../repositories/usuario_repositorio.dart';

class TelaPerfil extends StatefulWidget {
  final Usuario usuario;

  const TelaPerfil({super.key, required this.usuario});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  final UsuarioRepositorio _repo = UsuarioRepositorio();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.usuario.usuario);
    _emailController = TextEditingController(text: widget.usuario.email);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _salvarAlteracoes() {
    if (_formKey.currentState!.validate()) {
      final String novoUsername = _usernameController.text.trim();
      final String novoEmail = _emailController.text.trim();
      final String usuarioAntigo = widget.usuario.usuario;

      // Chama a função de atualização no repositório
      final Usuario? usuarioAtualizado = _repo.atualizarUsuario(
        usuarioAntigo: usuarioAntigo,
        novoUsuario: novoUsername,
        novoEmail: novoEmail,
      );

      if (usuarioAtualizado != null) {
        // Sucesso na atualização
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Perfil atualizado com sucesso!'),
              backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro: Username ou Email já em uso.'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF003366),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Foto do Usuário (Ícone Enorme)
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white54, width: 3),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              TextFormField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Username', Icons.person_outline),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O username não pode ser vazio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Email', Icons.email_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O email não pode ser vazio';
                  }
                  if (!value.contains('@')) {
                    return 'Insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _salvarAlteracoes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF90CAF9), // Cor de destaque
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Salvar Alterações',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 2),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }
}