import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/widgets/error_widget.dart';
import 'package:pokedex/core/error/app_error.dart';

void main() {
  group('AppErrorWidget Tests', () {
    testWidgets('should display error message', (WidgetTester tester) async {
      // Arrange
      const error = NetworkError(message: 'Test error message');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(error: error),
          ),
        ),
      );

      // Assert
      expect(find.text('Erro de conexão'), findsOneWidget);
      expect(find.text('Test error message'), findsOneWidget);
    });

    testWidgets('should display retry button when onRetry is provided',
        (WidgetTester tester) async {
      // Arrange
      const error = NetworkError();
      bool retryCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              error: error,
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Tentar novamente'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Tap retry button
      await tester.tap(find.text('Tentar novamente'));
      await tester.pump();

      expect(retryCalled, isTrue);
    });

    testWidgets('should not display retry button when onRetry is null',
        (WidgetTester tester) async {
      // Arrange
      const error = NetworkError();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(error: error),
          ),
        ),
      );

      // Assert
      expect(find.text('Tentar novamente'), findsNothing);
    });

    testWidgets('should display offline mode button for NetworkError',
        (WidgetTester tester) async {
      // Arrange
      const error = NetworkError();
      bool offlineModeCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              error: error,
              onUseOfflineMode: () => offlineModeCalled = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Usar modo offline'), findsOneWidget);
      expect(find.byIcon(Icons.offline_bolt), findsOneWidget);

      // Tap offline mode button
      await tester.tap(find.text('Usar modo offline'));
      await tester.pump();

      expect(offlineModeCalled, isTrue);
    });

    testWidgets('should not display offline mode button for non-NetworkError',
        (WidgetTester tester) async {
      // Arrange
      const error = ServerError();
      bool offlineModeCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              error: error,
              onUseOfflineMode: () => offlineModeCalled = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Usar modo offline'), findsNothing);
    });

    testWidgets('should display custom title when provided',
        (WidgetTester tester) async {
      // Arrange
      const error = NetworkError();
      const customTitle = 'Custom Error Title';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              error: error,
              customTitle: customTitle,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(customTitle), findsOneWidget);
    });

    testWidgets('should display custom message when provided',
        (WidgetTester tester) async {
      // Arrange
      const error = NetworkError();
      const customMessage = 'Custom error message';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              error: error,
              customMessage: customMessage,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(customMessage), findsOneWidget);
    });

    testWidgets('should display error details when showDetails is true',
        (WidgetTester tester) async {
      // Arrange
      const error = NetworkError(
        message: 'Test error',
        code: 'TEST_ERROR',
        originalError: 'Original error message',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              error: error,
              showDetails: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Detalhes do erro:'), findsOneWidget);
      expect(find.text('Código: TEST_ERROR'), findsOneWidget);
      expect(
          find.text('Erro original: Original error message'), findsOneWidget);
    });

    testWidgets('should display different icons for different error types',
        (WidgetTester tester) async {
      // Test NetworkError
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(error: const NetworkError()),
          ),
        ),
      );
      expect(find.byIcon(Icons.wifi_off_outlined), findsOneWidget);

      // Test TimeoutError
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(error: const TimeoutError()),
          ),
        ),
      );
      expect(find.byIcon(Icons.timer_outlined), findsOneWidget);

      // Test ServerError
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(error: const ServerError()),
          ),
        ),
      );
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display tips for NetworkError',
        (WidgetTester tester) async {
      // Arrange
      const error = NetworkError();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(error: error),
          ),
        ),
      );

      // Assert
      expect(find.text('💡 Dicas para resolver:'), findsOneWidget);
      expect(find.textContaining('Verifique se sua internet está funcionando'),
          findsOneWidget);
      expect(
          find.textContaining('Tente usar uma rede diferente'), findsOneWidget);
      expect(find.textContaining('Desative temporariamente o firewall'),
          findsOneWidget);
      expect(find.textContaining('Tente novamente em alguns minutos'),
          findsOneWidget);
    });

    testWidgets('should not display tips for non-NetworkError',
        (WidgetTester tester) async {
      // Arrange
      const error = ServerError();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(error: error),
          ),
        ),
      );

      // Assert
      expect(find.text('💡 Dicas para resolver:'), findsNothing);
    });
  });

  group('SimpleErrorWidget Tests', () {
    testWidgets('should display simple error message',
        (WidgetTester tester) async {
      // Arrange
      const message = 'Simple error message';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimpleErrorWidget(message: message),
          ),
        ),
      );

      // Assert
      expect(find.text(message), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets(
        'should display retry button when onRetry is provided and showRetry is true',
        (WidgetTester tester) async {
      // Arrange
      const message = 'Test error';
      bool retryCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimpleErrorWidget(
              message: message,
              onRetry: () => retryCalled = true,
              showRetry: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Retry'), findsOneWidget);

      // Tap retry button
      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryCalled, isTrue);
    });

    testWidgets('should not display retry button when showRetry is false',
        (WidgetTester tester) async {
      // Arrange
      const message = 'Test error';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimpleErrorWidget(
              message: message,
              onRetry: () {},
              showRetry: false,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Retry'), findsNothing);
    });
  });
}

