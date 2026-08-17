# WARUNG PINTAR — BUSINESS RULES

## 1. Purpose

This document defines the business rules that govern the
application.

Business rules are authoritative.

Implementation must follow these rules unless this document
is intentionally changed.

---

# 2. GENERAL TRANSACTION PRINCIPLES

Every business transaction follows:

Input
→ Validation
→ Business Rules
→ Transaction
→ State Changes
→ Accounting
→ Audit

Critical operations must be atomic.

A transaction must not leave the system in a partially completed
state.

---

# 3. PRODUCT RULES

A product must have:

- unique internal identity
- product name
- unit
- active/inactive state

Optional:

- barcode
- SKU
- category
- variant
- description
- brand
- supplier

Inactive products must not appear in normal new sales unless
explicitly allowed by the business rule.

Historical transactions must continue to reference products that
were previously used.

---

# 4. PRODUCT PRICE RULES

A product may have:

- purchase cost
- selling price
- wholesale price
- promotional price
- member price

Prices must have a defined effective period when historical
pricing is important.

Changing the current selling price must not rewrite historical
transaction prices.

A sale must store the actual price used at the time of sale.

---

# 5. QUANTITY RULES

Quantities must be validated.

A quantity must:

- be greater than zero for normal additions
- support fractional quantities where the product unit allows it
- use a consistent precision
- never silently overflow or truncate

Quantity calculations must be deterministic.

---

# 6. SALES RULES

A sale consists conceptually of:

- sale header
- sale items
- pricing
- discount
- tax where applicable
- payment
- inventory effects
- accounting effects

A completed sale must preserve the actual:

- product
- quantity
- unit price
- discount
- tax
- total
- payment method

used at the time of the transaction.

Historical sales must not change when product prices change later.

---

# 7. SALE VALIDATION

Before completing a sale:

1. Sale must contain at least one item.
2. Every item must reference a valid product.
3. Quantity must be valid.
4. Price must be valid.
5. Discounts must be valid.
6. Total must be recalculated by the application.
7. Payment must satisfy the payment rules.
8. Required stock conditions must be satisfied.
9. Accounting effects must be valid.

The application must calculate totals.

It must not blindly trust totals supplied by the UI.

---

# 8. SALES TOTAL

Conceptually:

Subtotal
= sum(item quantity × effective unit price)

Discount
= valid discount amount

Tax
= applicable tax

Total
= Subtotal - Discount + Tax

The exact taxation model must be defined before tax functionality
is implemented.

Rounding rules must be deterministic.

---

# 9. INVENTORY RULE

Inventory is movement-based.

Stock changes must generate stock movements.

Examples:

Purchase
→ positive movement

Sale
→ negative movement

Return
→ positive or negative depending on direction

Damage
→ negative movement

Adjustment
→ positive or negative movement

Stock must not be silently changed without an explainable
business event.

---

# 10. STOCK NEGATIVE POLICY

The system must have an explicit policy for negative stock.

Default policy:

Negative stock is not allowed.

A sale that would make stock negative must be rejected.

Future configuration may allow negative stock for specific
business scenarios, but this must be explicit.

---

# 11. STOCK ADJUSTMENT

Stock adjustment requires:

- product
- quantity change
- reason
- timestamp
- responsible user

Important adjustments should generate audit records.

Example:

Current stock: 50

Damaged: 5

New stock: 45

The system must preserve why the change occurred.

---

# 12. STOCK OPNAME

Stock opname compares:

System Quantity
vs
Physical Quantity

Variance:

Physical Quantity - System Quantity

The resulting adjustment must be recorded as a stock movement.

The reason must be recorded.

---

# 13. INVENTORY COST

Inventory cost must be traceable.

The system must retain sufficient information to determine
inventory valuation and COGS.

The exact costing method must be explicitly selected and
documented before production accounting implementation.

Potential methods include:

- FIFO
- Weighted Average
- Specific Identification

The implementation must not mix costing methods accidentally.

---

# 14. HPP / COGS

HPP means cost of goods sold.

Conceptually:

Revenue
- COGS
=
Gross Profit

COGS must be determined by the selected inventory costing method.

HPP must not simply be assumed to equal the latest purchase price.

---

# 15. REVENUE

Revenue must reflect the applicable completed sale transaction.

Revenue recognition rules must be documented separately for:

- normal sales
- returns
- discounts
- refunds
- credit sales

---

# 16. PAYMENT RULES

Supported payment methods may include:

- Cash
- Bank Transfer
- E-wallet
- Card
- Credit
- Other configured methods

Payment amount must be validated.

For a fully paid sale:

Payment
= required amount

For cash:

Change
= Payment - Total

Negative change is not valid.

---

# 17. PARTIAL PAYMENT

If partial payments are supported:

Paid
< Total

creates an outstanding balance.

Outstanding:

Total - Paid

The remaining balance must be traceable.

---

# 18. CREDIT SALES

A credit sale must:

