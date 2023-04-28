part of '../blocs/user_bloc.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel userModel;
  UserLoaded({required this.userModel});
  @override
  List<Object?> get props => [userModel];
}

class UserError extends UserState {
  final String message;
  UserError({required this.message});
  @override
  List<Object?> get props => [message];
}
