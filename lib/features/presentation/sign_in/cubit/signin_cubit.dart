import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:haberifyapp/features/data/datasouce/local/user_local_datasource.dart';
import 'package:haberifyapp/features/data/repositories/auth_repository.dart';
import 'package:haberifyapp/features/data/repositories/user_repository.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required UserLocalDatasource userLocalDatasource,
  })  : _authRepository = authRepository,
        _userLocalDatasource = userLocalDatasource,
        _userRepository = userRepository,
        super(const SigninState(
          status: SignInStatus.INITIAL,
          isSignIn: false,
          isSignInGoogle: false,
        ));

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final UserLocalDatasource _userLocalDatasource;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await _authRepository
          .signInWithEmailAndPassword(
              emailController.text.trim(), passwordController.text.trim())
          .then((value) => emit(state.copyWith(isSignIn: true)));
      await checkUser();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    var googleSignInAccount = await _authRepository.signInWithGoogle();
    var userEntity = await _userRepository.getByUID(googleSignInAccount!.id);
    if (userEntity.id.isNotEmpty) {
      emit(state.copyWith(isSignInGoogle: false));
    } else {
      emit(state.copyWith(isSignInGoogle: true));
    }
  }

  Future<void> checkUser() async {
    await _userLocalDatasource.deleteAll();
    var currentUser = _authRepository.currentUser();
    if (currentUser != null) {
      var userEntity = await _userRepository.getByUID(currentUser.uid);
      await _userLocalDatasource.add(userEntity);
    }
  }
}
