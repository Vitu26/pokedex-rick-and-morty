import 'dart:developer' as developer;


class AppLogger {
  static const String _tag = 'PokedexApp';

  static void apiRequest(String endpoint,
      {String? method, Map<String, dynamic>? params}) {
    developer.log(
      'API Request: ${method ?? 'GET'} $endpoint${params != null ? ' - Params: $params' : ''}',
      name: '${_tag}_API',
      level: 700,
    );
  }

  static void apiResponse(String endpoint,
      {int? statusCode, Duration? duration}) {
    developer.log(
      'API Response: $endpoint - Status: ${statusCode ?? 'unknown'}${duration != null ? ' - ${duration.inMilliseconds}ms' : ''}',
      name: '${_tag}_API',
      level: 700,
    );
  }


  static void apiError(String endpoint, Object error, {int? statusCode}) {
    developer.log(
      'API Error: $endpoint - Status: ${statusCode ?? 'unknown'} - Error: $error',
      name: '${_tag}_API',
      level: 1000,
      error: error,
    );
  }
}
