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
  final List<String> usernames;

  const HomeState({
    required this.status,
    required this.newsList,
    required this.userModel,
    required this.city,
    required this.cities,
    required this.usernames,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<NewsModel>? newsList,
    UserModel? userModel,
    CityModel? city,
    List<CityModel>? cities,
    List<String>? usernames,
  }) {
    return HomeState(
      status: status ?? this.status,
      newsList: newsList ?? this.newsList,
      userModel: userModel ?? this.userModel,
      city: city ?? this.city,
      cities: cities ?? this.cities,
      usernames: usernames ?? this.usernames,
    );
  }

  @override
  List<Object> get props => [
        status,
        newsList,
        userModel,
        city,
        cities,
        usernames,
      ];
}
