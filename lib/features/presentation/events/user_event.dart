part of '../blocs/user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserByUsername extends UserEvent {
  final String username;
  GetUserByUsername(this.username);
  @override
  List<Object?> get props => [username];
}
