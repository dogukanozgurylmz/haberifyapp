part of '../blocs/tag_cubit.dart';

class TagState extends Equatable {
  const TagState();
  @override
  List<Object?> get props => [];
}

class TagInitial extends TagState {}

class TagLoading extends TagState {}

class TagLoaded extends TagState {
  final List<TagModel> tags;
  final bool hasReachedMax;

  const TagLoaded({
    required this.tags,
    required this.hasReachedMax,
  });

  TagLoaded copyWith({
    List<TagModel>? tags,
    bool? hasReachedMax,
  }) {
    return TagLoaded(
      tags: tags ?? this.tags,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [tags, hasReachedMax];
}

class TagError extends TagState {
  final String message;

  const TagError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
