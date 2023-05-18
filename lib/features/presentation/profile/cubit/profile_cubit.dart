import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habery/features/data/datasouce/local/user_local_datasource.dart';
import 'package:habery/features/data/models/news_model.dart';
import 'package:habery/features/data/models/user_model.dart';
import 'package:habery/features/data/repositories/auth_repository.dart';
import 'package:habery/features/data/repositories/follow_repository.dart';
import 'package:habery/features/data/repositories/follower_repository.dart';
import 'package:habery/features/data/repositories/news_repository.dart';

import '../../../data/models/city_model.dart';
import '../../../data/models/follow_model.dart';
import '../../../data/models/follower_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required NewsRepository newsRepository,
    required UserLocalDatasource userLocalDatasource,
    required AuthRepository authRepository,
    required FollowRepository followRepository,
    required FollowerRepository followerRepository,
  })  : _newsRepository = newsRepository,
        _userLocalDatasource = userLocalDatasource,
        _authRepository = authRepository,
        _followRepository = followRepository,
        _followerRepository = followerRepository,
        super(ProfileState(
          status: ProfileStatus.INITIAL,
          userModel: UserModel(
            profilePhotoUrl: '',
            firstname: '',
            lastname: '',
            email: '',
            username: '',
            isSecure: false,
            createdAt: 0,
            updatedAt: 0,
            id: '',
          ),
          newsList: const [],
          cityModel: CityModel(
            id: '',
            countryId: '',
            city: '',
          ),
          isOut: false,
          followUsernames: const [],
          followerUsernames: const [],
        )) {
    init();
  }

  final NewsRepository _newsRepository;
  final UserLocalDatasource _userLocalDatasource;
  final AuthRepository _authRepository;
  final FollowRepository _followRepository;
  final FollowerRepository _followerRepository;

  Future<void> init() async {
    emit(state.copyWith(status: ProfileStatus.LOADING));
    await getUser();
    await getAllNews();
    await getFollows();
    await getFollowers();
    emit(state.copyWith(status: ProfileStatus.LOADED));
  }

  Future<void> getAllNews() async {
    List<NewsModel> newsList =
        await _newsRepository.getNewsListByUsername(state.userModel.username);
    List<NewsModel> list = newsList.reversed.toList();
    emit(state.copyWith(newsList: list));
  }

  Future<void> getUser() async {
    UserModel userModel = await _userLocalDatasource.getUser();
    emit(state.copyWith(userModel: userModel));
  }

  // Future<void> getCityById() async {
  //   var user = await _userLocalDatasource.getUser();
  //   await _cityRepository.getCityById(user);
  // }

  Future<void> signOut() async {
    emit(state.copyWith(isOut: false));
    await _userLocalDatasource.deleteAll();
    await _authRepository.signOut();
    emit(state.copyWith(isOut: true));
  }

  Future<void> getFollows() async {
    List<String> list = [];
    var user = await _userLocalDatasource.getUser();
    FollowModel followModel =
        await _followRepository.getFollowsByUsername(user.username);
    list.addAll(followModel.followUsernames);
    emit(state.copyWith(followUsernames: list));
  }

  Future<void> getFollowers() async {
    List<String> list = [];
    var user = await _userLocalDatasource.getUser();
    FollowerModel followerModel =
        await _followerRepository.getFollowersByUsername(user.username);
    list.addAll(followerModel.followerUsernames);
    emit(state.copyWith(followerUsernames: list));
  }
}
