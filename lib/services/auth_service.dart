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
      rethrow;
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
      rethrow;
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
      rethrow; 
    } catch (e) {
      print('Erro desconhecido ao re-autenticar: $e');
      rethrow;
    }
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await reauthenticateWithPassword(oldPassword);
      
      await _firebaseAuth.currentUser!.updatePassword(newPassword);

    } catch (e) {
      print('Erro ao atualizar senha: $e');
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser!.delete();
    } catch (e) {
      print('Erro ao excluir conta do Auth: $e');
      rethrow;
    }
  }
}