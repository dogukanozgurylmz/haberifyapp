// ignore_for_file: constant_identifier_names

part of 'profile_cubit.dart';

enum ProfileStatus {
  INITIAL,
  LOADING,
  LOADED,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserModel userModel;
  final List<NewsModel> newsList;
  final CityModel cityModel;
  final bool isOut;
  final List<String> followUsernames;
  final List<String> followerUsernames;

  const ProfileState({
    required this.status,
    required this.userModel,
    required this.newsList,
    required this.cityModel,
    required this.isOut,
    required this.followUsernames,
    required this.followerUsernames,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? userModel,
    List<NewsModel>? newsList,
    CityModel? cityModel,
    bool? isOut,
    List<String>? followUsernames,
    List<String>? followerUsernames,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      newsList: newsList ?? this.newsList,
      cityModel: cityModel ?? this.cityModel,
      isOut: isOut ?? this.isOut,
      followUsernames: followUsernames ?? this.followUsernames,
      followerUsernames: followerUsernames ?? this.followerUsernames,
    );
  }

  @override
  List<Object> get props => [
        status,
        userModel,
        newsList,
        cityModel,
        isOut,
        followUsernames,
        followerUsernames,
      ];
}
