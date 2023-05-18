// ignore_for_file: constant_identifier_names

part of 'news_list_cubit.dart';

enum NewsListStatus {
  INITIAL,
  CITY_LOADING,
  CITY_LOADED,
  LOADING,
  LOADED,
}

class NewsListState extends Equatable {
  final NewsListStatus status;
  final List<NewsModel> newsList;
  final UserModel userModel;
  final CityModel city;
  final List<CityModel> cities;
  final List<String> likes;
  final bool isLike;
  final bool isTagLoaded;
  // final List<String> followUsernames;
  // final FollowModel followModel;

  const NewsListState({
    required this.status,
    required this.newsList,
    required this.userModel,
    required this.city,
    required this.cities,
    required this.likes,
    required this.isLike,
    required this.isTagLoaded,
    // required this.followUsernames,
    // required this.followModel,
  });

  NewsListState copyWith({
    NewsListStatus? status,
    List<NewsModel>? newsList,
    UserModel? userModel,
    CityModel? city,
    List<CityModel>? cities,
    List<String>? likes,
    bool? isLike,
    bool? isTagLoaded,
    // List<String>? followUsernames,
    // FollowModel? followModel,
  }) {
    return NewsListState(
      status: status ?? this.status,
      newsList: newsList ?? this.newsList,
      userModel: userModel ?? this.userModel,
      city: city ?? this.city,
      cities: cities ?? this.cities,
      likes: likes ?? this.likes,
      isLike: isLike ?? this.isLike,
      isTagLoaded: isTagLoaded ?? this.isTagLoaded,
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
        isTagLoaded,
        // followUsernames,
        // followModel,
      ];
}
