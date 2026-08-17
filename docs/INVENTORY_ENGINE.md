# WARUNG PINTAR — INVENTORY ENGINE

## 1. Purpose

The Inventory Engine is responsible for:

- stock state
- stock movements
- inventory quantity
- inventory costing
- stock validation
- stock adjustments
- inventory valuation

It must not contain Flutter UI logic.

---

## 2. Core Entities

Initial entities:

- Product
- InventoryItem
- StockMovement

Future entities may include:

- StockBatch
- StockOpname
- Warehouse
- InventoryLocation

---

## 3. Product

A product represents an item that can be sold, purchased, or
managed by the business.

A product must have a stable identity.

Historical transactions must continue to reference the same
product identity even if its name or price changes.

---

## 4. InventoryItem

InventoryItem represents the current inventory state of a product.

Conceptual fields:

- id
- productId
- quantity
- averageCost
- updatedAt

InventoryItem is current state.

It is not the complete inventory history.

---

## 5. StockMovement

Every material stock change must generate a StockMovement.

Conceptual fields:

- id
- productId
- type
- quantity
- unitCost
- totalCost
- referenceType
- referenceId
- createdAt

StockMovement provides historical traceability.

---

## 6. Movement Types

Initial movement types:

- PURCHASE
- SALE
- SALE_RETURN
- PURCHASE_RETURN
- ADJUSTMENT_IN
- ADJUSTMENT_OUT
- DAMAGE
- OPNAME

Movement direction must be determined by the movement type.

The UI must not arbitrarily choose positive or negative values
without validation.

---

## 7. Stock In

Examples:

- purchase
- customer return
- positive adjustment
- stock opname increase

Stock quantity increases.

The movement must be recorded.

---

## 8. Stock Out

Examples:

- sale
- supplier return
- damage
- negative adjustment
- stock opname decrease

Stock quantity decreases.

The system must reject stock-out operations that violate the
configured negative-stock policy.

---

## 9. Negative Stock

Default policy:

Negative stock is prohibited.

Example:

Current stock = 5

Requested sale = 6

Result:

REJECT

Error:

INSUFFICIENT_STOCK

No partial sale should be created.

---

## 10. Weighted Average Cost

For incoming inventory:

New Average Cost
=
(Existing Quantity × Existing Average Cost
+
Incoming Quantity × Incoming Unit Cost)
/
(New Quantity)

Example:

Existing:

10 × Rp10,000 = Rp100,000

Incoming:

20 × Rp12,000 = Rp240,000

New:

30 units
Rp340,000 total cost

Average Cost:

Rp340,000 / 30
≈ Rp11,333.33

---

## 11. Outgoing Inventory

For a normal sale:

COGS
=
Outgoing Quantity × Current Average Cost

Example:

Current Average Cost = Rp11,333.33

Sale = 5

COGS
≈ Rp56,666.65

The exact result depends on the internal precision and rounding
policy defined by the costing implementation.

---

## 12. Costing Invariant

Inventory quantity and inventory value must remain internally
consistent.

After every valid inventory transaction:

- quantity must be valid
- inventory value must be explainable
- average cost must be valid
- movement history must be recorded

---

## 13. Inventory Value

Conceptually:

Inventory Value
=
Current Quantity × Current Average Cost

The exact implementation must account for the chosen internal
precision strategy.

---

## 14. Stock Adjustment

Stock adjustment requires:

- product
- quantity change
- reason
- user
- timestamp

Adjustment must generate a movement.

---

## 15. Stock Opname

Stock opname compares:

System Quantity
vs
Physical Quantity

Variance:

Physical Quantity - System Quantity

If variance exists, the system creates an appropriate movement.

The original system quantity must remain auditable.

---

## 16. Historical Integrity

Historical stock movements must not be silently modified.

Corrections should create corrective movements.

Posted historical inventory transactions should remain auditable.

---

## 17. References

A stock movement may reference its originating business event.

Examples:

SALE
→ Sale ID

PURCHASE
→ Purchase ID

ADJUSTMENT
→ Adjustment ID

This allows the inventory history to be traced back to its
business source.

---

## 18. Atomicity

Inventory-changing operations must be atomic.

Example:

Complete Sale

must not produce:

Sale = success
Stock = failure

or:

Stock = success
Sale = failure

The business transaction must succeed completely or fail safely.

---

## 19. Idempotency

Inventory-changing commands must prevent accidental duplicate
execution.

Retrying the same business command must not accidentally
create duplicate stock movements.

---

## 20. Validation

Inventory commands must validate:

- product exists
- product is eligible
- quantity is valid
- stock policy
- costing data
- reference validity
- duplicate transaction prevention

---

## 21. Testing

The Inventory Engine must have tests for:

- initial stock
- purchase
- multiple purchases
- sale
- multiple sales
- sale with insufficient stock
- return
- adjustment
- damage
- stock opname
- weighted average calculation
- zero quantity
- invalid quantity
- rounding
- duplicate command
- historical integrity
