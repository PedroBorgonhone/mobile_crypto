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

  // --- NOVO MÉTODO DE RE-AUTENTICAÇÃO ---
  Future<void> reauthenticateWithPassword(String password) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Nenhum usuário logado para re-autenticar.');
      }

      // 1. Cria a "credencial" com o email do usuário e a senha que ele digitou
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!, 
        password: password,
      );
      
      // 2. Tenta re-autenticar
      await user.reauthenticateWithCredential(credential);

    } on FirebaseAuthException catch (e) {
      // Se a senha estiver errada, vai dar 'invalid-credential'
      print('Erro ao re-autenticar: ${e.code}');
      throw e; 
    } catch (e) {
      print('Erro desconhecido ao re-autenticar: $e');
      throw e;
    }
  }
}