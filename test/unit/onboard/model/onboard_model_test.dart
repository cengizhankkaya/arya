import 'package:arya/features/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnboardModel Test', () {
    test('OnboardModel constructor tüm alanalrı doğru set etmeli', () {
      final model = OnboardModel('Test Title', 'Test Description', 'test.json');

      expect(model.title, 'Test Title');
      expect(model.description, 'Test Description');
      expect(model.lottiePath, 'test.json');
    });

    test('OnboardModel lottiePath optional olmalı', () {
      final model = OnboardModel('Title', 'Description', null);
      expect(model.title, 'Title');
      expect(model.description, 'Description');
      expect(model.lottiePath, isNull);
    });
  });
}
