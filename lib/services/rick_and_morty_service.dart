import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:pokedex/models/api_response.dart';
import 'package:pokedex/models/character.dart';
import 'package:pokedex/core/error/app_error.dart';
import 'package:pokedex/core/constants/app_constants.dart';
import 'package:pokedex/core/constants/mock_data.dart';
import 'package:pokedex/core/utils/logger.dart';

class RickAndMortyService {
  final http.Client _httpClient;
  bool _useMockData = false;

  RickAndMortyService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  void enableMockData() {
    _useMockData = true;
    developer.log('Mock data habilitado', name: 'MockData');
  }

  void disableMockData() {
    _useMockData = false;
  }

  Future<ApiResponse> getCharacters({int page = 1}) async {
    final stopwatch = Stopwatch()..start();
    final endpoint = '${AppConstants.charactersEndpoint}/?page=$page';

    try {
      AppLogger.apiRequest(endpoint, params: {'page': page});

      final response = await _httpClient
          .get(
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
          )
          .timeout(AppConstants.networkTimeout);

      stopwatch.stop();
      AppLogger.apiResponse(endpoint,
          statusCode: response.statusCode, duration: stopwatch.elapsed);

      return _handleResponse(response, 'Characters');
    } catch (e) {
      stopwatch.stop();
      AppLogger.apiError(endpoint, e);

      if (e.toString().contains('TimeoutException')) {
        developer.log('Timeout detectado, _useMockData: $_useMockData',
            name: 'MockData');
        if (_useMockData) {
          developer.log('Usando dados mock devido a timeout', name: 'MockData');
          return MockData.getMockApiResponse(page: page);
        }

        throw const TimeoutError(
          message: 'Tempo limite excedido. Tente novamente.',
        );
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('NetworkException') ||
          e.toString().contains('Failed to fetch') ||
          e.toString().contains('Impossível conectar-se ao servidor remoto')) {
        if (_useMockData) {
          developer.log('Usando dados mock devido a erro de conectividade',
              name: 'MockData');
          return MockData.getMockApiResponse(page: page);
        }

        throw const NetworkError(
          message:
              'Não foi possível conectar à API do Rick and Morty. Verifique sua conexão com a internet ou tente novamente mais tarde.',
        );
      }

      throw ErrorHandler.handle(e);
    }
  }

  Future<Character> getCharacterById(int id) async {
    final stopwatch = Stopwatch()..start();
    final endpoint = '${AppConstants.charactersEndpoint}/$id';

    try {
      AppLogger.apiRequest(endpoint);

      final response = await _httpClient
          .get(
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
          )
          .timeout(AppConstants.networkTimeout);

      stopwatch.stop();
      AppLogger.apiResponse(endpoint,
          statusCode: response.statusCode, duration: stopwatch.elapsed);

      return _handleCharacterResponse(response);
    } catch (e) {
      stopwatch.stop();
      AppLogger.apiError(endpoint, e);

      if (e.toString().contains('TimeoutException')) {
        if (_useMockData) {
          developer.log('Usando dados mock para character $id devido a timeout',
              name: 'MockData');
          final mockCharacter = MockData.getMockCharacterById(id);
          if (mockCharacter != null) {
            return mockCharacter;
          }
        }

        throw const TimeoutError(
          message: 'Tempo limite excedido. Tente novamente.',
        );
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('NetworkException') ||
          e.toString().contains('Failed to fetch') ||
          e.toString().contains('Impossível conectar-se ao servidor remoto')) {
        if (_useMockData) {
          developer.log(
              'Usando dados mock para character $id devido a erro de conectividade',
              name: 'MockData');
          final mockCharacter = MockData.getMockCharacterById(id);
          if (mockCharacter != null) {
            return mockCharacter;
          }
        }

        throw const NetworkError(
          message:
              'Não foi possível conectar à API do Rick and Morty. Verifique sua conexão com a internet ou tente novamente mais tarde.',
        );
      }

      throw ErrorHandler.handle(e);
    }
  }

  ApiResponse _handleResponse(http.Response response, String resourceName) {
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw NotFoundError(message: '$resourceName not found');
    } else if (response.statusCode >= 500) {
      throw ServerError(
        message: 'Server error: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } else {
      throw ServerError(
        message: 'HTTP error: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  Character _handleCharacterResponse(http.Response response) {
    if (response.statusCode == 200) {
      return Character.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw const NotFoundError(message: 'Character not found');
    } else if (response.statusCode >= 500) {
      throw ServerError(
        message: 'Server error: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } else {
      throw ServerError(
        message: 'HTTP error: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
