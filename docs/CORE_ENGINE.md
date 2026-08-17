# WARUNG PINTAR — CORE ENGINE

## 1. Purpose

The Core Engine provides shared primitives and infrastructure
used by all business engines.

It must remain independent from presentation/UI concerns.

---

## 2. Core Components

Initial components:

- Money
- Quantity
- Identifier
- Result
- DomainError
- Validation
- Date/Time abstraction
- Transaction abstraction
- Domain Event abstraction

---

## 3. Money

Money must:

- avoid unsafe floating-point representation
- contain an amount
- contain currency information
- support deterministic arithmetic
- support comparison
- support explicit rounding

Money must not be represented by arbitrary doubles throughout
the domain.

---

## 4. Quantity

Quantity must:

- represent product quantities safely
- support configurable precision
- prevent invalid values
- support arithmetic
- support comparison

The precision rules must be explicit.

---

## 5. Identifier

Domain entities must have stable identifiers.

Identifiers should not depend on display names.

Example:

Product ID
≠
Product Name

A product may change its name without changing its identity.

---

## 6. Result

Application operations should be able to return:

Success
or
Failure

Example:

CreateSale
→ Success(Sale)

or:

CreateSale
→ Failure(InsufficientStock)

---

## 7. Domain Errors

Errors should be explicit and machine-readable.

Examples:

- INVALID_PRODUCT
- INVALID_QUANTITY
- INSUFFICIENT_STOCK
- INVALID_PRICE
- INVALID_PAYMENT
- DUPLICATE_TRANSACTION
- ACCOUNTING_IMBALANCE
- INVALID_STATE
- VALIDATION_ERROR

User-facing messages should be generated separately from
internal error codes.

---

## 8. Validation

Validation must exist at appropriate layers.

Examples:

Input validation
Domain validation
Business rule validation
Database constraint validation

Validation must not rely exclusively on the UI.

---

## 9. Transactions

Critical operations must support atomic execution.

Example:

CompleteSale

must coordinate applicable:

- sale persistence
- payment
- inventory movement
- COGS
- accounting

Failure must prevent an inconsistent partial state.

---

## 10. Domain Events

Domain events may be used to communicate important business
events.

Examples:

- SaleCompleted
- StockReceived
- StockAdjusted
- PurchaseCompleted
- PaymentReceived
- ExpenseRecorded
- JournalPosted

Events must not become an uncontrolled substitute for direct
business logic.

---

## 11. Core Engine Rules

Core components must:

- have no dependency on Flutter UI
- be highly testable
- remain deterministic
- have minimal external dependencies
- avoid business-specific assumptions

---

## 12. Testing Requirements

Core components require extensive unit tests.

Minimum categories:

- normal values
- zero
- negative values
- maximum reasonable values
- rounding
- precision
- invalid input
- overflow/underflow scenarios
- equality
- comparison
- serialization where applicable
