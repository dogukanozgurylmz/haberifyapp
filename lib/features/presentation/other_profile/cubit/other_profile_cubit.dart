import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:haberifyapp/features/data/datasouce/local/user_local_datasource.dart';
import 'package:haberifyapp/features/data/models/user_model.dart';
import 'package:haberifyapp/features/data/repositories/follow_repository.dart';
import 'package:haberifyapp/features/data/repositories/follower_repository.dart';
import 'package:haberifyapp/features/data/repositories/news_repository.dart';
import 'package:haberifyapp/features/data/repositories/user_repository.dart';

import '../../../data/models/follow_model.dart';
import '../../../data/models/follower_model.dart';
import '../../../data/models/news_model.dart';

part 'other_profile_state.dart';

class OtherProfileCubit extends Cubit<OtherProfileState> {
  OtherProfileCubit({
    required UserRepository userRepository,
    required FollowRepository followRepository,
    required FollowerRepository followerRepository,
    required NewsRepository newsRepository,
    required UserLocalDatasource userLocalDatasource,
  })  : _userRepository = userRepository,
        _followRepository = followRepository,
        _followerRepository = followerRepository,
        _newsRepository = newsRepository,
        _userLocalDatasource = userLocalDatasource,
        super(OtherProfileState(
          status: OtherProfileStatus.INITIAL,
          userModel: UserModel(
            profilePhotoUrl: "",
            firstname: "",
            lastname: "",
            email: "",
            username: "",
            isSecure: false,
            createdAt: 0,
            updatedAt: 0,
            id: "",
          ),
          currentUser: UserModel(
            profilePhotoUrl: "",
            firstname: "",
            lastname: "",
            email: "",
            username: "",
            isSecure: false,
            createdAt: 0,
            updatedAt: 0,
            id: "",
          ),
          followModel: FollowModel(
            id: '',
            username: '',
            followUsernames: [],
          ),
          followerModel: FollowerModel(
            id: '',
            username: '',
            followerUsernames: [],
          ),
          newsList: const [],
          isFollow: false,
        )) {
    // init();
  }

  final UserRepository _userRepository;
  final FollowRepository _followRepository;
  final FollowerRepository _followerRepository;
  final NewsRepository _newsRepository;
  final UserLocalDatasource _userLocalDatasource;

  // Future<void> init() async {
  //   await getAllNews();
  //   await getFollowers();
  //   await getFollows();
  // }

  Future<void> getUserByUsername(String username) async {
    emit(state.copyWith(status: OtherProfileStatus.LOADING));
    UserModel userModel = await _userRepository.getByUsername(username);
    emit(state.copyWith(
        userModel: userModel, status: OtherProfileStatus.LOADED));
  }

  Future<void> getAllNews(String username) async {
    List<NewsModel> newsList =
        await _newsRepository.getNewsListByUsername(username);
    emit(state.copyWith(newsList: newsList));
  }

  Future<void> getFollows(String username) async {
    // var user = state.userModel;
    FollowModel followModel =
        await _followRepository.getFollowsByUsername(username);
    emit(state.copyWith(followModel: followModel));
  }

  Future<void> getFollowers(String username) async {
    // var user = state.userModel;
    FollowerModel followerModel =
        await _followerRepository.getFollowersByUsername(username);
    emit(state.copyWith(followerModel: followerModel));
  }

  Future<void> getCurrentUser() async {
    var userModel = await _userLocalDatasource.getUser();
    emit(state.copyWith(currentUser: userModel));
  }

  Future<void> follow() async {
    emit(state.copyWith(isFollow: true));
    FollowModel followModel = await _followRepository
        .getFollowsByUsername(state.currentUser.username);
    FollowerModel followerModel = state.followerModel;
    if (followerModel.followerUsernames.contains(state.currentUser.username)) {
      followerModel.followerUsernames.remove(state.currentUser.username);
    } else {
      var listFollower = [
        ...followerModel.followerUsernames,
        state.currentUser.username,
      ];
      followerModel.followerUsernames = listFollower;
    }
    if (followModel.followUsernames.contains(state.userModel.username)) {
      followModel.followUsernames.remove(state.userModel.username);
    } else {
      var listFollow = [
        ...followModel.followUsernames,
        state.userModel.username,
      ];
      followModel.followUsernames = listFollow;
    }

    await _followerRepository.update(followerModel);
    await _followRepository.update(followModel);
    emit(state.copyWith(
      followerModel: followerModel,
      isFollow: false,
    ));
  }
}
