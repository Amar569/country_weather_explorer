import 'package:country_weather_explorer/core/app_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/app_exception.dart';

class AuthRepository {
  AuthRepository([FirebaseAuth? auth]) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signIn(String email, String password) =>
      _guard(() => _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password));

  Future<void> register(String email, String password) =>
      _guard(() => _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password));

  Future<void> signOut() => _auth.signOut();

  Future<void> _guard(Future<dynamic> Function() action) async {
    try {
      await action();
    } on FirebaseAuthException catch (e) {
      throw AppException(_message(e.code));
    } catch (_) {
      throw const AppException('Authentication failed. Please try again.');
    }
  }

  String _message(String code) {
    switch (code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Password is too weak (min 6 characters).';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Check your network.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
