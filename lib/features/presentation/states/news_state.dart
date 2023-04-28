part of '../blocs/news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  const NewsLoaded({
    required this.newsList,
  });
  final List<NewsModel> newsList;
  @override
  List<Object?> get props => [newsList];
}

class NewsError extends NewsState {
  const NewsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
