class FollowerModel {
  String id;
  String username;
  List<String> followerUsernames;
  FollowerModel({
    required this.id,
    required this.username,
    required this.followerUsernames,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'follower_usernames': followerUsernames,
    };
  }

  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    return FollowerModel(
      id: json['id'] as String,
      username: json['username'] as String,
      followerUsernames:
          List<String>.from((json['follower_usernames'] as List<dynamic>)),
    );
  }
}
