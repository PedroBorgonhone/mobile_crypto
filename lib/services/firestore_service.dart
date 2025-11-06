// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedropaulo_cryptos/models/noticia.dart';
import 'package:pedropaulo_cryptos/repositories/noticia_repositorio.dart';
import 'package:pedropaulo_cryptos/models/prazo_indicador.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- MÉTODOS DE USUÁRIO (Criar, Ler, Atualizar) ---
  Future<void> saveUserData({
    required String uid,
    required String username,
    required String email,
  }) async {
    try {
      await _db.collection('usuarios').doc(uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'carteiraCripto': [],
        'carteiraAcoes': [],
      });
    } catch (e) {
      print('Erro ao salvar dados no Firestore: $e');
      throw Exception('Erro ao salvar perfil de usuário.');
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _db.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Erro ao buscar dados do Firestore: $e');
      throw Exception('Erro ao buscar dados do usuário.');
    }
  }

  Future<void> updateUserData({
    required String uid,
    required String newUsername,
    required String newEmail,
  }) async {
    try {
      await _db.collection('usuarios').doc(uid).update({
        'username': newUsername,
        'email': newEmail,
      });

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.email != newEmail) {
        await currentUser.verifyBeforeUpdateEmail(newEmail);
      }
    } on FirebaseAuthException catch (e) {
      print('Erro ao atualizar e-mail no Auth: ${e.code}');
      rethrow;
    } catch (e) {
      print('Erro ao atualizar dados no Firestore: $e');
      throw Exception('Erro ao atualizar perfil.');
    }
  }

  // --- NOVO MÉTODO (Excluir Dados do Usuário) ---
  Future<void> deleteUserData(String uid) async {
    try {
      // Deleta o "documento" (pasta) do usuário e todos os seus dados
      await _db.collection('usuarios').doc(uid).delete();
    } catch (e) {
      print('Erro ao excluir dados do Firestore: $e');
      throw Exception('Erro ao excluir dados do usuário.');
    }
  }

  // --- MÉTODOS DA CARTEIRA ---
  Future<void> addAssetToCarteira({
    required String uid,
    required String assetSymbol,
    required String type,
  }) async {
    final fieldName = type == 'cripto' ? 'carteiraCripto' : 'carteiraAcoes';
    try {
      await _db.collection('usuarios').doc(uid).update({
        fieldName: FieldValue.arrayUnion([assetSymbol]),
      });
    } catch (e) {
      print('Erro ao adicionar ativo: $e');
      throw Exception('Erro ao adicionar ativo na carteira.');
    }
  }

  Future<void> removeAssetFromCarteira({
    required String uid,
    required String assetSymbol,
    required String type,
  }) async {
    final fieldName = type == 'cripto' ? 'carteiraCripto' : 'carteiraAcoes';
    try {
      await _db.collection('usuarios').doc(uid).update({
        fieldName: FieldValue.arrayRemove([assetSymbol]),
      });
    } catch (e) {
      print('Erro ao remover ativo: $e');
      throw Exception('Erro ao remover ativo da carteira.');
    }
  }
  
  // --- MÉTODOS DE NOTÍCIAS ---
  Future<void> seedNoticiasDatabase() async {
    final noticiasCollection = _db.collection('noticias_publicas');
    final noticiasLocais = NoticiaRepositorio.tabela;
    print('Iniciando "semeadura" do banco de notícias...');
    final batch = _db.batch();
    for (var noticia in noticiasLocais) {
      final docRef = noticiasCollection.doc(); 
      batch.set(docRef, noticia.toMap()); 
    }
    await batch.commit();
    print('Banco de notícias "semeado" com ${noticiasLocais.length} notícias.');
  }

  Future<List<Noticia>> getNoticiasFiltradas(List<String> siglasDaCarteira) async {
    if (siglasDaCarteira.isEmpty) {
      return []; 
    }
    List<Noticia> noticiasFiltradas = [];
    final Set<String> siglasSet = Set.from(siglasDaCarteira);

    try {
      final snapshot = await _db
          .collection('noticias_publicas')
          .get();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final String? ativoTag = data['ativoTag'] as String?; 
        if (ativoTag != null && siglasSet.contains(ativoTag)) {
          noticiasFiltradas.add(
            Noticia(
              fonte: data['fonte'],
              titulo: data['titulo'],
              subtitulo: data['subtitulo'],
              imagemAsset: data['imagemAsset'],
              prazo: PrazoIndicador.values.firstWhere((e) => e.name == data['prazo']),
              conteudo: data['conteudo'],
              ativoTag: data['ativoTag'],
            ),
          );
        }
      }
      return noticiasFiltradas;
    } catch (e) {
      print('Erro ao buscar notícias filtradas (método loop): $e');
      return [];
    }
  }
}