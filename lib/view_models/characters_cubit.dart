import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/models/character.dart';
import 'package:pokedex/services/rick_and_morty_service.dart';
import 'package:pokedex/view_models/characters_state.dart';
import 'package:pokedex/core/error/app_error.dart';
import 'package:pokedex/core/dependency_injection.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final RickAndMortyService _rickAndMortyService;

  int _totalPages = 0;

  CharactersCubit({RickAndMortyService? rickAndMortyService})
      : _rickAndMortyService =
            rickAndMortyService ?? getIt<RickAndMortyService>(),
        super(CharactersInitial());

  Future<void> loadCharacters({bool refresh = false}) async {
    if (state is CharactersLoaded) {
      final currentState = state as CharactersLoaded;

      if (refresh) {
        emit(CharactersLoading());
      } else if (currentState.hasReachedMax) {
        return;
      }
    } else {
      emit(CharactersLoading());
    }

    try {
      final currentState = state;
      int page = 1;
      List<Character> characters = [];
      Character? selectedCharacter;

      if (currentState is CharactersLoaded && !refresh) {
        page = currentState.currentPage + 1;
        characters = currentState.characters;
        selectedCharacter = currentState.selectedCharacter;
      }

      final apiResponse = await _rickAndMortyService.getCharacters(page: page);

      _totalPages = apiResponse.info.pages;
      final newCharacters = [...characters, ...apiResponse.results];
      final hasReachedMax = page >= _totalPages;

      emit(CharactersLoaded(
        characters: newCharacters,
        hasReachedMax: hasReachedMax,
        currentPage: page,
        selectedCharacter: selectedCharacter,
      ));
    } catch (e) {
      final appError = ErrorHandler.handle(e);
      emit(CharactersError(appError));
    }
  }

  void selectCharacter(Character character) {
    if (state is CharactersLoaded) {
      final currentState = state as CharactersLoaded;
      emit(currentState.copyWith(selectedCharacter: character));
    }
  }

  void clearSelection() {
    if (state is CharactersLoaded) {
      final currentState = state as CharactersLoaded;
      emit(currentState.copyWith(selectedCharacter: null));
    }
  }

  void checkScrollPosition(double scrollOffset, double maxScrollExtent) {
    if (state is CharactersLoaded) {
      final currentState = state as CharactersLoaded;
      final isNearBottom = scrollOffset >= (maxScrollExtent * 0.9);

      if (isNearBottom &&
          !currentState.hasReachedMax &&
          !currentState.isLoadingMore) {
        _loadMoreCharacters();
      }
    }
  }

  void _loadMoreCharacters() {
    if (state is CharactersLoaded) {
      final currentState = state as CharactersLoaded;
      emit(currentState.copyWith(isLoadingMore: true));
      loadCharacters();
    }
  }

  void retryLoading() {
    loadCharacters();
  }

  void enableOfflineMode() {
    _rickAndMortyService.enableMockData();
    loadCharacters(refresh: true);
  }

  void disableOfflineMode() {
    _rickAndMortyService.disableMockData();
  }
}
