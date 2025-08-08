import 'package:get_it/get_it.dart';
import 'package:pokedex/services/rick_and_morty_service.dart';
import 'package:pokedex/view_models/characters_cubit.dart';
import 'package:pokedex/view_models/character_detail_cubit.dart';

final GetIt getIt = GetIt.instance;

class DependencyInjection {
  static void setup() {
    _registerServices();
    _registerViewModels();
  }

  static void _registerServices() {
    getIt.registerLazySingleton<RickAndMortyService>(
      () => RickAndMortyService(),
    );
  }

  static void _registerViewModels() {
    getIt.registerFactory<CharactersCubit>(
      () => CharactersCubit(),
    );

    getIt.registerFactory<CharacterDetailCubit>(
      () => CharacterDetailCubit(),
    );
  }

  static void reset() {
    getIt.reset();
  }
}

void setupDependencyInjection() => DependencyInjection.setup();
