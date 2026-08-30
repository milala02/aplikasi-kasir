import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Pemetaan id/UoM lokal -> UUID deterministik (RFC 4122 v5, SHA-1).
///
/// Backend Go mendeklarasikan field `uuid.UUID` (id, productId,
/// enteredUomId, stockUomId) dan menolak string non-UUID saat parse JSON.
/// Id lokal aplikasi (`ord_...`, `prod_...`, nama Unit) dipetakan ke UUID
/// stabil sehingga payload yang sama selalu menghasilkan id yang sama
/// (dedup `ON CONFLICT (id) DO NOTHING` di backend tetap berfungsi).
class SyncUuid {
  // Namespace tetap aplikasi (arbitrer, konstan di semua perangkat).
  static const _entityNamespace = '7e5f5a1e-3b2f-4c6d-9a8b-1c2d3e4f5a60';
  static const _uomNamespace = '2a7d0c6b-1e4f-4a8d-b3c5-6e7f8a9b0c1d';

  /// UUID entitas (order/produk) dari id lokal. Id yang sudah berformat
  /// UUID (berasal dari backend via pull master data) dilewati apa adanya
  /// agar id tetap stabil di kedua sisi.
  static String entity(String localId) {
    if (_uuidFormat.hasMatch(localId)) {
      return localId;
    }
    return _uuid5(_entityNamespace, localId);
  }

  /// UUID UoM dari nama Unit (mis. `kilogram`).
  static String uom(String unitName) => _uuid5(_uomNamespace, unitName);

  static String _uuid5(String namespace, String name) {
    final hash = sha1.convert([
      ..._hexBytes(namespace),
      ...utf8.encode(name),
    ]).bytes;
    final b = Uint8List.fromList(hash.sublist(0, 16));
    b[6] = (b[6] & 0x0F) | 0x50; // version 5
    b[8] = (b[8] & 0x3F) | 0x80; // variant RFC 4122
    final hex = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  static final RegExp _uuidFormat = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  static List<int> _hexBytes(String uuid) {
    final cleaned = uuid.replaceAll('-', '');
    return [
      for (var i = 0; i < cleaned.length; i += 2)
        int.parse(cleaned.substring(i, i + 2), radix: 16),
    ];
  }
}
