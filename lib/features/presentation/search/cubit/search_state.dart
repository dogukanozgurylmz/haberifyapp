// ignore_for_file: constant_identifier_names

part of 'search_cubit.dart';

enum SearchStatus {
  INITIAL,
  LOADED,
  LOADING,
}

class SearchState extends Equatable {
  final SearchStatus status;
  final List<TagModel> tags;
  final List<NewsModel> newsList;
  final List<UserModel> users;

  const SearchState({
    required this.status,
    required this.tags,
    required this.newsList,
    required this.users,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<TagModel>? tags,
    List<NewsModel>? newsList,
    List<UserModel>? users,
  }) {
    return SearchState(
      status: status ?? this.status,
      tags: tags ?? this.tags,
      newsList: newsList ?? this.newsList,
      users: users ?? this.users,
    );
  }

  @override
  List<Object> get props => [
        status,
        tags,
        newsList,
        users,
      ];
}
