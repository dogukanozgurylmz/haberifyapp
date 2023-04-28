import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/news_model.dart';

class NewsRepository {
  final CollectionReference<Map<String, dynamic>> _ref =
      FirebaseFirestore.instance.collection('news');
  final Reference _refStorage = FirebaseStorage.instance.ref();
  final List<String> _downloadURLs = [];

  Future<List<NewsModel>> getAll() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _ref.orderBy('created_at', descending: true).get();
    List<NewsModel> list = querySnapshot.docs.map((e) {
      var jsonMap = json.decode(json.encode(e.data()));
      return NewsModel.fromJson(jsonMap);
    }).toList();
    return list;
  }

  Future<NewsModel> getNewsById(String id) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _ref
        .where('id', isEqualTo: id)
        // .orderBy('created_at', descending: true)
        .get();
    Map<String, dynamic> data = querySnapshot.docs.last.data();
    return NewsModel.fromJson(data);
  }

  Future<NewsModel> getNewsByUsername(String username) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _ref.where('username', isEqualTo: username).get();
    Map<String, dynamic> data = querySnapshot.docs.last.data();
    return NewsModel.fromJson(data);
  }

  Future<void> createNews(NewsModel model) async {
    String docId = _ref.doc().id;
    model.id = docId;
    await _ref.doc(docId).set(model.toJson());
  }

  Future<void> uploadImage({
    required List<File> images,
  }) async {
    for (var image in images) {
      String generateRandomString = _generateRandomString(20);
      Reference ref =
          _refStorage.child('news/images/$generateRandomString.jpeg');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      _downloadURLs.add(downloadURL);
    }
  }

  List<String> getDownloadImages() {
    return _downloadURLs;
  }

  String _generateRandomString(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}
