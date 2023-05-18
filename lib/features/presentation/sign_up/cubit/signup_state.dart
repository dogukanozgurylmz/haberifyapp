// ignore_for_file: constant_identifier_names

part of 'signup_cubit.dart';

enum SignUpStatus {
  INITIAL,
  LOADING,
  LOADED,
}

class SignupState extends Equatable {
  final SignUpStatus status;
  final File image;
  final bool isSignUp;
  final bool isLoading;
  final bool isLoadImage;
  final String errorMessage;

  const SignupState({
    required this.status,
    required this.image,
    required this.isSignUp,
    required this.isLoading,
    required this.isLoadImage,
    required this.errorMessage,
  });

  SignupState copyWith({
    SignUpStatus? status,
    File? image,
    bool? isSignUp,
    bool? isLoading,
    bool? isLoadImage,
    String? errorMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      image: image ?? this.image,
      isSignUp: isSignUp ?? this.isSignUp,
      isLoading: isLoading ?? this.isLoading,
      isLoadImage: isLoadImage ?? this.isLoadImage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        image,
        isSignUp,
        isLoading,
        isLoadImage,
        errorMessage,
      ];
}
