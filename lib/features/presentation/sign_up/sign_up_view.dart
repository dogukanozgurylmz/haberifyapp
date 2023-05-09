import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haberifyapp/features/data/datasouce/local/user_local_datasource.dart';
import 'package:haberifyapp/features/data/repositories/auth_repository.dart';
import 'package:haberifyapp/features/data/repositories/follow_repository.dart';
import 'package:haberifyapp/features/data/repositories/follower_repository.dart';
import 'package:haberifyapp/features/data/repositories/user_repository.dart';
import 'package:haberifyapp/features/presentation/sign_in/sign_in_view.dart';
import 'package:haberifyapp/features/widgets/custom_textformfield.dart';
import 'package:image_picker/image_picker.dart';

import 'cubit/signup_cubit.dart';

class SignUpView extends StatelessWidget {
  final UserRepository userRepository = UserRepository();
  final AuthRepository authRepository = AuthRepository();
  final UserLocalDatasource userLocalDatasource = UserLocalDatasource();
  final FollowRepository followRepository = FollowRepository();
  final FollowerRepository followerRepository = FollowerRepository();
  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(
        userRepository: userRepository,
        authRepository: authRepository,
        userLocalDatasource: userLocalDatasource,
        followRepository: followRepository,
        followerRepository: followerRepository,
      ),
      child: BlocBuilder<SignupCubit, SignupState>(
        builder: (context, state) {
          var cubit = context.read<SignupCubit>();
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: state.image.path != ""
                                    ? FileImage(state.image)
                                    : const NetworkImage(
                                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")
                                        as ImageProvider),
                          ),
                          child: InkWell(
                            onTap: () async =>
                                await cubit.getImageFromCameraOrGallery(
                                    source: ImageSource.gallery),
                            child: const SizedBox(
                              width: 120,
                              height: 120,
                              child: Icon(Icons.add_a_photo_outlined),
                            ),
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () async =>
                      //       await cubit.getImageFromCameraOrGallery(
                      //           source: ImageSource.gallery),
                      //   child: const SizedBox(
                      //     width: 200,
                      //     height: 200,
                      //     child: Icon(Icons.add_a_photo_outlined),
                      //   ),
                      // ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ad",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextFormField(
                        controller: cubit.firstnameController,
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
                        controller: cubit.lastnameController,
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
                        controller: cubit.usernameController,
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
                        controller: cubit.emailController,
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
                        controller: cubit.passwordController,
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
                        controller: cubit.repeatPasswordController,
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
                      state.isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xffff0000),
                            )
                          : GestureDetector(
                              onTap: () async {
                                if (cubit.controle()) {
                                  await cubit.createUserWithEmailAndPassword();
                                  await cubit.uploadImage();
                                }
                                if (state.isSignUp) {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const SignInView(),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.errorMessage),
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     GestureDetector(
                      //       child: Container(
                      //         padding: const EdgeInsets.all(12),
                      //         width: MediaQuery.of(context).size.width * 0.45,
                      //         decoration: BoxDecoration(
                      //           color: const Color(0xffff0000),
                      //           borderRadius: BorderRadius.circular(30),
                      //         ),
                      //         child: const Text(
                      //           "Google ile kayıt ol",
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     GestureDetector(
                      //       child: Container(
                      //         padding: const EdgeInsets.all(12),
                      //         width: MediaQuery.of(context).size.width * 0.45,
                      //         decoration: BoxDecoration(
                      //           color: Colors.black,
                      //           borderRadius: BorderRadius.circular(30),
                      //         ),
                      //         child: const Text(
                      //           "Apple ile kayıt ol",
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 16),
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
        },
      ),
    );
  }
}
