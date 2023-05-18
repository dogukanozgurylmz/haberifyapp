import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habery/features/data/models/follow_model.dart';

class FollowRepository {
  final CollectionReference<Map<String, dynamic>> _ref =
      FirebaseFirestore.instance.collection('follows');

  Future<FollowModel> getFollowsByUsername(String username) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _ref.where('username', isEqualTo: username).get();
      return FollowModel.fromJson(querySnapshot.docs.first.data());
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> create(FollowModel model) async {
    String id = _ref.doc().id;
    model.id = id;
    await _ref.doc(id).set(model.toJson());
  }

  Future<void> update(FollowModel model) async {
    await _ref
        .doc(model.id)
        .update({'follow_usernames': model.followUsernames});
  }
}
