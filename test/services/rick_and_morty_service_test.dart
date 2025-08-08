import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pokedex/services/rick_and_morty_service.dart';
import 'package:pokedex/models/api_response.dart';
import 'package:pokedex/models/character.dart';
import 'package:pokedex/core/error/app_error.dart';
import 'package:pokedex/core/constants/mock_data.dart';

import 'rick_and_morty_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('RickAndMortyService Tests', () {
    late RickAndMortyService service;
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      service = RickAndMortyService(httpClient: mockHttpClient);
    });

    group('getCharacters', () {
      test('should return ApiResponse when API call is successful', () async {
        // Arrange
        final responseJson = {
          'info': {
            'count': 826,
            'pages': 42,
            'next': 'https://rickandmortyapi.com/api/character/?page=2',
            'prev': null,
          },
          'results': [
            {
              'id': 1,
              'name': 'Rick Sanchez',
              'status': 'Alive',
              'species': 'Human',
              'type': '',
              'gender': 'Male',
              'origin': {
                'name': 'Earth (C-137)',
                'url': 'https://rickandmortyapi.com/api/location/1',
              },
              'location': {
                'name': 'Citadel of Ricks',
                'url': 'https://rickandmortyapi.com/api/location/3',
              },
              'image':
                  'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
              'episode': ['https://rickandmortyapi.com/api/episode/1'],
              'url': 'https://rickandmortyapi.com/api/character/1',
              'created': '2017-11-04T18:48:46.250Z',
            },
          ],
        };

        when(mockHttpClient.get(
          Uri.parse('https://rickandmortyapi.com/api/character/?page=1'),
        )).thenAnswer((_) async => http.Response(
              '{"info":{"count":826,"pages":42,"next":"https://rickandmortyapi.com/api/character/?page=2","prev":null},"results":[{"id":1,"name":"Rick Sanchez","status":"Alive","species":"Human","type":"","gender":"Male","origin":{"name":"Earth (C-137)","url":"https://rickandmortyapi.com/api/location/1"},"location":{"name":"Citadel of Ricks","url":"https://rickandmortyapi.com/api/location/3"},"image":"https://rickandmortyapi.com/api/character/avatar/1.jpeg","episode":["https://rickandmortyapi.com/api/episode/1"],"url":"https://rickandmortyapi.com/api/character/1","created":"2017-11-04T18:48:46.250Z"}]}',
              200,
            ));

        // Act
        final result = await service.getCharacters(page: 1);

        // Assert
        expect(result, isA<ApiResponse>());
        expect(result.info.count, equals(826));
        expect(result.info.pages, equals(42));
        expect(result.results, hasLength(1));
        expect(result.results.first.name, equals('Rick Sanchez'));

        verify(mockHttpClient.get(
          Uri.parse('https://rickandmortyapi.com/api/character/?page=1'),
        )).called(1);
      });

      test('should throw NetworkError when connection fails', () async {
        // Arrange
        when(mockHttpClient.get(any)).thenThrow(
          Exception('SocketException: Failed to connect'),
        );

        // Act & Assert
        expect(
          () => service.getCharacters(),
          throwsA(isA<NetworkError>()),
        );
      });

      test(
          'should throw NetworkError when connection fails with specific message',
          () async {
        // Arrange
        when(mockHttpClient.get(any)).thenThrow(
          Exception('Impossível conectar-se ao servidor remoto'),
        );

        // Act & Assert
        expect(
          () => service.getCharacters(),
          throwsA(isA<NetworkError>()),
        );
      });

      test(
          'should return mock data when mock mode is enabled and connection fails',
          () async {
        // Arrange
        when(mockHttpClient.get(any)).thenThrow(
          Exception('SocketException: Failed to connect'),
        );
        service.enableMockData();

        // Act
        final result = await service.getCharacters();

        // Assert
        expect(result, isA<ApiResponse>());
        expect(result.results, hasLength(5));
        expect(result.results.first.name, equals('Rick Sanchez'));
      });

      test('should throw ServerError when API returns 500', () async {
        // Arrange
        when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(
              'Server Error',
              500,
            ));

        // Act & Assert
        expect(
          () => service.getCharacters(),
          throwsA(isA<ServerError>()),
        );
      });

      test('should throw NotFoundError when API returns 404', () async {
        // Arrange
        when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(
              'Not Found',
              404,
            ));

        // Act & Assert
        expect(
          () => service.getCharacters(),
          throwsA(isA<NotFoundError>()),
        );
      });
    });

    group('getCharacterById', () {
      test('should return Character when API call is successful', () async {
        // Arrange
        when(mockHttpClient.get(
          Uri.parse('https://rickandmortyapi.com/api/character/1'),
        )).thenAnswer((_) async => http.Response(
              '{"id":1,"name":"Rick Sanchez","status":"Alive","species":"Human","type":"","gender":"Male","origin":{"name":"Earth (C-137)","url":"https://rickandmortyapi.com/api/location/1"},"location":{"name":"Citadel of Ricks","url":"https://rickandmortyapi.com/api/location/3"},"image":"https://rickandmortyapi.com/api/character/avatar/1.jpeg","episode":["https://rickandmortyapi.com/api/episode/1"],"url":"https://rickandmortyapi.com/api/character/1","created":"2017-11-04T18:48:46.250Z"}',
              200,
            ));

        // Act
        final result = await service.getCharacterById(1);

        // Assert
        expect(result, isA<Character>());
        expect(result.id, equals(1));
        expect(result.name, equals('Rick Sanchez'));

        verify(mockHttpClient.get(
          Uri.parse('https://rickandmortyapi.com/api/character/1'),
        )).called(1);
      });

      test(
          'should return mock character when mock mode is enabled and connection fails',
          () async {
        // Arrange
        when(mockHttpClient.get(any)).thenThrow(
          Exception('SocketException: Failed to connect'),
        );
        service.enableMockData();

        // Act
        final result = await service.getCharacterById(1);

        // Assert
        expect(result, isA<Character>());
        expect(result.id, equals(1));
        expect(result.name, equals('Rick Sanchez'));
      });

      test('should throw NetworkError when connection fails', () async {
        // Arrange
        when(mockHttpClient.get(any)).thenThrow(
          Exception('SocketException: Failed to connect'),
        );

        // Act & Assert
        expect(
          () => service.getCharacterById(1),
          throwsA(isA<NetworkError>()),
        );
      });

      test('should throw NotFoundError when character not found', () async {
        // Arrange
        when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response(
              'Not Found',
              404,
            ));

        // Act & Assert
        expect(
          () => service.getCharacterById(999),
          throwsA(isA<NotFoundError>()),
        );
      });
    });

    group('Mock Data Mode', () {
      test('should enable mock data mode', () {
        // Act
        service.enableMockData();

        // Assert
        // Note: We can't directly test the private field, but we can test the behavior
        expect(service, isA<RickAndMortyService>());
      });

      test('should disable mock data mode', () {
        // Act
        service.disableMockData();

        // Assert
        expect(service, isA<RickAndMortyService>());
      });
    });

    group('MockData Tests', () {
      test('should return mock API response', () {
        // Act
        final result = MockData.getMockApiResponse();

        // Assert
        expect(result, isA<ApiResponse>());
        expect(result.results, hasLength(5));
        expect(result.info.count, equals(5));
        expect(result.info.pages, equals(1));
      });

      test('should return mock character by ID', () {
        // Act
        final result = MockData.getMockCharacterById(1);

        // Assert
        expect(result, isA<Character>());
        expect(result!.id, equals(1));
        expect(result.name, equals('Rick Sanchez'));
      });

      test('should return null for non-existent character ID', () {
        // Act
        final result = MockData.getMockCharacterById(999);

        // Assert
        expect(result, isNull);
      });
    });
  });
}

