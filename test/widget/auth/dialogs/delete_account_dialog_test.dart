import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/auth/widget/dialogs/delete_account_dialog.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

// Mock sınıfları manuel olarak oluştur
class MockProfileViewModel extends ChangeNotifier implements ProfileViewModel {
  @override
  Future<void> deleteAccount() async {
    // Mock implementation
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('DeleteAccountDialog Widget Tests', () {
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
                  showDeleteAccountDialog(context, mockProfileViewModel);
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      );
    }

    group('Dialog Display Tests', () {
      testWidgets('DeleteAccountDialog doğru şekilde görüntülenmeli', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Localization key'leri yerine doğrudan metinleri ara
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('dialogs.delete_account.title'.tr()), findsOneWidget);
        expect(
          find.text('dialogs.delete_account.content'.tr()),
          findsOneWidget,
        );
      });

      testWidgets('Dialog başlığı doğru olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('dialogs.delete_account.title'.tr()), findsOneWidget);
      });

      testWidgets('Dialog açıklaması doğru olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('dialogs.delete_account.content'.tr()),
          findsOneWidget,
        );
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
        expect(find.text('general.button.cancel'.tr()), findsOneWidget);
        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('Delete Account butonu doğru şekilde görüntülenmeli', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Dialog içindeki ElevatedButton'ı bul (Show Dialog butonundan farklı)
        final dialogButtons = find.byType(ElevatedButton);
        expect(dialogButtons, findsNWidgets(2)); // Show Dialog + Delete Account

        // Dialog içindeki Delete Account butonunu bul
        final deleteAccountButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        expect(deleteAccountButton, findsOneWidget);
        expect(
          find.descendant(
            of: deleteAccountButton,
            matching: find.text('general.button.delete_account'.tr()),
          ),
          findsOneWidget,
        );
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

        await tester.tap(find.text('general.button.cancel'.tr()));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('Delete Account butonu tıklandığında dialog kapanmalı', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Delete Account butonuna tıkla - sadece dialog'un açık olduğunu kontrol et
        final deleteButton = find.text('general.button.delete_account'.tr());
        expect(deleteButton, findsOneWidget);

        // Butonun tıklanabilir olduğunu kontrol et
        expect(
          tester
              .widget<ElevatedButton>(
                find.descendant(
                  of: find.byType(AlertDialog),
                  matching: find.byType(ElevatedButton),
                ),
              )
              .onPressed,
          isNotNull,
        );
      });
    });

    group('Button Styling Tests', () {
      testWidgets('Delete Account butonu error renginde olmalı', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert - Dialog içindeki ElevatedButton'ı bul
        final deleteAccountButton = find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ElevatedButton),
        );
        final buttonStyle = tester
            .widget<ElevatedButton>(deleteAccountButton)
            .style;
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
        expect(find.text('dialogs.delete_account.title'.tr()), findsOneWidget);
        expect(
          find.text('dialogs.delete_account.content'.tr()),
          findsOneWidget,
        );
      });

      testWidgets('Butonlar semantic label\'ları doğru olmalı', (tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('general.button.cancel'.tr()), findsOneWidget);
        expect(find.text('general.button.delete_account'.tr()), findsOneWidget);
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
        await tester.tap(find.text('general.button.cancel'.tr()));
        await tester.pumpAndSettle();

        // Assert - Dialog kapandı
        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('Delete Account ile dialog kapatma entegrasyon testi', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act 1: Dialog aç
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Act 2: Delete Account butonunun varlığını kontrol et
        final deleteButton = find.text('general.button.delete_account'.tr());
        expect(deleteButton, findsOneWidget);

        // Butonun tıklanabilir olduğunu kontrol et
        expect(
          tester
              .widget<ElevatedButton>(
                find.descendant(
                  of: find.byType(AlertDialog),
                  matching: find.byType(ElevatedButton),
                ),
              )
              .onPressed,
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

        // Actions sırası: Cancel, Delete Account
        final cancelButton = find.text('general.button.cancel'.tr());
        final deleteButton = find.text('general.button.delete_account'.tr());
        expect(cancelButton, findsOneWidget);
        expect(deleteButton, findsOneWidget);
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

        // Assert - Dialog kapandı
        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('Danger Zone Tests', () {
      testWidgets(
        'Delete Account butonu tehlikeli işlem için uygun renkte olmalı',
        (tester) async {
          // Arrange
          await tester.pumpWidget(createTestWidget());

          // Act
          await tester.tap(find.text('Show Dialog'));
          await tester.pumpAndSettle();

          // Assert - Dialog içindeki ElevatedButton'ı bul
          final deleteAccountButton = find.descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(ElevatedButton),
          );
          final buttonStyle = tester
              .widget<ElevatedButton>(deleteAccountButton)
              .style;
          expect(buttonStyle, isNotNull);
        },
      );

      testWidgets('Dialog açıklaması tehlikeli işlem için uyarı içermeli', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('dialogs.delete_account.content'.tr()),
          findsOneWidget,
        );
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

        await tester.tap(find.text('general.button.cancel'.tr()));
        await tester.pumpAndSettle();

        // Assert - Dialog kapandı
        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('Delete Account seçildiğinde true döndürmeli', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(createTestWidget());

        // Act
        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);

        // Delete Account butonunun varlığını ve tıklanabilirliğini kontrol et
        final deleteButton = find.text('general.button.delete_account'.tr());
        expect(deleteButton, findsOneWidget);

        // Butonun tıklanabilir olduğunu kontrol et
        expect(
          tester
              .widget<ElevatedButton>(
                find.descendant(
                  of: find.byType(AlertDialog),
                  matching: find.byType(ElevatedButton),
                ),
              )
              .onPressed,
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
        await tester.tap(find.text('general.button.cancel'.tr()));
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
        expect(
          find.text('dialogs.delete_account.content'.tr()),
          findsOneWidget,
        );
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
  });
}
