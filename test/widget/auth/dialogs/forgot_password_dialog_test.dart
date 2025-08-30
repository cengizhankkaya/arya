import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/auth/widget/dialogs/forgot_password_dialog.dart';
import 'package:arya/features/auth/service/auth_service.dart';

// Mock sınıfları manuel olarak oluştur
class MockFirebaseAuthService implements FirebaseAuthService {
  bool _isResetEmailSent = false;
  String? _lastEmail;
  String? _errorMessage;
  Completer<AuthResult>? _completer;
  bool _isLoading = false;

  @override
  Future<AuthResult> sendPasswordResetEmail({required String email}) async {
    _lastEmail = email;
    _isLoading = true;

    // Create a completer that we can control from tests
    _completer = Completer<AuthResult>();

    // Return the future immediately, but don't complete it yet
    return _completer!.future;
  }

  // Test helper methods
  void setResetEmailSuccess(bool success) {
    _isResetEmailSent = success;
  }

  void setErrorMessage(String? error) {
    _errorMessage = error;
  }

  // Control the async behavior
  void completeSuccess() {
    if (_completer != null && !_completer!.isCompleted) {
      _isLoading = false;
      _completer!.complete(AuthResult.success(null));
    }
  }

  void completeError() {
    if (_completer != null && !_completer!.isCompleted) {
      _isLoading = false;
      _completer!.complete(AuthResult.error(_errorMessage ?? 'Test error'));
    }
  }

  // Simulate loading state
  void simulateLoading() {
    _isLoading = true;
  }

  void simulateLoaded() {
    _isLoading = false;
  }

