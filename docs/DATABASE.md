# WARUNG PINTAR — DATABASE DESIGN

## 1. Database Goals

The local database must provide:

- data integrity
- transactional consistency
- offline operation
- deterministic financial data
- auditability
- migration support
- backup and restore support
- scalability

Initial database target:

SQLite-compatible local database.

---

## 2. Database Principles

### Source Data vs Derived Data

Source data includes:

- sales
- purchases
- expenses
- payments
- inventory movements
- journal entries

Derived data includes:

- revenue summaries
- profit
- margins
- inventory valuation
- analytics
- charts
- forecasts

Derived values must not become conflicting sources of truth.

---

## 3. Money Representation

Financial values must not use floating-point values as the
authoritative representation.

Use integer-based monetary representation using the smallest
relevant currency unit.

For Indonesian Rupiah:

Rp12,500

may be represented internally as:

12500

A dedicated Money value object should be used by the domain layer.

---

## 4. Core Data

Initial conceptual entities:

- Business
- User
- Role
- Permission
- Setting
- AuditLog

---

## 5. Catalog

Initial conceptual entities:

- Product
- Category
- Unit
- ProductVariant
- PriceHistory

---

## 6. Inventory

Initial conceptual entities:

- InventoryItem
- StockMovement
- StockAdjustment
- StockOpname
- StockBatch

Inventory quantity must be explainable through movement history.

The system should be able to determine why current stock has its
current value.

---

## 7. Sales

Initial conceptual entities:

- Sale
- SaleItem
- Payment
- Return
- ReturnItem

A completed sale may affect:

- revenue
- inventory
- COGS
- payment
- accounting
- analytics

Critical effects must be performed transactionally.

---

## 8. Purchasing

Initial conceptual entities:

- Supplier
- PurchaseOrder
- Purchase
- PurchaseItem
- SupplierPayment

Purchasing may affect:

- inventory
- accounts payable
- cash/bank
- accounting
- cost basis

---

## 9. Accounting

The accounting system must support double-entry bookkeeping.

Core entities:

- Account
- JournalEntry
- JournalEntryLine

Accounting invariant:

Total Debits = Total Credits

A journal entry must never be posted if the debit and credit
totals do not balance.

---

## 10. Financial Management

Initial conceptual entities:

- Expense
- CashAccount
- FinancialTransaction
- Receivable
- Payable

Financial records must have clear relationships with accounting
records where applicable.

---

## 11. Budgeting

Initial conceptual entities:

- Budget
- BudgetItem
- Target
- Plan

Budget analysis should support:

Budget
vs
Actual
vs
Variance

---

## 12. Relationships

Conceptual relationship examples:

Business
→ Users

Product
→ Category
→ Unit

Product
→ Inventory

Sale
→ SaleItems
→ Product

Purchase
→ PurchaseItems
→ Product

JournalEntry
→ JournalEntryLines
→ Account

---

## 13. Transactions

Critical business operations must use database transactions.

Example:

Sale

must atomically handle applicable:

- sale record
- sale items
- payment
- inventory movement
- COGS
- accounting entries

The system must avoid partially completed transactions.

---

## 14. Inventory Movement

Inventory should be movement-based.

Example:

Purchase: +100
Sale: -10
Damage: -2
Adjustment: +1

Current quantity:

89

The current stock must be explainable from valid movements.

---

## 15. Audit Trail

Important operations should generate audit records.

Audit information may include:

- user
- action
- entity
- entity ID
- timestamp
- previous state
- new state
- reason
- context

Audit logs are supplementary records and must not replace the
primary business transaction records.

---

## 16. Database Migrations

Schema changes must use versioned migrations.

Example:

v1
→ v2
→ v3
→ v4

Migrations must be:

- deterministic
- tested
- reversible where practical
- safe for existing user data

Never modify production schema without a migration strategy.

---

## 17. Indexing

Indexes should be introduced based on actual query requirements.

Likely candidates include:

- product identifiers
- barcode
- transaction dates
- stock/product relationships
- journal dates
- account relationships

Avoid unnecessary indexes because they increase write cost
and database size.

---

## 18. Deletion Policy

Critical financial records should generally not be physically
deleted after posting.

Use appropriate states such as:

- draft
- posted
- cancelled
- reversed

Corrections should preserve historical integrity.

---

## 19. Backup

Backup must include:

- database
- schema version
- required metadata

Restore operations must validate database integrity.

A backup must not be reported as successful until its creation
has been verified.

---

## 20. Security

Sensitive data should be protected appropriately.

Database access must occur through controlled application
components.

Database credentials or secrets must never be hardcoded into
source code.

---

## 21. Schema Development Rule

This document describes the conceptual database.

Exact SQL schema should only be implemented after the related
domain model and business rules have been reviewed.

Do not prematurely create hundreds of tables.

Build incrementally around validated business requirements.
