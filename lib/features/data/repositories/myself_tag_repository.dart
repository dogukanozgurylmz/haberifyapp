import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habery/features/data/models/myself_tag_model.dart';

class MySelfTagRepository {
  final CollectionReference<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('users');

  Future<List<MySelfTagModel>> getAll(String userId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await ref.doc(userId).collection('myself_tag').get();
    List<MySelfTagModel> list = querySnapshot.docs.map((e) {
      var jsonMap = json.decode(json.encode(e.data()));
      return MySelfTagModel.fromJson(jsonMap);
    }).toList();
    return list;
  }
}
