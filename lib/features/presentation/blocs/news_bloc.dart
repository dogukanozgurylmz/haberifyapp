import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:haberifyapp/features/data/models/news_model.dart';
import 'package:haberifyapp/features/data/repositories/news_repository.dart';
import 'package:intl/intl.dart';
part '../events/news_event.dart';
part '../states/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc({
    required NewsRepository newsRepository,
  })  : _newsRepository = newsRepository,
        super(NewsInitial()) {
    on<NewsGetAll>(_onNewsGetAll);
  }

  final NewsRepository _newsRepository;

  Future<void> _onNewsGetAll(
    NewsGetAll event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    // await Future.delayed(const Duration(seconds: 3));
    try {
      final newsList = await _newsRepository.getAll();
      if (newsList.isEmpty) {
        emit(const NewsError("Haber bulunamadı"));
      } else {
        emit(NewsLoaded(newsList: newsList));
      }
    } catch (e) {
      emit(NewsError(e.toString()));
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
