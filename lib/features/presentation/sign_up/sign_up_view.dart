// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:haberifyapp/features/presentation/sign_in/sign_in_view.dart';
import 'package:haberifyapp/features/presentation/sign_up/sign_up_view_model.dart';
import 'package:haberifyapp/features/widgets/custom_textformfield.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => SignUpViewModel(),
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ad",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: "Ad",
                        borderRadius: 30,
                      ),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Soyad",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _surnameController,
                        labelText: "Soyad",
                        borderRadius: 30,
                      ),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Kullanıcı adı",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _usernameController,
                        labelText: "Kullanıcı adı",
                        borderRadius: 30,
                      ),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Şifre Tekrarı",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _repeatPasswordController,
                        labelText: "Şifre Tekrarı",
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
                          const Text("Kullanıcı sözleşmesi"),
                        ],
                      ),
                      viewModel.isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xffff0000),
                            )
                          : GestureDetector(
                              onTap: () async {
                                await viewModel.signUp(
                                  firstname: _nameController.text,
                                  lastname: _surnameController.text,
                                  username: _usernameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                if (viewModel.isSignUp) {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const SignInView(),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Kayıt başarısız"),
                                    ),
                                  );
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
                                  "Kayıt ol",
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
                                "Google ile kayıt ol",
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
                                "Apple ile kayıt ol",
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
                          builder: (context) => const SignInView(),
                        )),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Daha önce kayıt olduysan ',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'giriş yap',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0A0E11),
                                ),
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
