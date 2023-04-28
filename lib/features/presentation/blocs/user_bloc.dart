import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:haberifyapp/features/data/models/user_model.dart';
import 'package:haberifyapp/features/data/repositories/user_repository.dart';

part '../events/user_event.dart';
part '../states/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(UserInitial()) {
    on<GetUserByUsername>(_getUserByUsername);
  }
  final UserRepository _userRepository;

  Future<void> _getUserByUsername(
      GetUserByUsername event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      UserModel userModel = await _userRepository.getByUsername(event.username);
      if (userModel.username.isEmpty) {
        emit(UserError(message: "Kullanıcı bulunamadı"));
      } else {
        emit(UserLoaded(userModel: userModel));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
