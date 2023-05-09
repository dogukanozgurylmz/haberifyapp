class FollowModel {
  String id;
  String username;
  List<String> followUsernames;
  FollowModel({
    required this.id,
    required this.username,
    required this.followUsernames,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'follow_usernames': followUsernames,
    };
  }

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      id: json['id'] as String,
      username: json['username'] as String,
      followUsernames:
          List<String>.from((json['follow_usernames'] as List<dynamic>)),
    );
  }
}
