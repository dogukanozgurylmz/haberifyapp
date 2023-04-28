import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haberifyapp/features/data/models/tag_model.dart';

class TagRepository {
  final CollectionReference<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('tags');
  QuerySnapshot<Map<String, dynamic>>? subQuery;

  Future<List<TagModel>> getAllPagination(int startIndex, int limit) async {
    if (startIndex == 0) {
      subQuery =
          await ref.orderBy('count', descending: true).limit(limit).get();
    } else {
      Query<Map<String, dynamic>> query =
          ref.orderBy('count', descending: true).limit(limit);
      if (startIndex != 0 && subQuery!.docs.isNotEmpty) {
        final lastVisible = subQuery!.docs[subQuery!.size - 1];
        query = query.startAfterDocument(lastVisible);
      }
      subQuery = await query.get();
    }

    List<TagModel> list = subQuery!.docs.map((e) {
      var jsonMap = json.decode(json.encode(e.data()));
      return TagModel.fromJson(jsonMap);
    }).toList();
    return list;
  }

  Future<TagModel> getTagByTagName(String tag) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await ref.where('tag', isEqualTo: tag).get();
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data = querySnapshot.docs.first.data();
      var jsonMap = json.decode(json.encode(data));
      return TagModel.fromJson(jsonMap);
    }
    return TagModel(id: '', newsIds: [], tag: '', count: 0);
  }

  Future<void> update(TagModel model) async {
    await ref.doc(model.id).update({
      'news_ids': model.newsIds,
      'count': model.count,
    });
  }

  Future<void> create(TagModel model) async {
    String docId = ref.doc().id;
    Map<String, dynamic> json = model.toJson();
    json['id'] = docId;
    await ref.doc(docId).set(json);
  }
}
