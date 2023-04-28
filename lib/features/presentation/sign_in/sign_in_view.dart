// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:haberifyapp/features/presentation/main_view.dart';
import 'package:haberifyapp/features/presentation/sign_in/sign_in_view_model.dart';
import 'package:haberifyapp/features/widgets/custom_textformfield.dart';
import 'package:stacked/stacked.dart';

import '../sign_up/sign_up_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => SignInViewModel(),
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "haberify",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(height: 80),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "E-posta",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _emailController,
                        labelText: "E-posta",
                        borderRadius: 30,
                      ),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Şifre",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _passwordController,
                        labelText: "Şifre",
                        borderRadius: 30,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (value) {},
                            activeColor: const Color(0xFFFF0000),
                            autofocus: true,
                            checkColor: Colors.white,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          const Text("Beni hatırla"),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          await viewModel.signIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (viewModel.isSignIn) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const MainView(),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Giriş başarısız")));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xffff0000),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "Giriş yap",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                color: const Color(0xffff0000),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "Google ile giriş yap",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "Apple ile giriş yap",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) => const SignUpView(),
                        )),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Hesabın yoksa hemen ',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'kayıt ol',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff0A0E11)),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
