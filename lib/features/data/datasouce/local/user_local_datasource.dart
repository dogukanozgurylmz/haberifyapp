import 'dart:convert';

import 'package:habery/features/data/models/user_model.dart';
import 'package:hive/hive.dart';

class UserLocalDatasource {
  static const _name = 'userBox';

  Future<void> add(UserModel userModel) async {
    final box = await Hive.openBox<Map>(_name);
    // userModel.toJson();
    // await box.add({
    //   'id': userModel.id,
    //   'email': userModel.email,
    //   'username': userModel.username,
    //   'firstname': userModel.firstname,
    //   'lastname': userModel.lastname,
    //   'isSecure': userModel.isSecure,
    //   'createdAt': userModel.createdAt,
    //   'updatedAt': userModel.updatedAt,
    // });
    await box.add(userModel.toJson());
  }

  Future<void> update(UserModel userModel) async {
    final box = await Hive.openBox<Map>(_name);
    await box.put(userModel.id, {
      'id': userModel.id,
      'email': userModel.email,
      'username': userModel.username,
      'firstname': userModel.firstname,
      'lastname': userModel.lastname,
      'isSecure': userModel.isSecure,
      'createdAt': userModel.createdAt,
      'updatedAt': userModel.updatedAt,
      'profile_photo_url': userModel.profilePhotoUrl,
    });
  }

  Future<void> delete(String key) async {
    final box = await Hive.openBox<Map>(_name);
    await box.delete(key);
  }

  Future<void> deleteAll() async {
    final box = await Hive.openBox<Map>(_name);
    await box.deleteFromDisk();
  }

  Future<UserModel> getUser() async {
    final box = await Hive.openBox<Map>(_name);
    var decode = json.decode(json.encode(box.values.first));
    var userModel = UserModel.fromJson(decode);
    return userModel;
  }
}
