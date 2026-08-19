import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/transaction_tables.dart';

part 'transaction_database.g.dart';

@DriftDatabase(tables: [CostLayersTable, SalesTable, SaleItemsTable])
class TransactionDatabase extends _$TransactionDatabase {
  TransactionDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'transactions.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
