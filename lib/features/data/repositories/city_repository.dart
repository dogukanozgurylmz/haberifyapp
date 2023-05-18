import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habery/features/data/models/city_model.dart';

class CityRepository {
  final CollectionReference<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('cities');

  Future<List<CityModel>> getAll() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await ref.get();
    List<CityModel> list = querySnapshot.docs.map((e) {
      var jsonMap = json.decode(json.encode(e.data()));
      return CityModel.fromJson(jsonMap);
    }).toList();
    return list;
  }

  Future<CityModel> getCityById(String id) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await ref.where('id', isEqualTo: id).get();
    var data = querySnapshot.docs[0].data();
    var decode = json.decode(json.encode(data));
    return CityModel.fromJson(decode);
  }
}
