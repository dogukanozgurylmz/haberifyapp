import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? currentUser() {
    try {
      var currentUser = _firebaseAuth.currentUser;
      return currentUser;
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    return googleSignInAccount;
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> confirmPasswordReset(code, newPassword) async {
    await _firebaseAuth.confirmPasswordReset(
        code: code, newPassword: newPassword);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }
}
