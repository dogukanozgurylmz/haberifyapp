import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haberifyapp/features/data/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getAll() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firestore.collection('users').get();
    List<UserModel> list =
        querySnapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
    return list;
  }

  Future<UserModel> getByUsername(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection('users').where('id', isEqualTo: uid).get();
      return UserModel.fromJson(documentSnapshot.docs[0].data());
    } on FirebaseException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> create(UserModel entity) async {
    var json = UserModel(
      firstname: entity.firstname,
      lastname: entity.lastname,
      email: entity.email,
      username: entity.username,
      isSecure: entity.isSecure,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      id: entity.id,
    ).toJson();
    var id = entity.id;
    await firestore.collection('users').doc(id).set(json);
  }
}
