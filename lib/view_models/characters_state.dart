import 'package:equatable/equatable.dart';
import 'package:pokedex/models/character.dart';
import 'package:pokedex/core/error/app_error.dart';

abstract class CharactersState extends Equatable {
  const CharactersState();

  @override
  List<Object?> get props => [];
}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> characters;
  final bool hasReachedMax;
  final int currentPage;
  final Character? selectedCharacter;
  final bool isLoadingMore;

  const CharactersLoaded({
    required this.characters,
    required this.hasReachedMax,
    required this.currentPage,
    this.selectedCharacter,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        characters,
        hasReachedMax,
        currentPage,
        selectedCharacter,
        isLoadingMore
      ];

  CharactersLoaded copyWith({
    List<Character>? characters,
    bool? hasReachedMax,
    int? currentPage,
    Character? selectedCharacter,
    bool? isLoadingMore,
  }) {
    return CharactersLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CharactersError extends CharactersState {
  final AppError error;

  const CharactersError(this.error);

  @override
  List<Object?> get props => [error];
}
