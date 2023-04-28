// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haberifyapp/features/presentation/main_view.dart';
import 'package:haberifyapp/features/presentation/sign_in/sign_in_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late FirebaseAuth firebaseAuth;
  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  void _checkIfUserIsLoggedIn() async {
    firebaseAuth = FirebaseAuth.instance;
    var currentUser = firebaseAuth.currentUser;
    bool isLoggedIn = false;
    if (currentUser != null) {
      isLoggedIn = true;
    }

    await Future.delayed(const Duration(seconds: 1));

    // Oturum açmışsa ana sayfaya yönlendir
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainView()),
      );
    }
    // Açmamışsa giriş sayfasına yönlendir
    else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "haberify",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
