import 'package:pokedex/models/character.dart';
import 'package:pokedex/models/api_response.dart';

class MockData {
  static final List<Character> mockCharacters = [
    Character(
      id: 1,
      name: 'Rick Sanchez',
      status: 'Alive',
      species: 'Human',
      type: '',
      gender: 'Male',
      origin: Origin(
          name: 'Earth (C-137)',
          url: 'https://rickandmortyapi.com/api/location/1'),
      location: Location(
          name: 'Citadel of Ricks',
          url: 'https://rickandmortyapi.com/api/location/3'),
      image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
      episode: [
        'https://rickandmortyapi.com/api/episode/1',
        'https://rickandmortyapi.com/api/episode/2',
        'https://rickandmortyapi.com/api/episode/3',
      ],
      url: 'https://rickandmortyapi.com/api/character/1',
      created: '2017-11-04T18:48:46.250Z',
    ),
    Character(
      id: 2,
      name: 'Morty Smith',
      status: 'Alive',
      species: 'Human',
      type: '',
      gender: 'Male',
      origin: Origin(
          name: 'Earth (C-137)',
          url: 'https://rickandmortyapi.com/api/location/1'),
      location: Location(
          name: 'Citadel of Ricks',
          url: 'https://rickandmortyapi.com/api/location/3'),
      image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
      episode: [
        'https://rickandmortyapi.com/api/episode/1',
        'https://rickandmortyapi.com/api/episode/2',
        'https://rickandmortyapi.com/api/episode/3',
      ],
      url: 'https://rickandmortyapi.com/api/character/2',
      created: '2017-11-04T18:50:21.651Z',
    ),
    Character(
      id: 3,
      name: 'Summer Smith',
      status: 'Alive',
      species: 'Human',
      type: '',
      gender: 'Female',
      origin: Origin(
          name: 'Earth (Replacement Dimension)',
          url: 'https://rickandmortyapi.com/api/location/20'),
      location: Location(
          name: 'Earth (Replacement Dimension)',
          url: 'https://rickandmortyapi.com/api/location/20'),
      image: 'https://rickandmortyapi.com/api/character/avatar/3.jpeg',
      episode: [
        'https://rickandmortyapi.com/api/episode/6',
        'https://rickandmortyapi.com/api/episode/7',
        'https://rickandmortyapi.com/api/episode/8',
      ],
      url: 'https://rickandmortyapi.com/api/character/3',
      created: '2017-11-04T19:09:56.428Z',
    ),
    Character(
      id: 4,
      name: 'Beth Smith',
      status: 'Alive',
      species: 'Human',
      type: '',
      gender: 'Female',
      origin: Origin(
          name: 'Earth (Replacement Dimension)',
          url: 'https://rickandmortyapi.com/api/location/20'),
      location: Location(
          name: 'Earth (Replacement Dimension)',
          url: 'https://rickandmortyapi.com/api/location/20'),
      image: 'https://rickandmortyapi.com/api/character/avatar/4.jpeg',
      episode: [
        'https://rickandmortyapi.com/api/episode/6',
        'https://rickandmortyapi.com/api/episode/7',
        'https://rickandmortyapi.com/api/episode/8',
      ],
      url: 'https://rickandmortyapi.com/api/character/4',
      created: '2017-11-04T19:22:43.665Z',
    ),
    Character(
      id: 5,
      name: 'Jerry Smith',
      status: 'Alive',
      species: 'Human',
      type: '',
      gender: 'Male',
      origin: Origin(
          name: 'Earth (Replacement Dimension)',
          url: 'https://rickandmortyapi.com/api/location/20'),
      location: Location(
          name: 'Earth (Replacement Dimension)',
          url: 'https://rickandmortyapi.com/api/location/20'),
      image: 'https://rickandmortyapi.com/api/character/avatar/5.jpeg',
      episode: [
        'https://rickandmortyapi.com/api/episode/6',
        'https://rickandmortyapi.com/api/episode/7',
        'https://rickandmortyapi.com/api/episode/8',
      ],
      url: 'https://rickandmortyapi.com/api/character/5',
      created: '2017-11-04T19:26:56.301Z',
    ),
  ];

  static ApiResponse getMockApiResponse({int page = 1}) {
    return ApiResponse(
      info: Info(
        count: mockCharacters.length,
        pages: 1,
        next: '',
        prev: null,
      ),
      results: mockCharacters,
    );
  }

  static Character? getMockCharacterById(int id) {
    try {
      return mockCharacters.firstWhere((character) => character.id == id);
    } catch (e) {
      return null;
    }
  }
}
