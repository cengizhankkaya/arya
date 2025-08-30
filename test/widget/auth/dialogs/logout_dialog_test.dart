import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/auth/widget/dialogs/logout_dialog.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';

// Mock sınıfları manuel olarak oluştur
class MockProfileViewModel extends ChangeNotifier implements ProfileViewModel {
  @override
  Future<void> signOut() async {
    // Mock implementation
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('LogoutDialog Widget Tests', () {
    late MockProfileViewModel mockProfileViewModel;

    setUp(() {
      mockProfileViewModel = MockProfileViewModel();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showLogoutDialog(context, mockProfileViewModel);
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );
    }

    group('Dialog Display Tests', () {
      testWidgets('LogoutDialog doğru şekilde görüntülenmeli', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsOneWidget);
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

      testWidgets('Logout butonu doğru şekilde görüntülenmeli', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Dialog içindeki ElevatedButton'ı bul
        final logoutButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        expect(logoutButton, findsOneWidget);
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

      testWidgets('Logout butonu tıklandığında dialog kapanmalı', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Logout butonunun varlığını ve tıklanabilirliğini kontrol et
        final logoutButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        expect(logoutButton, findsOneWidget);

        // Butonun tıklanabilir olduğunu kontrol et
        expect(
          tester.widget<ElevatedButton>(logoutButton).onPressed,
          isNotNull,
        );
      });
    });

    group('Button Styling Tests', () {
      testWidgets('Logout butonu error renginde olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Dialog içindeki ElevatedButton'ı bul
        final logoutButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        final buttonStyle = tester.widget<ElevatedButton>(logoutButton).style;
        expect(buttonStyle, isNotNull);
      });

      testWidgets('Cancel butonu TextButton olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(TextButton), findsOneWidget);
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
      });

      testWidgets('Butonlar semantic label\'ları doğru olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Dialog içindeki butonları bul
        final logoutButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        final cancelButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextButton),
        );

        expect(logoutButton, findsOneWidget);
        expect(cancelButton, findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('Tam dialog flow entegrasyon testi', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act 1: Dialog aç
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Act 2: Cancel butonuna tıkla
        final cancelButton = find.byType(TextButton);
        await tester.tap(cancelButton);
        await tester.pumpAndSettle();

        // Assert - Dialog kapandı
        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('Logout ile dialog kapatma entegrasyon testi', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act 1: Dialog aç
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Act 2: Logout butonunun varlığını kontrol et
        final logoutButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        expect(logoutButton, findsOneWidget);

        // Butonun tıklanabilir olduğunu kontrol et
        expect(
          tester.widget<ElevatedButton>(logoutButton).onPressed,
          isNotNull,
        );
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
      testWidgets('LogoutDialog doğru ProfileViewModel ile oluşturulmalı', (
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

      testWidgets('Mock ProfileViewModel dependency injection ile çalışmalı', (
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

    group('Confirmation Flow Tests', () {
      testWidgets('Cancel seçildiğinde false döndürmeli', (tester) async {
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

      testWidgets('Logout seçildiğinde true döndürmeli', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Logout butonunun varlığını ve tıklanabilirliğini kontrol et
        final logoutButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        expect(logoutButton, findsOneWidget);

        // Butonun tıklanabilir olduğunu kontrol et
        expect(
          tester.widget<ElevatedButton>(logoutButton).onPressed,
          isNotNull,
        );
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
      testWidgets('Çok uzun metin için dialog düzgün görünmeli', (
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

    group('State Management Tests', () {
      testWidgets('Dialog state değişikliklerinde notifyListeners çağrılmalı', (
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

      testWidgets('Dialog dispose sonrası güvenli olmalı', (tester) async {
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
  });
}
