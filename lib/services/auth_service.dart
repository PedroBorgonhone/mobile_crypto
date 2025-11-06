// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Erro de FirebaseAuth: ${e.code}');
      throw e;
    } catch (e) {
      print('Erro desconhecido no registro: $e');
      throw Exception('Ocorreu um erro inesperado.');
    }
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Erro de FirebaseAuth no Login: ${e.code}');
      throw e;
    } catch (e) {
      print('Erro desconhecido no login: $e');
      throw Exception('Ocorreu um erro inesperado.');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  Future<void> reauthenticateWithPassword(String password) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Nenhum usuário logado para re-autenticar.');
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!, 
        password: password,
      );
      
      await user.reauthenticateWithCredential(credential);

    } on FirebaseAuthException catch (e) {
      print('Erro ao re-autenticar: ${e.code}');
      throw e; 
    } catch (e) {
      print('Erro desconhecido ao re-autenticar: $e');
      throw e;
    }
  }

  // --- NOVO MÉTODO (Alterar Senha) ---
  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // 1. Re-autentica o usuário com a senha antiga
      await reauthenticateWithPassword(oldPassword);
      
      // 2. Se a re-autenticação foi bem-sucedida, atualiza para a nova senha
      await _firebaseAuth.currentUser!.updatePassword(newPassword);

    } catch (e) {
      // Se a senha antiga estiver errada ou a nova for fraca, vai lançar um erro
      print('Erro ao atualizar senha: $e');
      throw e;
    }
  }

  // --- NOVO MÉTODO (Excluir Conta) ---
  Future<void> deleteAccount() async {
    try {
      // (A re-autenticação deve ser feita ANTES de chamar este método)
      await _firebaseAuth.currentUser!.delete();
    } catch (e) {
      print('Erro ao excluir conta do Auth: $e');
      throw e;
    }
  }
}