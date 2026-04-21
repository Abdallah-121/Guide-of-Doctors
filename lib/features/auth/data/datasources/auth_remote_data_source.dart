import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/auth_user.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUser> login(String email, String password);
  Future<void> logout();
  AuthUser? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<AuthUser> login(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user == null || user.email == null) {
        throw AuthException('تعذر تسجيل الدخول.');
      }
      return AuthUser(uid: user.uid, email: user.email!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapMessage(e));
    }
  }

  @override
  AuthUser? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null || user.email == null) return null;
    return AuthUser(uid: user.uid, email: user.email!);
  }

  @override
  Future<void> logout() => firebaseAuth.signOut();

  String _mapMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'بيانات الدخول غير صحيحة.';
      case 'network-request-failed':
        return 'لا يوجد اتصال بالشبكة.';
      default:
        return 'حدث خطأ أثناء تسجيل الدخول.';
    }
  }
}
