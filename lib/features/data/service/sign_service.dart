import 'package:firebase_auth/firebase_auth.dart';

class SignService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Kullanıcı girişi başarılı oldu
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Kullanıcı bulunamadı.');
      } else if (e.code == 'wrong-password') {
        print('Yanlış şifre girdiniz.');
      }
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Kullanıcı girişi başarılı oldu
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }
}
