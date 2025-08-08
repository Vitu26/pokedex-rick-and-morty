import 'package:flutter/material.dart';
import 'package:pokedex/core/error/app_error.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/core/theme/app_text_styles.dart';

class AppErrorWidget extends StatelessWidget {
  final AppError error;
  final VoidCallback? onRetry;
  final VoidCallback? onUseOfflineMode;
  final String? customTitle;
  final String? customMessage;
  final bool showDetails;

  const AppErrorWidget({
    Key? key,
    required this.error,
    this.onRetry,
    this.onUseOfflineMode,
    this.customTitle,
    this.customMessage,
    this.showDetails = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildErrorIcon(),
            const SizedBox(height: 32),
            _buildErrorTitle(context),
            const SizedBox(height: 16),
            _buildErrorMessage(context),
            if (showDetails) ...[
              const SizedBox(height: 24),
              _buildErrorDetails(context),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              _buildRetryButton(context),
            ],
            if ((error is NetworkError || error is TimeoutError) &&
                onUseOfflineMode != null) ...[
              const SizedBox(height: 16),
              _buildOfflineModeButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    IconData iconData;
    Color iconColor;

    switch (error.runtimeType) {
      case NetworkError:
        iconData = Icons.wifi_off_outlined;
        iconColor = AppColors.textSecondary;
        break;
      case TimeoutError:
        iconData = Icons.timer_outlined;
        iconColor = AppColors.textSecondary;
        break;
      case ServerError:
        iconData = Icons.error_outline;
        iconColor = AppColors.error;
        break;
      case NotFoundError:
        iconData = Icons.search_off_outlined;
        iconColor = AppColors.textSecondary;
        break;
      case InvalidDataError:
        iconData = Icons.broken_image_outlined;
        iconColor = AppColors.error;
        break;
      case CacheError:
        iconData = Icons.storage_outlined;
        iconColor = AppColors.textSecondary;
        break;
      default:
        iconData = Icons.error_outline;
        iconColor = AppColors.error;
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.rickWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.rickDarkGray,
          width: 2,
        ),
      ),
      child: Icon(
        iconData,
        size: 32,
        color: iconColor,
      ),
    );
  }

  Widget _buildErrorTitle(BuildContext context) {
    final title = customTitle ?? _getDefaultTitle(context);

    return Text(
      title,
      style: AppTextStyles.h4.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    final message = customMessage ?? error.message;

    return Column(
      children: [
        Text(
          message,
          style: AppTextStyles.bodyMediumSecondary.copyWith(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (error is NetworkError || error is TimeoutError) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.rickWhite.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.rickDarkGray,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '💡 Dicas para resolver:',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error is NetworkError
                      ? '• Verifique se sua internet está funcionando\n'
                          '• Tente usar uma rede diferente (WiFi/celular)\n'
                          '• Desative temporariamente o firewall\n'
                          '• Tente novamente em alguns minutos'
                      : '• A conexão está lenta, aguarde um pouco\n'
                          '• Tente usar uma rede mais rápida\n'
                          '• Verifique se o servidor está respondendo\n'
                          '• Tente novamente em alguns instantes',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.rickWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.rickDarkGray,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalhes do erro:',
            style: AppTextStyles.labelMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Código: ${error.code ?? 'N/A'}',
            style: AppTextStyles.caption.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          if (error.originalError != null) ...[
            const SizedBox(height: 8),
            Text(
              'Erro original: ${error.originalError.toString()}',
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.rickGreen,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.rickDarkGray,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onRetry,
          borderRadius: BorderRadius.circular(6),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh,
                  color: AppColors.rickWhite,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Tentar novamente',
                  style: TextStyle(
                    color: AppColors.rickWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfflineModeButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.rickWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.rickDarkGray,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onUseOfflineMode,
          borderRadius: BorderRadius.circular(6),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.offline_bolt,
                  color: AppColors.rickDarkGray,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Usar modo offline',
                  style: TextStyle(
                    color: AppColors.rickDarkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDefaultTitle(BuildContext context) {
    switch (error.runtimeType) {
      case NetworkError:
        return 'Erro de conexão';
      case TimeoutError:
        return 'Tempo limite excedido';
      case ServerError:
        return 'Erro do servidor';
      case NotFoundError:
        return 'Não encontrado';
      case InvalidDataError:
        return 'Dados inválidos';
      case CacheError:
        return 'Erro de cache';
      default:
        return 'Erro desconhecido';
    }
  }
}

class SimpleErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool showRetry;

  const SimpleErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
    this.showRetry = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.error,
            textAlign: TextAlign.center,
          ),
          if (showRetry && onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
