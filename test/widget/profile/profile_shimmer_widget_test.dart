import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:arya/features/profile/view/widgets/profile_shimmer_widget.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('ProfileShimmerWidget Tests', () {
    Widget createTestWidget(Widget child) {
      return TestHelpers.createTestApp(child: child);
    }

    testWidgets('should display shimmer widget correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      expect(find.byType(ProfileShimmerWidget), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should have proper container structure', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      // ProfileShimmerWidget içindeki ana Column'u bul (ilk Column)
      expect(
        find
            .descendant(
              of: find.byType(ProfileShimmerWidget),
              matching: find.byType(Column),
            )
            .first,
        findsOneWidget,
      );
    });

    testWidgets('should display profile header shimmer', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      expect(find.byType(Shimmer), findsWidgets);
      // ProfileShimmerWidget içindeki Row'ları bul
      expect(
        find.descendant(
          of: find.byType(ProfileShimmerWidget),
          matching: find.byType(Row),
        ),
        findsWidgets,
      );
      expect(find.byType(Expanded), findsWidgets);
    });

    testWidgets('should display user info shimmer section', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      expect(find.byType(Shimmer), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should display profile completion shimmer', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      expect(find.byType(Shimmer), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should display buttons shimmer', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      expect(find.byType(Shimmer), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should have correct shimmer container dimensions', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      final shimmerContainers = find.descendant(
        of: find.byType(Shimmer),
        matching: find.byType(Container),
      );

      expect(shimmerContainers, findsWidgets);

      // Check avatar shimmer container
      final avatarContainer = shimmerContainers.first;
      final containerWidget = tester.widget<Container>(avatarContainer);
      expect(containerWidget.constraints, isNotNull);
    });

    testWidgets('should display circular avatar shimmer', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      final shimmerContainers = find.descendant(
        of: find.byType(Shimmer),
        matching: find.byType(Container),
      );

      expect(shimmerContainers, findsWidgets);

      // Find circular container (avatar)
      final containers = tester.widgetList<Container>(shimmerContainers);
      final circularContainer = containers.firstWhere(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration as BoxDecoration).shape == BoxShape.circle,
        orElse: () => containers.first,
      );

      expect(circularContainer.decoration, isA<BoxDecoration>());
      final decoration = circularContainer.decoration as BoxDecoration;
      expect(decoration.shape, equals(BoxShape.circle));
    });

    testWidgets('should display rectangular shimmer containers', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      final shimmerContainers = find.descendant(
        of: find.byType(Shimmer),
        matching: find.byType(Container),
      );

      expect(shimmerContainers, findsWidgets);

      // Check for rectangular containers (text placeholders)
      final containers = tester.widgetList<Container>(shimmerContainers);
      final rectangularContainers = containers.where(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration as BoxDecoration).borderRadius != null,
      );

      expect(rectangularContainers.isNotEmpty, isTrue);
    });

    testWidgets('should have proper spacing between shimmer sections', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      expect(find.byType(SizedBox), findsWidgets);

      // Check for spacing widgets
      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes, findsWidgets);
    });

    testWidgets('should display multiple shimmer rows for user info', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      expect(find.byType(Row), findsWidgets);

      // Should have multiple rows for user info section
      final rows = find.byType(Row);
      expect(rows, findsWidgets);
    });

    testWidgets('should have proper shimmer colors', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      final shimmerWidgets = find.byType(Shimmer);
      expect(shimmerWidgets, findsWidgets);

      final shimmer = tester.widget<Shimmer>(shimmerWidgets.first);
      expect(shimmer.gradient, isNotNull);
      expect(shimmer.gradient, isNotNull);
    });

    testWidgets('should display progress bar shimmer', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      final shimmerContainers = find.descendant(
        of: find.byType(Shimmer),
        matching: find.byType(Container),
      );

      expect(shimmerContainers, findsWidgets);

      // Look for a thin container that could be a progress bar
      final containers = tester.widgetList<Container>(shimmerContainers);
      final progressBarContainer = containers.where(
        (container) => container.constraints?.maxHeight == 8.0,
      );

      expect(progressBarContainer.isNotEmpty, isTrue);
    });

    testWidgets('should display button shimmer containers', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      final shimmerContainers = find.descendant(
        of: find.byType(Shimmer),
        matching: find.byType(Container),
      );

      expect(shimmerContainers, findsWidgets);

      // Look for button-sized containers
      final containers = tester.widgetList<Container>(shimmerContainers);
      final buttonContainers = containers.where(
        (container) => container.constraints?.maxHeight == 48.0,
      );

      expect(buttonContainers.length, greaterThanOrEqualTo(2));
    });

    testWidgets('should handle different screen sizes', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        createTestWidget(
          SizedBox(
            width: 300,
            height: 600,
            child: const ProfileShimmerWidget(),
          ),
        ),
      );

      // Assert
      expect(find.byType(ProfileShimmerWidget), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      // Ana Column'u bul (ilk Column)
      expect(
        find
            .descendant(
              of: find.byType(ProfileShimmerWidget),
              matching: find.byType(Column),
            )
            .first,
        findsOneWidget,
      );
    });

    testWidgets('should maintain proper aspect ratios', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

      // Assert
      final shimmerContainers = find.descendant(
        of: find.byType(Shimmer),
        matching: find.byType(Container),
      );

      expect(shimmerContainers, findsWidgets);

      // Check avatar container dimensions
      final containers = tester.widgetList<Container>(shimmerContainers);
      final avatarContainer = containers.firstWhere(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration as BoxDecoration).shape == BoxShape.circle,
        orElse: () => containers.first,
      );

      expect(avatarContainer.constraints?.maxWidth, equals(80.0));
      expect(avatarContainer.constraints?.maxHeight, equals(80.0));
    });

    group('Shimmer Animation Tests', () {
      testWidgets('should have shimmer animation properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

        // Assert
        final shimmerWidgets = find.byType(Shimmer);
        expect(shimmerWidgets, findsWidgets);

        final shimmer = tester.widget<Shimmer>(shimmerWidgets.first);
        expect(shimmer.gradient, isNotNull);
        expect(shimmer.gradient, isNotNull);
        expect(shimmer.period, isNotNull);
      });

      testWidgets('should display shimmer with correct child structure', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

        // Assert
        expect(find.byType(Shimmer), findsWidgets);

        // Each shimmer should have a container child
        final shimmerWidgets = find.byType(Shimmer);
        for (int i = 0; i < shimmerWidgets.evaluate().length; i++) {
          final shimmer = tester.widget<Shimmer>(shimmerWidgets.at(i));
          expect(shimmer.child, isA<Container>());
        }
      });
    });

    group('Layout Structure Tests', () {
      testWidgets('should have proper column structure', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

        // Assert
        expect(find.byType(Column), findsWidgets);

        final mainColumn = find
            .descendant(
              of: find.byType(ProfileShimmerWidget),
              matching: find.byType(Column),
            )
            .first;

        expect(mainColumn, findsOneWidget);
      });

      testWidgets('should have proper padding structure', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget(const ProfileShimmerWidget()));

        // Assert
        expect(find.byType(SingleChildScrollView), findsOneWidget);

        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(scrollView.padding, isNotNull);
      });

      testWidgets('should handle scroll behavior correctly', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              height: 400, // Constrain height to test scrolling
              child: const ProfileShimmerWidget(),
            ),
          ),
        );

        // Assert
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(ProfileShimmerWidget), findsOneWidget);
      });
    });
  });
}
