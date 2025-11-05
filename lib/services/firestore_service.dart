// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';//erro aqui
import 'package:firebase_auth/firebase_auth.dart'; // Precisamos disso para o update do email

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance; //erro aqui

  // --- MÉTODO ANTIGO (Salvar no Registro) ---
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
      });
    } catch (e) {
      print('Erro ao salvar dados no Firestore: $e');
      throw Exception('Erro ao salvar perfil de usuário.');
    }
  }

  // --- NOVO MÉTODO (Buscar Dados do Usuário) ---
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _db.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        return doc.data(); // Retorna o mapa de dados (ex: {'username': 'Paulo', 'email': '...'})
      }
      return null; // Usuário do Auth existe, mas não tem "pasta" no Firestore
    } catch (e) {
      print('Erro ao buscar dados do Firestore: $e');
      throw Exception('Erro ao buscar dados do usuário.');
    }
  }

  // --- NOVO MÉTODO (Atualizar Perfil) ---
  Future<void> updateUserData({
    required String uid,
    required String newUsername,
    required String newEmail,
  }) async {
    try {
      // 1. Atualiza os dados no "Arquivo" (Firestore)
      await _db.collection('usuarios').doc(uid).update({
        'username': newUsername,
        'email': newEmail,
      });

      // 2. Atualiza o email na "Portaria" (Auth)
      // (Opcional, mas muito importante para o login)
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.email != newEmail) {
        await currentUser.verifyBeforeUpdateEmail(newEmail);
      }
    } on FirebaseAuthException catch (e) {
      print('Erro ao atualizar e-mail no Auth: ${e.code}');
      // Se a senha for antiga, o Firebase pode bloquear isso.
      // Vamos lançar o erro para a tela de perfil tratar.
      rethrow;
    } catch (e) {
      print('Erro ao atualizar dados no Firestore: $e');
      throw Exception('Erro ao atualizar perfil.');
    }
  }
}