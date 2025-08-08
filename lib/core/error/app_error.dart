import 'package:equatable/equatable.dart';


abstract class AppError extends Equatable {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppError({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, code, originalError];

  @override
  String toString() => 'AppError: $message';
}

class NetworkError extends AppError {
  const NetworkError({
    super.message = 'Erro de conexão. Verifique sua internet.',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });
}


class TimeoutError extends AppError {
  const TimeoutError({
    super.message = 'Tempo limite excedido. Tente novamente.',
    super.code = 'TIMEOUT_ERROR',
    super.originalError,
  });
}


class ServerError extends AppError {
  final int? statusCode;

  const ServerError({
    super.message = 'Erro no servidor. Tente novamente mais tarde.',
    super.code = 'SERVER_ERROR',
    super.originalError,
    this.statusCode,
  });

  @override
  List<Object?> get props => [...super.props, statusCode];
}


class NotFoundError extends AppError {
  const NotFoundError({
    super.message = 'Dados não encontrados.',
    super.code = 'NOT_FOUND_ERROR',
    super.originalError,
  });
}


class InvalidDataError extends AppError {
  const InvalidDataError({
    super.message = 'Dados inválidos recebidos.',
    super.code = 'INVALID_DATA_ERROR',
    super.originalError,
  });
}


class UnknownError extends AppError {
  const UnknownError({
    super.message = 'Erro desconhecido. Tente novamente.',
    super.code = 'UNKNOWN_ERROR',
    super.originalError,
  });
}


class CacheError extends AppError {
  const CacheError({
    super.message = 'Erro ao acessar dados locais.',
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}


class ErrorHandler {
  static AppError handle(dynamic error) {
    if (error is AppError) {
      return error;
    }

    if (error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException')) {
      return const NetworkError();
    }

    if (error.toString().contains('TimeoutException')) {
      return const TimeoutError();
    }

    if (error.toString().contains('404')) {
      return const NotFoundError();
    }

    if (error.toString().contains('500') ||
        error.toString().contains('502') ||
        error.toString().contains('503')) {
      return const ServerError();
    }

    if (error.toString().contains('FormatException') ||
        error.toString().contains('TypeError')) {
      return const InvalidDataError();
    }

    return UnknownError(
      message: error.toString(),
      originalError: error,
    );
  }

  static bool isRecoverable(AppError error) {
    return error is NetworkError ||
        error is TimeoutError ||
        error is ServerError;
  }

  static String getUserFriendlyMessage(AppError error) {
    return error.message;
  }

  static String getActionSuggestion(AppError error) {
    switch (error.runtimeType) {
      case NetworkError:
        return 'Verifique sua conexão com a internet e tente novamente.';
      case TimeoutError:
        return 'A conexão está lenta. Tente novamente em alguns instantes.';
      case ServerError:
        return 'O servidor está temporariamente indisponível. Tente novamente mais tarde.';
      case NotFoundError:
        return 'Os dados solicitados não foram encontrados.';
      case InvalidDataError:
        return 'Os dados recebidos estão corrompidos. Tente novamente.';
      case CacheError:
        return 'Erro ao acessar dados locais. Tente recarregar a aplicação.';
      default:
        return 'Ocorreu um erro inesperado. Tente novamente.';
    }
  }
}

