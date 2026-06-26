import 'package:flutter_test/flutter_test.dart';
import 'package:ssrvpn_shared/services/unlock_test_service.dart';

void main() {
  group('UnlockTestResult', () {
    test('isPending returns true when status is Pending', () {
      const result = UnlockTestResult(id: 'test', name: 'Test', status: 'Pending');
      expect(result.isPending, isTrue);
      expect(result.isUnlocked, isFalse);
      expect(result.isBlocked, isFalse);
      expect(result.isFailed, isFalse);
    });

    test('isUnlocked returns true when status is Yes', () {
      const result = UnlockTestResult(id: 'test', name: 'Test', status: 'Yes');
      expect(result.isPending, isFalse);
      expect(result.isUnlocked, isTrue);
      expect(result.isBlocked, isFalse);
      expect(result.isFailed, isFalse);
    });

    test('isBlocked handles various blocked statuses', () {
      for (final status in ['No', 'Blocked', 'Unsupported Country/Region', 'No (restricted)']) {
        final result = UnlockTestResult(id: 'test', name: 'Test', status: status);
        expect(result.isBlocked, isTrue, reason: 'status=$status');
      }
    });

    test('isFailed returns true when status starts with Failed', () {
      final result = UnlockTestResult(id: 'test', name: 'Test', status: 'Failed (timeout)');
      expect(result.isFailed, isTrue);
      expect(result.isPending, isFalse);
      expect(result.isBlocked, isFalse);
    });

    test('copyWith updates specified fields', () {
      const original = UnlockTestResult(
        id: 'netflix',
        name: 'Netflix',
        status: 'Pending',
      );
      final updated = original.copyWith(status: 'Yes', region: 'US');
      expect(updated.status, equals('Yes'));
      expect(updated.region, equals('US'));
      expect(updated.id, equals('netflix'));
      expect(updated.name, equals('Netflix'));
    });

    test('copyWith clearDetail removes detail', () {
      const original = UnlockTestResult(
        id: 'test', name: 'Test', status: 'Failed', detail: 'Network error',
      );
      final cleared = original.copyWith(clearDetail: true);
      expect(cleared.detail, isNull);
    });
  });

  group('UnlockTestService', () {
    test('defaultItems contains expected services', () {
      const items = UnlockTestService.defaultItems;
      expect(items.length, equals(10));
      expect(items.map((e) => e.id), containsAll([
        'netflix', 'disney', 'youtube', 'chatgpt-web', 'chatgpt-ios',
        'gemini', 'claude', 'prime-video', 'spotify', 'tiktok',
      ]));
    });

    test('defaultItems all start as Pending', () {
      for (final item in UnlockTestService.defaultItems) {
        expect(item.isPending, isTrue);
      }
    });
  });
}
