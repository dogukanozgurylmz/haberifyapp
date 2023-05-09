import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:haberifyapp/features/data/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Reference _refStorage = FirebaseStorage.instance.ref();
  String _downloadURL = "";

  Future<List<UserModel>> getAll() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firestore.collection('users').get();
    List<UserModel> list =
        querySnapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
    return list;
  }

  Future<UserModel> getByUID(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection('users').where('id', isEqualTo: uid).get();
      return UserModel.fromJson(documentSnapshot.docs[0].data());
    } on FirebaseException catch (e) {
      throw e.message.toString();
    }
  }

  Future<UserModel> getByUsername(String username) async {
    try {
      QuerySnapshot<Map<String, dynamic>> documentSnapshot = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return UserModel.fromJson(documentSnapshot.docs[0].data());
    } on FirebaseException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> create(UserModel model) async {
    var json = UserModel(
      profilePhotoUrl: model.profilePhotoUrl,
      firstname: model.firstname,
      lastname: model.lastname,
      email: model.email,
      username: model.username,
      isSecure: model.isSecure,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      id: model.id,
    ).toJson();
    var id = model.id;
    await firestore.collection('users').doc(id).set(json);
  }

  Future<void> uploadImage({
    required File image,
  }) async {
    String generateRandomString = _generateRandomString(20);
    Reference ref =
        _refStorage.child('users/profile/$generateRandomString.jpeg');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    _downloadURL = downloadURL;
  }

  String getDownloadImage() {
    return _downloadURL;
  }

  String _generateRandomString(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}