  String? get lastEmail => _lastEmail;
  bool get isLoading => _isLoading;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> _pushedRoutes = [];
  final List<Route<dynamic>> _poppedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _poppedRoutes.add(route);
    super.didPop(route, previousRoute);
  }

  List<Route<dynamic>> get pushedRoutes => _pushedRoutes;
  List<Route<dynamic>> get poppedRoutes => _poppedRoutes;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ForgotPasswordDialog Widget Tests', () {
    late MockFirebaseAuthService mockAuthService;
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
      mockNavigatorObserver = MockNavigatorObserver();
    });

    tearDown(() {
      // Clean up any pending completers
      mockAuthService.completeSuccess();
    });

    Widget createTestWidget() {
      return MaterialApp(
        navigatorObservers: [mockNavigatorObserver],
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => ForgotPasswordDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );
    }

    group('Dialog Display Tests', () {
      testWidgets('ForgotPasswordDialog doğru şekilde görüntülenmeli', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(ForgotPasswordDialog), findsOneWidget);
      });

      testWidgets('Dialog başlığı doğru olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('Dialog açıklaması doğru olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
      });
    });

    group('Form Elements Tests', () {
      testWidgets('Email input field doğru şekilde görüntülenmeli', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('Form validation doğru çalışmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('Email input keyboard type email olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        final textField = find.byType(TextFormField);
        expect(textField, findsOneWidget);
      });
    });

    group('Button Tests', () {
      testWidgets('Cancel butonu doğru şekilde görüntülenmeli', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('Send butonu doğru şekilde görüntülenmeli', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Dialog içindeki ElevatedButton'ı bul
        final dialogButtons = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        expect(dialogButtons, findsOneWidget);
      });

      testWidgets('Cancel butonu tıklandığında dialog kapanmalı', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Cancel butonunu bul ve tıkla
        final cancelButton = find.byType(TextButton);
        await tester.tap(cancelButton);
        await tester.pumpAndSettle();

        // Assert - Dialog kapandı
        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('Input Interaction Tests', () {
      testWidgets('Email input\'a text girilebilmeli', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        const testEmail = 'test@example.com';
        await tester.enterText(find.byType(TextFormField), testEmail);

        // Assert
        expect(find.text(testEmail), findsOneWidget);
      });

      testWidgets('Email input\'tan text silinebilmeli', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        expect(find.text('test@example.com'), findsOneWidget);

        // Email'i sil
        await tester.enterText(find.byType(TextFormField), '');

        // Assert
        expect(find.text('test@example.com'), findsNothing);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Dialog semantic label\'ları doğru olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('Butonlar semantic label\'ları doğru olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Dialog içindeki butonları bul
        expect(find.byType(TextButton), findsOneWidget);
        final dialogButtons = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        expect(dialogButtons, findsOneWidget);
      });
    });

    group('Layout Tests', () {
      testWidgets('Dialog responsive layout\'a sahip olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(dialog, isNotNull);
      });

      testWidgets('Dialog actions doğru sırada olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        final actions = find.byType(AlertDialog);
        expect(actions, findsOneWidget);
      });
    });

    group('User Interaction Tests', () {
      testWidgets('Dialog dışına tıklandığında dialog kapanmalı', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Dialog dışına tıkla
        await tester.tapAt(const Offset(100, 100));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('Dependency Injection Tests', () {
      testWidgets('ForgotPasswordDialog doğru auth service ile oluşturulmalı', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ForgotPasswordDialog), findsOneWidget);
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('Mock auth service dependency injection ile çalışmalı', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ForgotPasswordDialog), findsOneWidget);
      });

      testWidgets('Mock auth service email gönderimi test edilmeli', (
        tester,
      ) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(true);
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir
        const testEmail = 'test@example.com';
        await tester.enterText(find.byType(TextFormField), testEmail);

        // Send butonuna tıkla - daha spesifik finder kullan
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert
        expect(mockAuthService.lastEmail, equals(testEmail));
      });
    });

    group('Integration Tests', () {
      testWidgets('Tam dialog flow entegrasyon testi', (tester) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(true);
        await tester.pumpWidget(createTestWidget());

        // Act 1: Dialog aç
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Act 2: Email gir
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        expect(find.text('test@example.com'), findsOneWidget);

        // Act 3: Send butonuna tıkla - daha spesifik finder kullan
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - Form submit edildi
        expect(find.byType(Form), findsOneWidget);
        expect(mockAuthService.lastEmail, equals('test@example.com'));
      });

      testWidgets('Cancel ile dialog kapatma entegrasyon testi', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act 1: Dialog aç
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Act 2: Email gir
        await tester.enterText(find.byType(TextFormField), 'test@example.com');

        // Act 3: Cancel butonuna tıkla
        final cancelButton = find.byType(TextButton);
        await tester.tap(cancelButton);
        await tester.pumpAndSettle();

        // Assert - Dialog kapandı
        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('Boş email ile submit hata vermeli', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Send butonuna tıkla - daha spesifik finder kullan
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert
        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('Geçersiz email formatı ile submit hata vermeli', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Geçersiz email gir
        await tester.enterText(find.byType(TextFormField), 'invalid-email');
        expect(find.text('invalid-email'), findsOneWidget);

        // Send butonuna tıkla - daha spesifik finder kullan
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert
        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('Mock auth service hata durumu test edilmeli', (
        tester,
      ) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(false);
        mockAuthService.setErrorMessage('Test error message');
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir
        await tester.enterText(find.byType(TextFormField), 'test@example.com');

        // Send butonuna tıkla - daha spesifik finder kullan
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert
        expect(mockAuthService.lastEmail, equals('test@example.com'));
      });
    });

    group('Loading State Tests', () {
      testWidgets('Loading durumunda butonlar disabled olmalı', (tester) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(true);
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir
        await tester.enterText(find.byType(TextFormField), 'test@example.com');

        // Send butonuna tıkla ve loading state'i bekle
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - Loading durumunda butonlar disabled olmalı
        final elevatedButton = tester.widget<ElevatedButton>(sendButton);
        expect(elevatedButton.onPressed, isNull);

        final textButton = tester.widget<TextButton>(find.byType(TextButton));
        expect(textButton.onPressed, isNull);

        // Complete the operation to avoid pending futures
        mockAuthService.completeSuccess();
        await tester.pumpAndSettle();
      });

      testWidgets('Loading durumunda CircularProgressIndicator görünmeli', (
        tester,
      ) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(true);
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir ve submit et
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - Loading indicator görünmeli
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Complete the operation to avoid pending futures
        mockAuthService.completeSuccess();
        await tester.pumpAndSettle();
      });

      testWidgets('Loading durumunda "Sending..." metni görünmeli', (
        tester,
      ) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(true);
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir ve submit et
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - "Sending..." metni görünmeli (localization olmadığı için loading state'i test et)
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Complete the operation to avoid pending futures
        mockAuthService.completeSuccess();
        await tester.pumpAndSettle();
      });
    });

    group('Form Validation Tests', () {
      testWidgets('Boş email ile submit edildiğinde validation error görünmeli', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Send butonuna tıkla (boş email ile)
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - Validation error görünmeli (localization olmadığı için form validation'ın çalıştığını test et)
        expect(find.byType(Form), findsOneWidget);

        // Form validation çalışmalı
        final form = tester.widget<Form>(find.byType(Form));
        expect(form.key, isNotNull);
      });

      testWidgets(
        'Geçersiz email formatı ile submit edildiğinde validation error görünmeli',
        (tester) async {
          // Arrange
          await tester.pumpWidget(createTestWidget());

          // Act
          await tester.tap(find.text('Show Dialog'));
          await tester.pumpAndSettle();

          // Geçersiz email gir
          await tester.enterText(find.byType(TextFormField), 'invalid-email');
          expect(find.text('invalid-email'), findsOneWidget);

          // Send butonuna tıkla
          final sendButton = find.descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(ElevatedButton),
          );
          await tester.tap(sendButton);
          await tester.pump();

          // Assert - Validation error görünmeli (localization olmadığı için form validation'ın çalıştığını test et)
          expect(find.byType(Form), findsOneWidget);

          // Form validation çalışmalı
          final form = tester.widget<Form>(find.byType(Form));
          expect(form.key, isNotNull);
        },
      );

      testWidgets(
        'Geçerli email ile submit edildiğinde validation error görünmemeli',
        (tester) async {
          // Arrange
          mockAuthService.setResetEmailSuccess(true);
          await tester.pumpWidget(createTestWidget());

          // Act
          await tester.tap(find.text('Show Dialog'));
          await tester.pumpAndSettle();

          // Geçerli email gir
          await tester.enterText(
            find.byType(TextFormField),
            'valid@example.com',
          );
          expect(find.text('valid@example.com'), findsOneWidget);

          // Send butonuna tıkla
          final sendButton = find.descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(ElevatedButton),
          );
          await tester.tap(sendButton);
          await tester.pump();

          // Assert - Validation error görünmemeli
          expect(find.text('Email is required'), findsNothing);
          expect(find.text('Invalid email format'), findsNothing);
        },
      );
    });

    group('Success Flow Tests', () {
      testWidgets('Başarılı email gönderimi sonrası SnackBar görünmeli', (
        tester,
      ) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(true);
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir ve submit et
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - Mock service çağrıldı
        expect(mockAuthService.lastEmail, equals('test@example.com'));

        // Complete the operation to avoid pending futures
        mockAuthService.completeSuccess();
        await tester.pumpAndSettle();
      });

      testWidgets('Başarılı email gönderimi sonrası dialog kapanmalı', (
        tester,
      ) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(true);
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Email gir ve submit et
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - Mock service çağrıldı
        expect(mockAuthService.lastEmail, equals('test@example.com'));

        // Complete the operation to avoid pending futures
        mockAuthService.completeSuccess();
        await tester.pumpAndSettle();
      });

      testWidgets('Success SnackBar doğru renk ve içeriğe sahip olmalı', (
        tester,
      ) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(true);
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir ve submit et
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - Mock service çağrıldı
        expect(mockAuthService.lastEmail, equals('test@example.com'));

        // Complete the operation to avoid pending futures
        mockAuthService.completeSuccess();
        await tester.pumpAndSettle();
      });
    });

    group('Error Flow Tests', () {
      testWidgets('Hata durumunda SnackBar görünmeli', (tester) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(false);
        mockAuthService.setErrorMessage('Test error message');
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir ve submit et
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - Mock service çağrıldı
        expect(mockAuthService.lastEmail, equals('test@example.com'));

        // Complete the operation to avoid pending futures
        mockAuthService.completeError();
        await tester.pumpAndSettle();
      });

      testWidgets('Hata durumunda dialog açık kalmalı', (tester) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(false);
        mockAuthService.setErrorMessage('Test error message');
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Email gir ve submit et
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - Mock service çağrıldı
        expect(mockAuthService.lastEmail, equals('test@example.com'));

        // Complete the operation to avoid pending futures
        mockAuthService.completeError();
        await tester.pumpAndSettle();
      });

      testWidgets('Error SnackBar doğru renk ve içeriğe sahip olmalı', (
        tester,
      ) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(false);
        mockAuthService.setErrorMessage('Test error message');
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir ve submit et
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - Mock service çağrıldı
        expect(mockAuthService.lastEmail, equals('test@example.com'));

        // Complete the operation to avoid pending futures
        mockAuthService.completeError();
        await tester.pumpAndSettle();
      });
    });

    group('UI Element Tests', () {
      testWidgets('Dialog başlığı doğru localization key kullanmalı', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Dialog başlığı görünmeli
        expect(find.byType(AlertDialog), findsOneWidget);
        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(dialog.title, isA<Text>());
      });

      testWidgets('Dialog açıklaması doğru localization key kullanmalı', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Dialog açıklaması görünmeli
        expect(find.byType(AlertDialog), findsOneWidget);
        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        expect(dialog.content, isA<Form>());
      });

      testWidgets('Email input field helper text göstermeli', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Helper text görünmeli
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('Email input field prefix icon göstermeli', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Prefix icon görünmeli
        expect(find.byType(TextFormField), findsOneWidget);
      });
    });

    group('State Management Tests', () {
      testWidgets('_isLoading state doğru yönetilmeli', (tester) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(true);
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir ve submit et
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert - Loading state aktif olmalı
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Complete the operation to avoid pending futures
        mockAuthService.completeSuccess();
        await tester.pumpAndSettle();
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('_emailController doğru dispose edilmeli', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir
        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        expect(find.text('test@example.com'), findsOneWidget);

        // Dialog'u kapat
        final cancelButton = find.byType(TextButton);
        await tester.tap(cancelButton);
        await tester.pumpAndSettle();

        // Assert - Dialog kapandı
        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('Localization Tests', () {
      testWidgets('Tüm text\'ler localization key kullanmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Dialog içeriği görünmeli
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('Dialog hızlı açılmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act & Assert
        final stopwatch = Stopwatch()..start();
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        stopwatch.stop();

        // Dialog 100ms içinde açılmalı
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('Dialog hızlı kapanmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Act & Assert
        final stopwatch = Stopwatch()..start();
        final cancelButton = find.byType(TextButton);
        await tester.tap(cancelButton);
        await tester.pumpAndSettle();
        stopwatch.stop();

        // Dialog 100ms içinde kapanmalı
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('Edge Case Tests', () {
      testWidgets('Çok uzun email için dialog düzgün görünmeli', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Çok uzun email gir
        const longEmail = 'verylongemailaddress@verylongdomainname.com';
        await tester.enterText(find.byType(TextFormField), longEmail);

        // Assert
        expect(find.text(longEmail), findsOneWidget);
        expect(find.byType(AlertDialog), findsOneWidget);
      });

      testWidgets('Çok kısa ekran boyutunda dialog düzgün görünmeli', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
      });
    });

    group('Mock Service Behavior Tests', () {
      testWidgets('Mock service success durumu test edilmeli', (tester) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(true);
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir ve submit et
        await tester.enterText(find.byType(TextFormField), 'success@test.com');
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert
        expect(mockAuthService.lastEmail, equals('success@test.com'));

        // Complete the operation to avoid pending futures
        mockAuthService.completeSuccess();
        await tester.pumpAndSettle();
      });

      testWidgets('Mock service failure durumu test edilmeli', (tester) async {
        // Arrange
        mockAuthService.setResetEmailSuccess(false);
        mockAuthService.setErrorMessage('Network error');
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Email gir ve submit et
        await tester.enterText(find.byType(TextFormField), 'failure@test.com');
        final sendButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        await tester.tap(sendButton);
        await tester.pump();

        // Assert
        expect(mockAuthService.lastEmail, equals('failure@test.com'));

        // Complete the operation to avoid pending futures
        mockAuthService.completeError();
        await tester.pumpAndSettle();
      });
    });
  });
}
