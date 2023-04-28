import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:haberifyapp/features/data/models/news_model.dart';
import 'package:haberifyapp/features/data/repositories/news_repository.dart';

import '../../../data/models/tag_model.dart';
import '../../../data/repositories/tag_repository.dart';

part 'discovery_state.dart';

class DiscoveryCubit extends Cubit<DiscoveryState> {
  DiscoveryCubit(
      {required TagRepository tagRepository,
      required NewsRepository newsRepository})
      : _tagRepository = tagRepository,
        _newsRepository = newsRepository,
        super(const DiscoveryState(
          status: DiscoveryStatus.INITIAL,
          hasReachedMax: false,
          tags: [],
          newsList: [],
        )) {
    // init();
  }

  final TagRepository _tagRepository;
  final NewsRepository _newsRepository;
  int _startIndex = 0;
  final int _limit = 10;
  bool _hasReachedMax = false;
  List<TagModel> tagList = [];
  final List<NewsModel> _newsList = [];

  Future<void> init() async {
    // await getAllTag();
    await getAllNews();
  }

  Future<void> getAllTag() async {
    if (_hasReachedMax) return;
    // emit(TagLoading());
    try {
      final tags = await _tagRepository.getAllPagination(_startIndex, _limit);
      if (tags.length < _limit) {
        _hasReachedMax = true;
      }

      tagList.addAll(tags);
      emit(state.copyWith(
        status: DiscoveryStatus.TAGLOADED,
        tags: tagList,
        hasReachedMax: _hasReachedMax,
      ));
      await getAllNews();

      // emit(TagLoaded(tags: tagList, hasReachedMax: _hasReachedMax));
    } catch (error) {
      // emit(state.copyWith(message: error.toString()));
    }
    _startIndex += _limit; // startIndex değeri güncellendi
  }

  Future<void> getAllNews() async {
    int turn = 0;
    emit(state.copyWith(status: DiscoveryStatus.LOADING));
    try {
      for (var tag in state.tags) {
        for (var newsId in tag.newsIds) {
          NewsModel newsModel = await _newsRepository.getNewsById(newsId);
          _newsList.add(newsModel);
          turn++;
          print(turn);
        }
      }

      emit(state.copyWith(
        newsList: _newsList,
        status: DiscoveryStatus.LOADED,
      ));
    } catch (e) {
      print(e.toString());
    }
  }
}
