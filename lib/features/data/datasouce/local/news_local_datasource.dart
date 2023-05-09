import 'dart:convert';

import 'package:haberifyapp/features/data/models/news_model.dart';
import 'package:haberifyapp/features/data/models/user_model.dart';
import 'package:hive/hive.dart';

class NewsLocalDatasource {
  static const _name = 'newsBox';

  Future<void> add(NewsModel newsModel) async {
    final box = await Hive.openBox<Map>(_name);
    await box.add(newsModel.toJson());
  }

  // Future<void> delete(String key) async {
  //   final box = await Hive.openBox<Map>(_name);
  //   await box.delete(key);
  // }

  Future<void> deleteAll() async {
    final box = await Hive.openBox<Map>(_name);
    await box.deleteFromDisk();
  }

  Future<List<NewsModel>> getNews() async {
    final box = await Hive.openBox<Map>(_name);
    var list = box.values.map((e) {
      var decode = json.decode(json.encode(e));
      return NewsModel.fromJson(decode);
    }).toList();
    return list;
  }
}
