import 'package:stacked/stacked.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/service/sign_service.dart';

class SignInViewModel extends BaseViewModel {
  bool isSignIn = false;
  bool isLoading = false;

  Future<void> signIn(String email, String password) async {
    isLoading = true;
    SignService signInService = SignService();
    await signInService.signIn(email, password);
    var currentUser = signInService.firebaseAuth.currentUser;
    if (currentUser != null) {
      await checkUser(currentUser.uid);
      isSignIn = true;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> checkUser(String uid) async {
    UserRepository userService = UserRepository();
    var userEntity = await userService.getByUsername(uid);
    UserModel userModel = UserModel(
      firstname: userEntity.firstname,
      lastname: userEntity.lastname,
      email: userEntity.email,
      username: userEntity.username,
      isSecure: userEntity.isSecure,
      createdAt: userEntity.createdAt,
      updatedAt: userEntity.updatedAt,
      id: userEntity.id,
    );
  }
}
