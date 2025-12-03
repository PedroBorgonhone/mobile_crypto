import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io'; // Para o File e path

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 1. Inicializa o controlador da câmera
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium, // Qualidade da imagem
      enableAudio: false,      // Não precisamos de áudio para foto de perfil
    );

    // 2. Armazena o Future para saber quando a inicialização estiver completa
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // 3. Desativa o controlador quando o widget é destruído
    _controller.dispose();
    super.dispose();
  }

  // 4. Função de captura da foto
  Future<void> _takePicture(BuildContext context) async {
    try {
      // Espera até que a câmera esteja inicializada
      await _initializeControllerFuture;

      // Tenta tirar a foto e salva no local temporário
      final XFile image = await _controller.takePicture();

      // Retorna o caminho da foto para a TelaPerfil
      if (mounted) {
        Navigator.pop(context, image.path);
      }
    } catch (e) {
      print('Erro ao tirar foto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao acessar a câmera: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tirar Foto')),
      // Exibe um carregador enquanto a câmera está inicializando
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Se a inicialização for bem-sucedida, exibe o preview
            return CameraPreview(_controller);
          } else {
            // Caso contrário, exibe um carregador
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _takePicture(context),
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}