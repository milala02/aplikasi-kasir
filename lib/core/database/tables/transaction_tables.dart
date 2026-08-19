import 'package:drift/drift.dart';

class CostLayersTable extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  IntColumn get originalQuantity => integer()();
  IntColumn get remainingQuantity => integer()();
  IntColumn get unitCost => integer()();
  DateTimeColumn get acquiredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class SalesTable extends Table {
  TextColumn get id => text()();
  TextColumn get invoiceNumber => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class SaleItemsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get saleId => text()();
  TextColumn get productId => text()();
  TextColumn get productName => text()();
  TextColumn get unit => text()();
  IntColumn get quantity => integer()();
  IntColumn get unitPrice => integer()();
}
