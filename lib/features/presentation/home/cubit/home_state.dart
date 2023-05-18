// ignore_for_file: constant_identifier_names

part of 'home_cubit.dart';

enum HomeStatus {
  INITIAL,
  CITY_LOADING,
  CITY_LOADED,
  LOADING,
  LOADED,
}

class HomeState extends Equatable {
  final HomeStatus status;
  final List<NewsModel> newsList;
  final UserModel userModel;
  final CityModel city;
  final List<CityModel> cities;
  final List<String> likes;
  final bool isLike;
  // final List<String> followUsernames;
  // final FollowModel followModel;

  const HomeState({
    required this.status,
    required this.newsList,
    required this.userModel,
    required this.city,
    required this.cities,
    required this.likes,
    required this.isLike,
    // required this.followUsernames,
    // required this.followModel,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<NewsModel>? newsList,
    UserModel? userModel,
    CityModel? city,
    List<CityModel>? cities,
    List<String>? likes,
    bool? isLike,
    // List<String>? followUsernames,
    // FollowModel? followModel,
  }) {
    return HomeState(
      status: status ?? this.status,
      newsList: newsList ?? this.newsList,
      userModel: userModel ?? this.userModel,
      city: city ?? this.city,
      cities: cities ?? this.cities,
      likes: likes ?? this.likes,
      isLike: isLike ?? this.isLike,
      // followUsernames: followUsernames ?? this.followUsernames,
      // followModel: followModel ?? this.followModel,
    );
  }

  @override
  List<Object> get props => [
        status,
        newsList,
        userModel,
        city,
        cities,
        likes,
        isLike,
        // followUsernames,
        // followModel,
      ];
}
