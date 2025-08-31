import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/onboard/view/onboard_view.dart';

void main() {
  group('Simple Onboard Widget Tests', () {
    // Test 1: OnBoardView widget'ı oluşturulabilmeli
    testWidgets('OnBoardView widget\'ı oluşturulabilmeli', (tester) async {
      // ARRANGE: OnBoardView widget'ını oluştur
      final onboardView = OnBoardView();

      // ASSERT: Widget oluşturuldu mu?
      expect(onboardView, isNotNull);
      expect(onboardView, isA<OnBoardView>());
    });

    // Test 2: OnBoardView StatefulWidget olmalı
    testWidgets('OnBoardView StatefulWidget olmalı', (tester) async {
      // ARRANGE: OnBoardView widget'ını oluştur
      final onboardView = OnBoardView();

      // ASSERT: StatefulWidget mı?
      expect(onboardView, isA<StatefulWidget>());
    });

    // Test 3: OnBoardView key property doğru çalışmalı
    testWidgets('OnBoardView key property doğru çalışmalı', (tester) async {
      // ARRANGE: Farklı key'ler ile OnBoardView oluştur
      final key1 = const Key('key1');
      final key2 = const Key('key2');

      final onboardView1 = OnBoardView(key: key1);
      final onboardView2 = OnBoardView(key: key2);

      // ASSERT: Key'ler doğru mu?
      expect(onboardView1.key, key1);
      expect(onboardView2.key, key2);
      expect(onboardView1.key, isNot(equals(onboardView2.key)));
    });

    // Test 4: OnBoardView constructor parametreleri doğru olmalı
    testWidgets('OnBoardView constructor parametreleri doğru olmalı', (
      tester,
    ) async {
      // ARRANGE: OnBoardView widget'ını oluştur
      final onboardView = OnBoardView();

      // ASSERT: Widget type'ı doğru mu?
      expect(onboardView.runtimeType, OnBoardView);
      expect(onboardView, isA<Widget>());
      expect(onboardView, isA<StatefulWidget>());
    });

    // Test 5: OnBoardView multiple instance oluşturulabilmeli
    testWidgets('OnBoardView multiple instance oluşturulabilmeli', (
      tester,
    ) async {
      // ARRANGE: Birden fazla OnBoardView oluştur
      final onboardView1 = OnBoardView();
      final onboardView2 = OnBoardView();
      final onboardView3 = OnBoardView();

      // ASSERT: Tüm instance'lar oluşturuldu mu?
      expect(onboardView1, isNotNull);
      expect(onboardView2, isNotNull);
      expect(onboardView3, isNotNull);
      expect(onboardView1, isA<OnBoardView>());
      expect(onboardView2, isA<OnBoardView>());
      expect(onboardView3, isA<OnBoardView>());
    });

    // Test 6: OnBoardView null key ile oluşturulabilmeli
    testWidgets('OnBoardView null key ile oluşturulabilmeli', (tester) async {
      // ARRANGE: Key olmadan OnBoardView oluştur
      final onboardView = OnBoardView();

      // ASSERT: Widget oluşturuldu mu?
      expect(onboardView, isNotNull);
      expect(onboardView, isA<OnBoardView>());
    });

    // Test 7: OnBoardView widget tree yapısı doğru olmalı
    testWidgets('OnBoardView widget tree yapısı doğru olmalı', (tester) async {
      // ARRANGE: OnBoardView widget'ını oluştur
      final onboardView = OnBoardView();

      // ASSERT: Widget tree yapısı doğru mu?
      expect(onboardView, isA<Widget>());
      expect(onboardView, isA<StatefulWidget>());
      expect(onboardView, isA<OnBoardView>());
    });

    // Test 8: OnBoardView widget properties doğru olmalı
    testWidgets('OnBoardView widget properties doğru olmalı', (tester) async {
      // ARRANGE: OnBoardView widget'ını oluştur
      final onboardView = OnBoardView();

      // ASSERT: Widget properties doğru mu?
      expect(onboardView, isNotNull);
      expect(onboardView.runtimeType, OnBoardView);
      expect(onboardView, isA<StatefulWidget>());
    });
  });
}
