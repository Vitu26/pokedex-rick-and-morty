import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pokedex/view_models/characters_cubit.dart';
import 'package:pokedex/view_models/characters_state.dart';
import 'package:pokedex/services/rick_and_morty_service.dart';
import 'package:pokedex/core/error/app_error.dart';
import 'package:pokedex/core/constants/mock_data.dart';

import 'characters_cubit_test.mocks.dart';

@GenerateMocks([RickAndMortyService])
void main() {
  group('CharactersCubit Tests', () {
    late CharactersCubit cubit;
    late MockRickAndMortyService mockService;

    setUp(() {
      mockService = MockRickAndMortyService();
      cubit = CharactersCubit(rickAndMortyService: mockService);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be CharactersInitial', () {
      // Assert
      expect(cubit.state, isA<CharactersInitial>());
    });

    blocTest<CharactersCubit, CharactersState>(
      'should emit [CharactersLoading, CharactersLoaded] when loadCharacters succeeds',
      build: () {
        when(mockService.getCharacters(page: 1)).thenAnswer(
          (_) async => MockData.getMockApiResponse(),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadCharacters(),
      expect: () => [
        isA<CharactersLoading>(),
        isA<CharactersLoaded>(),
      ],
      verify: (_) {
        verify(mockService.getCharacters(page: 1)).called(1);
      },
    );

    blocTest<CharactersCubit, CharactersState>(
      'should emit [CharactersLoading, CharactersError] when loadCharacters fails',
      build: () {
        when(mockService.getCharacters(page: 1)).thenThrow(
          const NetworkError(message: 'Connection failed'),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadCharacters(),
      expect: () => [
        isA<CharactersLoading>(),
        isA<CharactersError>(),
      ],
      verify: (_) {
        verify(mockService.getCharacters(page: 1)).called(1);
      },
    );

    blocTest<CharactersCubit, CharactersState>(
      'should load more characters when paginating',
      build: () {
        when(mockService.getCharacters(page: 1)).thenAnswer(
          (_) async => MockData.getMockApiResponse(),
        );
        when(mockService.getCharacters(page: 2)).thenAnswer(
          (_) async => MockData.getMockApiResponse(),
        );
        return cubit;
      },
      act: (cubit) async {
        await cubit.loadCharacters();
        await cubit.loadCharacters();
      },
      expect: () => [
        isA<CharactersLoading>(),
        isA<CharactersLoaded>(),
      ],
      verify: (_) {
        verify(mockService.getCharacters(page: 1)).called(1);
        verifyNever(mockService.getCharacters(page: 2));
      },
    );

    blocTest<CharactersCubit, CharactersState>(
      'should not load more characters when hasReachedMax is true',
      build: () {
        when(mockService.getCharacters(page: 1)).thenAnswer(
          (_) async => MockData.getMockApiResponse(),
        );
        return cubit;
      },
      act: (cubit) async {
        await cubit.loadCharacters();
        await cubit.loadCharacters(); // Should not call service again
      },
      expect: () => [
        isA<CharactersLoading>(),
        isA<CharactersLoaded>(),
      ],
      verify: (_) {
        verify(mockService.getCharacters(page: 1)).called(1);
        verifyNever(mockService.getCharacters(page: 2));
      },
    );

    blocTest<CharactersCubit, CharactersState>(
      'should refresh characters when refresh is true',
      build: () {
        when(mockService.getCharacters(page: 1)).thenAnswer(
          (_) async => MockData.getMockApiResponse(),
        );
        return cubit;
      },
      act: (cubit) async {
        await cubit.loadCharacters();
        await cubit.loadCharacters(refresh: true);
      },
      expect: () => [
        isA<CharactersLoading>(),
        isA<CharactersLoaded>(),
        isA<CharactersLoading>(),
        isA<CharactersLoaded>(),
      ],
      verify: (_) {
        verify(mockService.getCharacters(page: 1)).called(2);
      },
    );

    blocTest<CharactersCubit, CharactersState>(
      'should enable offline mode and load characters',
      build: () {
        when(mockService.getCharacters(page: 1)).thenAnswer(
          (_) async => MockData.getMockApiResponse(),
        );
        return cubit;
      },
      act: (cubit) async {
        cubit.enableOfflineMode();
      },
      expect: () => [
        isA<CharactersLoading>(),
        isA<CharactersLoaded>(),
      ],
      verify: (_) {
        verify(mockService.enableMockData()).called(1);
        verify(mockService.getCharacters(page: 1)).called(1);
      },
    );

    test('should disable offline mode', () {
      // Act
      cubit.disableOfflineMode();

      // Assert
      verify(mockService.disableMockData()).called(1);
    });

    test('should retry loading', () {
      // Arrange
      when(mockService.getCharacters(page: 1)).thenAnswer(
        (_) async => MockData.getMockApiResponse(),
      );

      // Act
      cubit.retryLoading();

      // Assert
      verify(mockService.getCharacters(page: 1)).called(1);
    });
  });
}
