import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habery/features/data/models/news_model.dart';
import 'package:habery/features/data/models/tag_model.dart';
import 'package:habery/features/data/models/user_model.dart';

import '../../../data/repositories/news_repository.dart';
import '../../../data/repositories/tag_repository.dart';
import '../../../data/repositories/user_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required NewsRepository newsRepository,
    required UserRepository userRepository,
    required TagRepository tagRepository,
  })  : _newsRepository = newsRepository,
        _userRepository = userRepository,
        _tagRepository = tagRepository,
        super(const SearchState(
          status: SearchStatus.INITIAL,
          tags: [],
          newsList: [],
          users: [],
        )) {
    getAllNews();
  }

  final NewsRepository _newsRepository;
  final UserRepository _userRepository;
  final TagRepository _tagRepository;

  final TextEditingController searchTextController = TextEditingController();
  final List<NewsModel> newsList = [];

  Future<void> getAllNews() async {
    newsList.clear();
    emit(state.copyWith(status: SearchStatus.LOADING));
    List<NewsModel> list = await _newsRepository.getAll();
    newsList.addAll(list);
    emit(state.copyWith(status: SearchStatus.LOADED));
  }

  void searchNews() {
    List<NewsModel> list = [];
    emit(state.copyWith(status: SearchStatus.LOADING, newsList: []));
    if (searchTextController.text.isNotEmpty ||
        searchTextController.text != "") {
      for (var element in newsList) {
        var contains = element.content
            .toLowerCase()
            .contains(searchTextController.text.toLowerCase());
        if (contains) {
          list.add(element);
        }
      }
    }
    emit(state.copyWith(status: SearchStatus.LOADED, newsList: list));
  }

  Future<void> searchTag(String query) async {
    emit(state.copyWith(status: SearchStatus.LOADING, tags: []));
    List<TagModel> list = await _tagRepository.search(query);
    emit(state.copyWith(status: SearchStatus.LOADED, tags: list));
  }

  Future<void> searchUser(String query) async {
    emit(state.copyWith(status: SearchStatus.LOADING, users: []));
    List<UserModel> list = await _userRepository.search(query);
    emit(state.copyWith(status: SearchStatus.LOADED, users: list));
  }
}
