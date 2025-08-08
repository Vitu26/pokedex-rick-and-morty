import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/services/rick_and_morty_service.dart';
import 'package:pokedex/view_models/character_detail_state.dart';
import 'package:pokedex/core/error/app_error.dart';
import 'package:pokedex/core/dependency_injection.dart';

class CharacterDetailCubit extends Cubit<CharacterDetailState> {
  final RickAndMortyService _rickAndMortyService;

  CharacterDetailCubit({RickAndMortyService? rickAndMortyService})
      : _rickAndMortyService =
            rickAndMortyService ?? getIt<RickAndMortyService>(),
        super(CharacterDetailInitial());

  Future<void> loadCharacterDetail(int characterId) async {
    emit(CharacterDetailLoading());

    try {
      final character =
          await _rickAndMortyService.getCharacterById(characterId);
      emit(CharacterDetailLoaded(character));
    } catch (e) {
      final appError = ErrorHandler.handle(e);
      emit(CharacterDetailError(appError));
    }
  }

  void retryLoading(int characterId) {
    loadCharacterDetail(characterId);
  }

  void enableOfflineMode(int characterId) {
    _rickAndMortyService.enableMockData();
    loadCharacterDetail(characterId);
  }

  void disableOfflineMode() {
    _rickAndMortyService.disableMockData();
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Icons.favorite_rounded;
      case 'dead':
        return Icons.favorite_border_rounded;
      case 'unknown':
        return Icons.help_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  IconData getGenderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Icons.male_rounded;
      case 'female':
        return Icons.female_rounded;
      case 'genderless':
        return Icons.remove_circle_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String formatEpisodesCount(int episodeCount) {
    return '$episodeCount episodes';
  }

  String formatLocationName(String locationName) {
    return locationName.isEmpty ? 'Unknown' : locationName;
  }

  String formatOriginName(String originName) {
    return originName.isEmpty ? 'Unknown' : originName;
  }
}
