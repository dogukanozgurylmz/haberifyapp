class NewsModel {
  String id;
  String username;
  List<String> newsPhotoIds;
  List<String> newsVideoIds;
  List<String> likes;
  int viewsCount;
  String content;
  String title;
  String cityId;
  int createdAt;
  bool isSecure;
  bool isAnonymous;

  NewsModel({
    required this.id,
    required this.username,
    required this.newsPhotoIds,
    required this.newsVideoIds,
    required this.likes,
    required this.viewsCount,
    required this.content,
    required this.title,
    required this.cityId,
    required this.createdAt,
    required this.isSecure,
    required this.isAnonymous,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['is_anonymous'] = isAnonymous;
    data['news_photo_ids'] = newsPhotoIds;
    data['likes'] = likes;
    data['is_secure'] = isSecure;
    data['created_at'] = createdAt;
    data['views_count'] = viewsCount;
    data['title'] = title;
    data['content'] = content;
    data['city_id'] = cityId;
    data['news_video_ids'] = newsVideoIds;
    return data;
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as String,
      username: json['username'] as String,
      newsPhotoIds:
          List<String>.from((json['news_photo_ids'] as List<dynamic>)),
      newsVideoIds:
          List<String>.from((json['news_video_ids'] as List<dynamic>)),
      likes: List<String>.from((json['likes'] as List<dynamic>)),
      viewsCount: json['views_count'] as int,
      content: json['content'] as String,
      title: json['title'] as String,
      cityId: json['city_id'] as String,
      createdAt: json['created_at'] as int,
      isSecure: json['is_secure'] as bool,
      isAnonymous: json['is_anonymous'] as bool,
    );
  }
}
