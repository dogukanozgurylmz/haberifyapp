import 'package:haberifyapp/features/data/service/sign_service.dart';
import 'package:stacked/stacked.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class SignUpViewModel extends BaseViewModel {
  bool isSignUp = false;
  bool isLoading = false;

  Future<void> signUp({
    required String firstname,
    required String lastname,
    required String username,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    SignService signInService = SignService();
    await signInService.firebaseAuth.signOut();
    await signInService.signUp(email, password);
    var currentUser = signInService.firebaseAuth.currentUser;
    if (currentUser != null) {
      DateTime dateTime = DateTime.now();
      UserModel userModel = UserModel(
        firstname: firstname.trim(),
        lastname: lastname.trim(),
        email: email.trim(),
        username: username.trim(),
        isSecure: false,
        createdAt: dateTime.millisecondsSinceEpoch,
        updatedAt: dateTime.millisecondsSinceEpoch,
        id: currentUser.uid,
      );
      await createUser(userModel);
      isSignUp = true;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> createUser(UserModel userModel) async {
    UserRepository userService = UserRepository();
    UserModel model = UserModel(
      firstname: userModel.firstname,
      lastname: userModel.lastname,
      email: userModel.email,
      username: userModel.username,
      isSecure: userModel.isSecure,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
      id: userModel.id,
    );
    await userService.create(model);
  }
}
