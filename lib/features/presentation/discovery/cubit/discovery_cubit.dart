import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habery/features/data/models/news_model.dart';
import 'package:habery/features/data/repositories/news_repository.dart';

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
          tagNewsImageMap: {},
        )) {
    init();
  }

  final TagRepository _tagRepository;
  final NewsRepository _newsRepository;
  int _startIndex = 0;
  final int _limit = 18;
  bool _hasReachedMax = false;
  List<TagModel> tagList = [];
  final Map<String, String> _tagNewsImageMap = {};

  Future<void> init() async {
    emit(state.copyWith(status: DiscoveryStatus.LOADING));
    await getAllTag();
    emit(state.copyWith(status: DiscoveryStatus.LOADED));
  }

  // bool changeTagLoad(bool isLoaded){
  //   if (isLoaded) {

  //   return emit(state.copyWith())
  //   }
  // }

  Future<void> getAllTag() async {
    if (_hasReachedMax) return;
    try {
      final tags = await _tagRepository.getAllPagination(_startIndex, _limit);
      if (tags.length < _limit) {
        _hasReachedMax = true;
      }

      tagList.addAll(tags);
      emit(state.copyWith(tags: tagList));
      await getAllNews();
      emit(state.copyWith(hasReachedMax: _hasReachedMax));
    } catch (error) {
      // emit(state.copyWith(message: error.toString()));
    }
    _startIndex += _limit; // startIndex değeri güncellendi
  }

  Future<void> getAllNews() async {
    // emit(state.copyWith(status: DiscoveryStatus.LOADING));
    try {
      for (var tag in state.tags) {
        var lastNewsId = tag.newsIds.last;
        NewsModel newsModel = await _newsRepository.getNewsById(lastNewsId);
        _tagNewsImageMap.addAll({tag.tag: newsModel.newsPhotoIds.first});
      }
      emit(state.copyWith(
        tagNewsImageMap: _tagNewsImageMap,
      ));
      // ignore: empty_catches
    } catch (e) {}
  }
}
