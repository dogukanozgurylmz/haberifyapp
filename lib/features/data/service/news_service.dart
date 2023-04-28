import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haberifyapp/features/data/models/news_model.dart';

class NewsService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<NewsModel>> getAll() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('news')
        .orderBy('created_at', descending: true)
        .get();
    List<NewsModel> list = querySnapshot.docs.map((e) {
      var jsonMap = json.decode(json.encode(e.data()));
      return NewsModel.fromJson(jsonMap);
    }).toList();
    return list;
  }
}
