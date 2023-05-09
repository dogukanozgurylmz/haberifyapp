import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:haberifyapp/features/data/models/tag_model.dart';
import 'package:haberifyapp/features/data/repositories/tag_repository.dart';
import 'package:intl/intl.dart';

import '../../../data/datasouce/local/news_local_datasource.dart';
import '../../../data/datasouce/local/user_local_datasource.dart';
import '../../../data/models/city_model.dart';
import '../../../data/models/follow_model.dart';
import '../../../data/models/news_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/city_repository.dart';
import '../../../data/repositories/follow_repository.dart';
import '../../../data/repositories/news_repository.dart';
import '../../../data/repositories/user_repository.dart';

part 'news_list_state.dart';

class NewsListCubit extends Cubit<NewsListState> {
  NewsListCubit({
    required NewsRepository newsRepository,
    required CityRepository cityRepository,
    required UserRepository userRepository,
    required FollowRepository followRepository,
    required AuthRepository authRepository,
    required TagRepository tagRepository,
  })  : _newsRepository = newsRepository,
        _cityRepository = cityRepository,
        _userRepository = userRepository,
        _followRepository = followRepository,
        _authRepository = authRepository,
        _tagRepository = tagRepository,
        super(NewsListState(
          status: NewsListStatus.INITIAL,
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
          likes: const [],
          isLike: false,
          isTagLoaded: false,
        )) {
    // init();
  }
  final NewsRepository _newsRepository;
  final CityRepository _cityRepository;
  final UserRepository _userRepository;
  final FollowRepository _followRepository;
  final AuthRepository _authRepository;
  final TagRepository _tagRepository;

  final List<String> _followUsernames = [];
  String username = "";

  TagModel _tagModel = TagModel(
    id: 'id',
    newsIds: [],
    tag: 'tag',
    count: 0,
  );

  Future<void> init() async {
    emit(state.copyWith(status: NewsListStatus.LOADING));
    await newsGetAll();
    await getUser();
    emit(state.copyWith(status: NewsListStatus.LOADED));
  }

  Future<void> getTag(String tagName) async {
    emit(state.copyWith(status: NewsListStatus.LOADING));

    emit(state.copyWith(isTagLoaded: false));
    _tagModel = await _tagRepository.getTagByTagName(tagName);
    await newsGetAll();
    emit(state.copyWith(status: NewsListStatus.LOADED));

    emit(state.copyWith(isTagLoaded: true));
  }

  Future<void> newsGetAll() async {
    try {
      var list = await _newsRepository.getNewsListById(_tagModel.newsIds);
      list.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
      emit(state.copyWith(newsList: list));
    } catch (e) {
      print(e.toString());
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