- record the sale
- record the receivable
- record applicable inventory effects
- record applicable accounting effects

When the customer pays later:

Receivable decreases
Cash/Bank increases

The original sale must remain historically unchanged.

---

# 19. SALES RETURN

A sales return must not simply delete the original sale.

The original transaction remains.

A return creates a new corrective transaction.

Potential effects:

- inventory
- revenue reversal
- refund
- receivable
- COGS reversal
- accounting

The exact return rules depend on the condition of the returned
goods.

---

# 20. PURCHASE RULES

A purchase may affect:

- inventory
- supplier payable
- cash/bank
- inventory cost
- accounting

Purchase price must be stored historically.

Changing supplier pricing later must not modify previous purchases.

---

# 21. SUPPLIER PAYABLE

If a purchase is unpaid:

Purchase
→ Accounts Payable

When payment occurs:

Accounts Payable decreases
Cash/Bank decreases

The original purchase remains unchanged.

---

# 22. EXPENSE RULES

Expenses must contain enough information for reporting.

Potential fields:

- amount
- category
- date
- payment account
- description
- attachment/reference
- responsible user

Expenses must be reflected in appropriate financial records.

---

# 23. ACCOUNTING RULE

The accounting engine uses double-entry bookkeeping.

Every posted journal entry must satisfy:

Total Debits = Total Credits

A journal entry that does not balance must never be posted.

---

# 24. ACCOUNTING EXAMPLE — CASH SALE

Example:

Selling price: Rp10,000
HPP: Rp7,000

Revenue:

Debit:
Cash Rp10,000

Credit:
Revenue Rp10,000

COGS:

Debit:
COGS Rp7,000

Credit:
Inventory Rp7,000

Gross Profit:

Rp10,000 - Rp7,000 = Rp3,000

---

# 25. ACCOUNTING EXAMPLE — CREDIT SALE

Example:

Sale: Rp10,000
HPP: Rp7,000

Revenue:

Debit:
Accounts Receivable Rp10,000

Credit:
Revenue Rp10,000

COGS:

Debit:
COGS Rp7,000

Credit:
Inventory Rp7,000

When customer pays:

Debit:
Cash/Bank Rp10,000

Credit:
Accounts Receivable Rp10,000

---

# 26. DISCOUNTS

Discounts must be explicit.

The system must distinguish between:

- item discount
- transaction discount
- promotional discount

Historical transaction records must preserve the actual discount
applied.

Discounts must never cause unintended negative totals.

---

# 27. REFUNDS

A refund must reference the original transaction.

The system must not delete the original transaction to represent
a refund.

Refund effects may include:

- cash/bank decrease
- revenue reversal
- inventory increase
- COGS reversal
- receivable adjustment

---

# 28. BUDGETING

Budget values represent planned amounts.

Actual values come from recorded business/financial transactions.

Variance:

Actual - Budget

The system must distinguish:

- favorable variance
- unfavorable variance

The exact interpretation depends on whether the metric is
revenue, expense, profit, or another measure.

---

# 29. FINANCIAL PERIOD

Financial reports should support date ranges.

Examples:

- Today
- This Week
- This Month
- Previous Month
- This Year
- Custom Period

Reports must use explicit date/time boundaries.

---

# 30. AUDITABILITY

Important operations must be traceable.

Examples:

- price changes
- stock adjustments
- refunds
- transaction cancellation
- accounting corrections
- user permission changes
- financial record changes

Historical posted financial transactions should not be silently
overwritten.

Corrections should use reversal or adjustment mechanisms where
appropriate.

---

# 31. POSTING AND REVERSAL

Important financial transactions should have lifecycle states.

Example:

Draft
→ Posted
→ Reversed

Posted transactions should not be edited in a way that destroys
historical accounting integrity.

Corrections should preserve the audit trail.

---

# 32. IDEMPOTENCY

Critical operations should be designed to prevent accidental
duplicate processing.

For example:

A payment request must not create two payments because the
operation was retried.

Where appropriate, transactions should have unique identifiers
or idempotency keys.

---

# 33. ERROR HANDLING

Business errors must be explicit.

Examples:

- insufficient stock
- invalid quantity
- invalid payment
- duplicate transaction
- invalid accounting entry
- invalid product
- invalid price

Errors must not silently produce incorrect data.

---

# 34. DATA INTEGRITY

The following invariants are mandatory:

1. Posted journal entries balance.
2. Critical transactions are atomic.
3. Inventory movements are traceable.
4. Historical prices remain historically correct.
5. Posted financial transactions are not silently overwritten.
6. Money calculations are deterministic.
7. Duplicate critical operations are prevented.
8. Audit records are preserved where required.

---

# 35. RULE CHANGE POLICY

Business rules may evolve.

When a rule changes:

1. Document the change.
2. Determine impact on existing data.
3. Update tests.
4. Update documentation.
5. Implement migration if required.
6. Review affected engines.

AI agents must not silently change business rules.
