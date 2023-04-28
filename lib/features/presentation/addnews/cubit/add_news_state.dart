// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

part of 'add_news_cubit.dart';

enum AddNewsStatus {
  LOADING,
  SENDLOADING,
  LOADED,
  SENDLOADED,
  INITIAL,
  ERROR,
}

class AddNewsState extends Equatable {
  final AddNewsStatus status;
  final CityModel cityModel;
  final List<CityModel> cities;
  final String selectCity;
  final List<String> tagsName;
  final List<File> images;
  final String newsId;

  const AddNewsState({
    required this.status,
    required this.cityModel,
    required this.cities,
    required this.selectCity,
    required this.tagsName,
    required this.images,
    required this.newsId,
  });

  AddNewsState copyWith({
    AddNewsStatus? status,
    CityModel? cityModel,
    List<CityModel>? cities,
    String? selectCity,
    List<String>? tagsName,
    List<File>? images,
    String? newsId,
  }) {
    return AddNewsState(
      cities: cities ?? this.cities,
      cityModel: cityModel ?? this.cityModel,
      status: status ?? this.status,
      selectCity: selectCity ?? this.selectCity,
      tagsName: tagsName ?? this.tagsName,
      images: images ?? this.images,
      newsId: newsId ?? this.newsId,
    );
  }

  @override
  List<Object> get props => [
        status,
        cityModel,
        cities,
        selectCity,
        tagsName,
        images,
        newsId,
      ];
}

// class AddNewsInitial extends AddNewsState {}
