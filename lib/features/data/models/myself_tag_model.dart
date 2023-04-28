class MySelfTagModel {
  final String tagId;
  final int count;

  MySelfTagModel({
    required this.tagId,
    required this.count,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tag_id': tagId,
      'count': count,
    };
  }

  factory MySelfTagModel.fromJson(Map<String, dynamic> json) {
    return MySelfTagModel(
      tagId: json['tag_id'] as String,
      count: json['count'] as int,
    );
  }
}
