// ignore_for_file: constant_identifier_names

part of 'other_profile_cubit.dart';

enum OtherProfileStatus {
  INITIAL,
  LOADING,
  LOADED,
}

class OtherProfileState extends Equatable {
  final OtherProfileStatus status;
  final UserModel userModel;
  final UserModel currentUser;
  final FollowModel followModel;
  final FollowerModel followerModel;
  final List<NewsModel> newsList;
  final bool isFollow;

  const OtherProfileState({
    required this.status,
    required this.userModel,
    required this.currentUser,
    required this.followModel,
    required this.followerModel,
    required this.newsList,
    required this.isFollow,
  });

  OtherProfileState copyWith({
    OtherProfileStatus? status,
    UserModel? userModel,
    UserModel? currentUser,
    FollowModel? followModel,
    FollowerModel? followerModel,
    List<NewsModel>? newsList,
    bool? isFollow,
  }) {
    return OtherProfileState(
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      currentUser: currentUser ?? this.currentUser,
      followModel: followModel ?? this.followModel,
      followerModel: followerModel ?? this.followerModel,
      newsList: newsList ?? this.newsList,
      isFollow: isFollow ?? this.isFollow,
    );
  }

  @override
  List<Object> get props => [
        status,
        userModel,
        currentUser,
        followModel,
        followerModel,
        newsList,
        isFollow,
      ];
}
