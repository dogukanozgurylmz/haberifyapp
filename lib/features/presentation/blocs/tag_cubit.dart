import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/tag_model.dart';
import '../../data/repositories/tag_repository.dart';

part '../states/tag_state.dart';

class TagCubit extends Cubit<TagState> {
  TagCubit({required TagRepository tagRepository})
      : _tagRepository = tagRepository,
        super(TagInitial()) {
    getAll();
  }

  final TagRepository _tagRepository;
  int _startIndex = 0;
  final int _limit = 10;
  bool _hasReachedMax = false;
  List<TagModel> tagList = [];

  Future<void> getAll() async {
    if (_hasReachedMax) return;
    // emit(TagLoading());
    try {
      final tags = await _tagRepository.getAllPagination(_startIndex, _limit);
      if (tags.length < _limit) {
        _hasReachedMax = true;
      }
      tagList.addAll(tags);
      emit(TagLoaded(tags: tagList, hasReachedMax: _hasReachedMax));
    } catch (error) {
      emit(TagError(message: error.toString()));
    }
    _startIndex += _limit; // startIndex değeri güncellendi
  }
}
