import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pokedex/view_models/character_detail_cubit.dart';
import 'package:pokedex/view_models/character_detail_state.dart';
import 'package:pokedex/services/rick_and_morty_service.dart';
import 'package:pokedex/core/error/app_error.dart';
import 'package:pokedex/core/constants/mock_data.dart';

import 'character_detail_cubit_test.mocks.dart';

@GenerateMocks([RickAndMortyService])
void main() {
  group('CharacterDetailCubit Tests', () {
    late CharacterDetailCubit cubit;
    late MockRickAndMortyService mockService;

    setUp(() {
      mockService = MockRickAndMortyService();
      cubit = CharacterDetailCubit(rickAndMortyService: mockService);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be CharacterDetailInitial', () {
      // Assert
      expect(cubit.state, isA<CharacterDetailInitial>());
    });

    blocTest<CharacterDetailCubit, CharacterDetailState>(
      'should emit [CharacterDetailLoading, CharacterDetailLoaded] when loadCharacterDetail succeeds',
      build: () {
        when(mockService.getCharacterById(1)).thenAnswer(
          (_) async => MockData.getMockCharacterById(1)!,
        );
        return cubit;
      },
      act: (cubit) => cubit.loadCharacterDetail(1),
      expect: () => [
        isA<CharacterDetailLoading>(),
        isA<CharacterDetailLoaded>(),
      ],
      verify: (_) {
        verify(mockService.getCharacterById(1)).called(1);
      },
    );

    blocTest<CharacterDetailCubit, CharacterDetailState>(
      'should emit [CharacterDetailLoading, CharacterDetailError] when loadCharacterDetail fails',
      build: () {
        when(mockService.getCharacterById(1)).thenThrow(
          const NetworkError(message: 'Connection failed'),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadCharacterDetail(1),
      expect: () => [
        isA<CharacterDetailLoading>(),
        isA<CharacterDetailError>(),
      ],
      verify: (_) {
        verify(mockService.getCharacterById(1)).called(1);
      },
    );

    blocTest<CharacterDetailCubit, CharacterDetailState>(
      'should retry loading when retryLoading is called',
      build: () {
        when(mockService.getCharacterById(1)).thenAnswer(
          (_) async => MockData.getMockCharacterById(1)!,
        );
        return cubit;
      },
      act: (cubit) => cubit.retryLoading(1),
      expect: () => [
        isA<CharacterDetailLoading>(),
        isA<CharacterDetailLoaded>(),
      ],
      verify: (_) {
        verify(mockService.getCharacterById(1)).called(1);
      },
    );

    blocTest<CharacterDetailCubit, CharacterDetailState>(
      'should enable offline mode and load character detail',
      build: () {
        when(mockService.getCharacterById(1)).thenAnswer(
          (_) async => MockData.getMockCharacterById(1)!,
        );
        return cubit;
      },
      act: (cubit) => cubit.enableOfflineMode(1),
      expect: () => [
        isA<CharacterDetailLoading>(),
        isA<CharacterDetailLoaded>(),
      ],
      verify: (_) {
        verify(mockService.enableMockData()).called(1);
        verify(mockService.getCharacterById(1)).called(1);
      },
    );

    test('should disable offline mode', () {
      // Act
      cubit.disableOfflineMode();

      // Assert
      verify(mockService.disableMockData()).called(1);
    });

    test('should load different character when characterId changes', () {
      // Arrange
      when(mockService.getCharacterById(1)).thenAnswer(
        (_) async => MockData.getMockCharacterById(1)!,
      );
      when(mockService.getCharacterById(2)).thenAnswer(
        (_) async => MockData.getMockCharacterById(2)!,
      );

      // Act
      cubit.loadCharacterDetail(1);
      cubit.loadCharacterDetail(2);

      // Assert
      verify(mockService.getCharacterById(1)).called(1);
      verify(mockService.getCharacterById(2)).called(1);
    });
  });
}

