// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- MÉTODO ATUALIZADO (Salvar no Registro) ---
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
        // 1. ADICIONADO: Inicializa as carteiras como listas vazias
        'carteiraCripto': [],
        'carteiraAcoes': [],
      });
    } catch (e) {
      print('Erro ao salvar dados no Firestore: $e');
      throw Exception('Erro ao salvar perfil de usuário.');
    }
  }

  // --- MÉTODO (Buscar Dados do Usuário) ---
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

  // --- MÉTODO (Atualizar Perfil) ---
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

  // --- NOVOS MÉTODOS PARA A CARTEIRA ---

  // Tipo pode ser 'carteiraCripto' ou 'carteiraAcoes'
  String _getFieldNameFromType(String type) {
    if (type == 'cripto') return 'carteiraCripto';
    if (type == 'acao') return 'carteiraAcoes';
    throw Exception('Tipo de ativo inválido');
  }

  // Adiciona um ativo (ex: 'BTC' ou 'PETR4') à lista no Firestore
  Future<void> addAssetToCarteira({
    required String uid,
    required String assetSymbol,
    required String type, // 'cripto' ou 'acao'
  }) async {
    final fieldName = _getFieldNameFromType(type);
    try {
      await _db.collection('usuarios').doc(uid).update({
        fieldName: FieldValue.arrayUnion([assetSymbol]),
      });
    } catch (e) {
      print('Erro ao adicionar ativo: $e');
      throw Exception('Erro ao adicionar ativo na carteira.');
    }
  }

  // Remove um ativo da lista no Firestore
  Future<void> removeAssetFromCarteira({
    required String uid,
    required String assetSymbol,
    required String type, // 'cripto' ou 'acao'
  }) async {
    final fieldName = _getFieldNameFromType(type);
    try {
      await _db.collection('usuarios').doc(uid).update({
        fieldName: FieldValue.arrayRemove([assetSymbol]),
      });
    } catch (e) {
      print('Erro ao remover ativo: $e');
      throw Exception('Erro ao remover ativo da carteira.');
    }
  }
}