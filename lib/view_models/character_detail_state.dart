import 'package:equatable/equatable.dart';
import 'package:pokedex/models/character.dart';
import 'package:pokedex/core/error/app_error.dart';

abstract class CharacterDetailState extends Equatable {
  const CharacterDetailState();

  @override
  List<Object?> get props => [];
}

class CharacterDetailInitial extends CharacterDetailState {}

class CharacterDetailLoading extends CharacterDetailState {}

class CharacterDetailLoaded extends CharacterDetailState {
  final Character character;

  const CharacterDetailLoaded(this.character);

  @override
  List<Object?> get props => [character];
}

class CharacterDetailError extends CharacterDetailState {
  final AppError error;

  const CharacterDetailError(this.error);

  @override
  List<Object?> get props => [error];
}
