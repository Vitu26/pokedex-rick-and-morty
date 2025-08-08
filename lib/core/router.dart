import 'package:go_router/go_router.dart';
import 'package:pokedex/views/characters_list_view.dart';
import 'package:pokedex/views/character_detail_view.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'characters',
      builder: (context, state) => const CharactersListView(),
    ),
    GoRoute(
      path: '/character/:id',
      name: 'character_detail',
      builder: (context, state) {
        final characterId = int.parse(state.pathParameters['id']!);
        return CharacterDetailView(characterId: characterId);
      },
    ),
  ],
);


