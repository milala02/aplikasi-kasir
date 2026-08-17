# WARUNG PINTAR — ARCHITECTURE

## 1. Architectural Goal

Warung Pintar uses a modular layered architecture designed for:

- correctness
- testability
- maintainability
- scalability
- local-first operation
- financial data integrity

The architecture must support future expansion without requiring
a complete rewrite.

---

## 2. High-Level Architecture

Presentation
↓
Application
↓
Domain
↓
Business Engines
↓
Repositories
↓
Data / Database

Presentation must never directly access the database.

Business logic must not be implemented inside UI widgets.

---

## 3. Layers

### Presentation

Responsible for:

- UI
- screens
- widgets
- navigation
- user interaction
- displaying validated state

Presentation must not contain critical business calculations.

### Application

Responsible for:

- use cases
- commands
- queries
- orchestration
- application workflows

### Domain

Responsible for:

- entities
- value objects
- domain rules
- invariants
- business concepts

Domain logic must remain independent from Flutter UI.

### Business Engines

Responsible for business capabilities:

- Product
- Inventory
- Sales
- Purchasing
- Supplier
- Customer
- Pricing
- Accounting
- Finance
- Budget
- Planning
- Analytics

Each engine should have clearly defined responsibilities and
interfaces.

### Repository Layer

Responsible for abstracting data access.

Business logic should depend on repository contracts rather than
direct database implementation.

### Data Layer

Responsible for:

- SQLite
- local persistence
- database models
- migrations
- caching
- serialization

---

## 4. Transaction Principle

A business transaction may affect multiple domains.

Example:

Sale
→ Sales
→ Inventory
→ Payment
→ Revenue
→ COGS
→ Accounting
→ Analytics

Critical operations must be atomic.

The system must not leave partially completed business
transactions.

---

## 5. Domain Objects

### Entities

Examples:

- Product
- Sale
- Purchase
- Customer
- Supplier
- Account
- JournalEntry
- InventoryItem

### Value Objects

Examples:

- Money
- Quantity
- Percentage
- DateRange
- ProductCode

Value objects must enforce their own invariants where appropriate.

---

## 6. Commands and Queries

Commands modify application state.

Examples:

- CreateSale
- AddProduct
- ReceivePurchase
- AdjustStock
- CreateBudget
- RecordExpense
- PaySupplier

Queries read application state.

Examples:

- GetProduct
- GetStock
- GetSales
- GetProfit
- GetCashFlow
- GetBudgetVariance

The distinction should remain clear throughout the system.

---

## 7. Financial Integrity

Financial operations must be deterministic.

Money must not rely on unsafe floating-point calculations.

Accounting calculations must be isolated, documented, and tested.

Important financial operations require:

- unit tests
- edge-case tests
- regression tests

---

## 8. Dependency Direction

Dependencies should point toward stable business abstractions.

Presentation
→ Application
→ Domain / Engines
→ Repository Contracts
→ Data Implementation

Lower-level implementation details must not control the domain.

---

## 9. Target Project Structure

lib/
├── core/
├── domain/
├── application/
├── engines/
├── data/
└── presentation/

Target engine modules:

engines/
├── product/
├── inventory/
├── sales/
├── purchasing/
├── supplier/
├── customer/
├── pricing/
├── accounting/
├── finance/
├── budget/
├── planning/
└── analytics/

This structure is a target and must be implemented incrementally.

---

## 10. Development Rule

Do not implement the entire architecture at once.

Build incrementally.

Each module must be:

1. designed
2. implemented
3. tested
4. integrated
5. documented

before moving to dependent modules.

---

## 11. Architectural Change Rule

Major architectural changes must be documented.

No AI agent may silently replace the architecture.

If an implementation conflicts with this document, the conflict
must be identified before changing the architecture.
