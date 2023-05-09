import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:haberifyapp/features/data/datasouce/local/user_local_datasource.dart';
import 'package:haberifyapp/features/data/models/follow_model.dart';
import 'package:haberifyapp/features/data/repositories/auth_repository.dart';
import 'package:haberifyapp/features/data/repositories/follow_repository.dart';
import 'package:haberifyapp/features/data/repositories/follower_repository.dart';
import 'package:haberifyapp/features/data/repositories/user_repository.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/follower_model.dart';
import '../../../data/models/user_model.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required UserRepository userRepository,
    required AuthRepository authRepository,
    required UserLocalDatasource userLocalDatasource,
    required FollowRepository followRepository,
    required FollowerRepository followerRepository,
  })  : _userRepository = userRepository,
        _authRepository = authRepository,
        _userLocalDatasource = userLocalDatasource,
        _followRepository = followRepository,
        _followerRepository = followerRepository,
        super(SignupState(
          status: SignUpStatus.INITIAL,
          image: File(""),
          isSignUp: false,
          errorMessage: "",
          isLoading: false,
          isLoadImage: false,
        ));

  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  final UserLocalDatasource _userLocalDatasource;
  final FollowRepository _followRepository;
  final FollowerRepository _followerRepository;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String _downloadURL = "";

  Future<void> createUserWithEmailAndPassword() async {
    emit(state.copyWith(status: SignUpStatus.LOADING, isLoading: true));
    await _authRepository.signOut();
    await _authRepository.createUserWithEmailAndPassword(
        emailController.text.trim(), passwordController.text.trim());
    var currentUser = _authRepository.currentUser();
    await downloadImage();
    if (currentUser != null) {
      DateTime dateTime = DateTime.now();
      UserModel userModel = UserModel(
        profilePhotoUrl: _downloadURL,
        firstname: firstnameController.text.trim(),
        lastname: lastnameController.text.trim(),
        email: emailController.text.trim().toLowerCase(),
        username: usernameController.text.trim().toLowerCase(),
        isSecure: false,
        createdAt: dateTime.millisecondsSinceEpoch,
        updatedAt: dateTime.millisecondsSinceEpoch,
        id: currentUser.uid,
      );
      await createUser(userModel);
      await createFollow(userModel.username);
      await createFollower(userModel.username);
      emit(state.copyWith(isSignUp: true));
    }
    emit(state.copyWith(status: SignUpStatus.LOADED, isLoading: false));
  }

  Future<void> createFollow(String username) async {
    var followModel =
        FollowModel(id: '', username: username, followUsernames: []);
    await _followRepository.create(followModel);
  }

  Future<void> createFollower(String username) async {
    var followerModel =
        FollowerModel(id: '', username: username, followerUsernames: []);
    await _followerRepository.create(followerModel);
  }

  Future<void> createUser(UserModel userModel) async {
    await _userLocalDatasource.add(userModel);
    await _userRepository.create(userModel);
  }

  Future<void> uploadImage() async {
    emit(state.copyWith(isLoadImage: false));
    try {
      await _userRepository.uploadImage(image: state.image);
      emit(state.copyWith(isLoadImage: true));
    } catch (e) {
      // emit(state.copyWith(status: AddNewsStatus.ERROR));
    }
  }

  Future<void> downloadImage() async {
    _downloadURL = "";
    _downloadURL = _userRepository.getDownloadImage();
  }

  Future<void> getImageFromCameraOrGallery(
      {required ImageSource source}) async {
    emit(state.copyWith(image: File("")));
    try {
      final XFile? image =
          await _picker.pickImage(source: source, imageQuality: 50);
      if (image != null) {
        File file = File(image.path);
        emit(state.copyWith(image: file));
      }
    } catch (e) {
      // emit(state.copyWith(status: AddNewsStatus.ERROR));
    }
  }

  bool controle() {
    if (state.image.path == "") {
      emit(state.copyWith(errorMessage: "Fotoğraf boş olamaz"));
      return false;
    }
    if (!_emptyTextController()) {
      emit(state.copyWith(errorMessage: "Boş alan olamaz"));
      return false;
    }
    if (!_passwordNotEqualRepeatPassword()) {
      emit(state.copyWith(errorMessage: "Şifreler aynı değil"));
      return false;
    }
    return true;
  }

  bool _passwordNotEqualRepeatPassword() {
    if (passwordController.text.trim() !=
        repeatPasswordController.text.trim()) {
      return false;
    }
    return true;
  }

  bool _emptyTextController() {
    var result = emailController.text.isEmpty ||
        firstnameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        repeatPasswordController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        usernameController.text.isEmpty;
    if (result) {
      return false;
    }
    return true;
  }
}
