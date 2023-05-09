class UserModel {
  final String profilePhotoUrl;
  final String firstname;
  final String lastname;
  final String email;
  final String username;
  final bool isSecure;
  final int createdAt;
  final int updatedAt;
  final String id;

  UserModel({
    required this.profilePhotoUrl,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.username,
    required this.isSecure,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'profile_photo_url': profilePhotoUrl,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'username': username,
      'is_secure': isSecure,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'id': id,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      profilePhotoUrl: map['profile_photo_url'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      isSecure: map['is_secure'] as bool,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
      id: map['id'] as String,
    );
  }
}
