part of 'signin_cubit.dart';

enum SignInStatus {
  INITIAL,
  LOADING,
  LOADED,
}

class SigninState extends Equatable {
  final SignInStatus status;
  final bool isSignIn;
  final bool isSignInGoogle;

  const SigninState({
    required this.status,
    required this.isSignIn,
    required this.isSignInGoogle,
  });

  SigninState copyWith({
    SignInStatus? status,
    bool? isSignIn,
    bool? isSignInGoogle,
  }) {
    return SigninState(
      status: status ?? this.status,
      isSignIn: isSignIn ?? this.isSignIn,
      isSignInGoogle: isSignInGoogle ?? this.isSignInGoogle,
    );
  }

  @override
  List<Object> get props => [
        status,
        isSignIn,
        isSignInGoogle,
      ];
}
