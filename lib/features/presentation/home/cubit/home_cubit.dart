import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:haberifyapp/features/data/models/city_model.dart';
import 'package:haberifyapp/features/data/repositories/city_repository.dart';
import 'package:haberifyapp/features/data/repositories/news_repository.dart';
import 'package:haberifyapp/features/data/repositories/user_repository.dart';
import 'package:intl/intl.dart';

import '../../../data/models/news_model.dart';
import '../../../data/models/user_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required NewsRepository newsRepository,
    required CityRepository cityRepository,
    required UserRepository userRepository,
  })  : _newsRepository = newsRepository,
        _cityRepository = cityRepository,
        _userRepository = userRepository,
        super(HomeState(
          status: HomeStatus.INITIAL,
          newsList: const [],
          userModel: UserModel(
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
          cities: [],
          usernames: [],
        )) {
    init();
  }

  final NewsRepository _newsRepository;
  final CityRepository _cityRepository;
  final UserRepository _userRepository;

  Future<void> init() async {
    emit(state.copyWith(status: HomeStatus.LOADING));
    await newsGetAll();
    emit(state.copyWith(status: HomeStatus.LOADED));
  }

  Future<void> newsGetAll() async {
    try {
      final newsList = await _newsRepository.getAll();
      if (newsList.isEmpty) {
        // emit(const NewsError("Haber bulunamadı"));
      } else {
        emit(state.copyWith(newsList: newsList));
      }
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

  String timeConvert(NewsModel model) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(
      model.createdAt,
      isUtc: true,
    );
    String dateFormat = DateFormat('dd MMMM yyyy HH:mm', 'tr_TR').format(time);
    return dateFormat;
  }
}
