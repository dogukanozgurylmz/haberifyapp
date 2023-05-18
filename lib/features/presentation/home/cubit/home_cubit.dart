import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habery/features/data/datasouce/local/news_local_datasource.dart';
import 'package:habery/features/data/datasouce/local/user_local_datasource.dart';
import 'package:habery/features/data/models/city_model.dart';
import 'package:habery/features/data/models/follow_model.dart';
import 'package:habery/features/data/repositories/city_repository.dart';
import 'package:habery/features/data/repositories/follow_repository.dart';
import 'package:habery/features/data/repositories/news_repository.dart';
import 'package:habery/features/data/repositories/user_repository.dart';
import 'package:intl/intl.dart';

import '../../../data/models/news_model.dart';
import '../../../data/models/user_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required NewsRepository newsRepository,
    required CityRepository cityRepository,
    required UserRepository userRepository,
    required FollowRepository followRepository,
    required NewsLocalDatasource newsLocalDatasource,
  })  : _newsRepository = newsRepository,
        _cityRepository = cityRepository,
        _userRepository = userRepository,
        _followRepository = followRepository,
        _newsLocalDatasource = newsLocalDatasource,
        super(HomeState(
          status: HomeStatus.INITIAL,
          newsList: const [],
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
          city: CityModel(
            id: '',
            countryId: '',
            city: '',
          ),
          cities: const [],
          likes: const [], isLike: false,
          // followUsernames: [],
          // followModel: FollowModel(
          //   id: '',
          //   username: '',
          //   followUsernames: [],
          // ),
        )) {
    init();
  }

  final NewsRepository _newsRepository;
  final CityRepository _cityRepository;
  final UserRepository _userRepository;
  final FollowRepository _followRepository;
  final NewsLocalDatasource _newsLocalDatasource;

  final List<String> _followUsernames = [];
  String username = "";

  Future<void> init() async {
    emit(state.copyWith(status: HomeStatus.LOADING));
    await getFollows();
    await newsGetAll();
    await getUser();
    emit(state.copyWith(status: HomeStatus.LOADED));
  }

  // Future<void> localNewsList() async {
  //   emit(state.copyWith(status: HomeStatus.LOADING));
  //   var list = await _newsLocalDatasource.getNews();
  //   list.sort(
  //     (a, b) => b.createdAt.compareTo(a.createdAt),
  //   );
  //   emit(state.copyWith(newsList: list, status: HomeStatus.LOADED));
  // }

  Future<void> newsGetAll() async {
    try {
      await _newsLocalDatasource.deleteAll();
      List<NewsModel> newsList = [];
      for (var username in _followUsernames) {
        List<NewsModel> list =
            await _newsRepository.getNewsListByUsername(username);
        newsList.addAll(list);
      }
      for (var news in newsList) {
        await _newsLocalDatasource.add(news);
      }
      newsList.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
      emit(state.copyWith(newsList: newsList));
    } catch (e) {
      // emit(NewsError(e.toString()));
    }
  }

  Future<void> getCityById(String id) async {
    try {
      final city = await _cityRepository.getCityById(id);
      if (city.id.isEmpty) {
        // emit(CityError(message: "Hata oluştu"));
      } else {
        emit(state.copyWith(city: city));
      }
    } catch (e) {
      // emit(CityError(message: "Şehir hatası"));
    }
  }

  Future<void> getUserByUsername(String username) async {
    try {
      UserModel userModel = await _userRepository.getByUsername(username);
      if (userModel.username.isEmpty) {
        // emit(UserError(message: "Kullanıcı bulunamadı"));
      } else {
        emit(state.copyWith(userModel: userModel));
      }
    } catch (e) {
      // emit(UserError(message: e.toString()));
    }
  }

  Future<void> getUser() async {
    final UserLocalDatasource userLocalDatasource = UserLocalDatasource();
    var userModel = await userLocalDatasource.getUser();
    username = userModel.username;
  }

  Future<void> getFollows() async {
    UserLocalDatasource userLocalDatasource = UserLocalDatasource();
    var user = await userLocalDatasource.getUser();
    FollowModel followModel =
        await _followRepository.getFollowsByUsername(user.username);
    _followUsernames.addAll(followModel.followUsernames);
  }

  Future<void> like(NewsModel newsModel) async {
    emit(state.copyWith(isLike: true));
    final UserLocalDatasource userLocalDatasource = UserLocalDatasource();
    var userModel = await userLocalDatasource.getUser();

    if (newsModel.likes.contains(userModel.username)) {
      newsModel.likes.remove(userModel.username);
    } else {
      newsModel.likes.add(userModel.username);
    }

    await _newsRepository.like(newsModel.id, newsModel.likes);
    final updatedNewsList = state.newsList.map((e) {
      if (e.id == newsModel.id) {
        return newsModel;
      } else {
        return e;
      }
    }).toList();
    emit(state.copyWith(newsList: updatedNewsList, isLike: false));
  }

  String timeConvert(NewsModel model) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(
      model.createdAt,
      isUtc: true,
    );
    String dateFormat = DateFormat('dd MMMM yyyy HH:mm', 'tr_TR').format(time);
    return dateFormat;
  }
}
