class TagModel {
  final String id;
  final List<String> newsIds;
  final String tag;
  final int count;

  TagModel({
    required this.id,
    required this.newsIds,
    required this.tag,
    required this.count,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'news_ids': newsIds,
      'tag': tag,
      'count': count,
    };
  }

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] as String,
      newsIds: List<String>.from((json['news_ids'] as List<dynamic>)),
      tag: json['tag'] as String,
      count: json['count'] as int,
    );
  }
}
