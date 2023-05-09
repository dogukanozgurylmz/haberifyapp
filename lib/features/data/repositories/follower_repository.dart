import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/follower_model.dart';

class FollowerRepository {
  final CollectionReference<Map<String, dynamic>> _ref =
      FirebaseFirestore.instance.collection('followers');

  Future<FollowerModel> getFollowersByUsername(String username) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _ref.where('username', isEqualTo: username).get();
      return FollowerModel.fromJson(querySnapshot.docs.first.data());
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> create(FollowerModel model) async {
    String id = _ref.doc().id;
    model.id = id;
    await _ref.doc(id).set(model.toJson());
  }

  Future<void> update(FollowerModel model) async {
    await _ref
        .doc(model.id)
        .update({'follower_usernames': model.followerUsernames});
  }
}
