// ignore_for_file: constant_identifier_names

part of 'discovery_cubit.dart';

enum DiscoveryStatus {
  INITIAL,
  ERROR,
  LOADING,
  LOADED,
  TAGLOADING,
  TAGLOADED,
}

class DiscoveryState extends Equatable {
  final DiscoveryStatus status;
  final bool hasReachedMax;
  final List<TagModel> tags;
  final List<NewsModel> newsList;

  const DiscoveryState({
    required this.status,
    required this.hasReachedMax,
    required this.tags,
    required this.newsList,
  });

  DiscoveryState copyWith({
    DiscoveryStatus? status,
    bool? hasReachedMax,
    List<TagModel>? tags,
    List<NewsModel>? newsList,
  }) {
    return DiscoveryState(
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      tags: tags ?? this.tags,
      newsList: newsList ?? this.newsList,
    );
  }

  @override
  List<Object> get props => [
        status,
        hasReachedMax,
        tags,
        newsList,
      ];
}
