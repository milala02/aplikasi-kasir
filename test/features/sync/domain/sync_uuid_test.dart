import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_kasir/features/sync/domain/sync_uuid.dart';

void main() {
  group('SyncUuid', () {
    test('entity: id lokal dipetakan deterministik (UUIDv5)', () {
      final a = SyncUuid.entity('ord_1');
      final b = SyncUuid.entity('ord_1');

      expect(a, b);
      expect(a, isNot('ord_1'));
      expect(
        a,
        matches(RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-5[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')),
      );
      expect(SyncUuid.entity('ord_2'), isNot(a));
    });

    test('entity: id berformat UUID (berasal dari backend) dilewati '
        'apa adanya', () {
      const backendUuid = '550e8400-e29b-41d4-a716-446655440000';
      expect(SyncUuid.entity(backendUuid), backendUuid);
    });

    test('uom: nama unit dipetakan deterministik', () {
      expect(SyncUuid.uom('kilogram'), SyncUuid.uom('kilogram'));
      expect(SyncUuid.uom('kilogram'), isNot(SyncUuid.uom('gram')));
      expect(SyncUuid.uom('kilogram'), isNot(SyncUuid.entity('kilogram')));
    });
  });
}
