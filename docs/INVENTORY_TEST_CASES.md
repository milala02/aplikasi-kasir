# WARUNG PINTAR — INVENTORY TEST CASES

## TC-001 Initial Purchase

Initial stock:

0

Purchase:

10 units × Rp10,000

Expected:

Quantity = 10
Average Cost = Rp10,000
Inventory Value = Rp100,000

---

## TC-002 Second Purchase

Initial:

10 units
Average Cost = Rp10,000

Purchase:

20 units × Rp12,000

Expected:

Quantity = 30

Total inventory cost:

Rp100,000 + Rp240,000
= Rp340,000

Average Cost:

Rp340,000 / 30
≈ Rp11,333.33

---

## TC-003 Sale

Current:

30 units
Average Cost ≈ Rp11,333.33

Sale:

5 units

Expected:

Quantity = 25

COGS must be based on the current weighted average cost.

---

## TC-004 Insufficient Stock

Current:

5 units

Attempt:

Sell 6

Expected:

Failure

Error:

INSUFFICIENT_STOCK

Expected quantity:

5

No sale movement should be committed.

---

## TC-005 Damage

Current:

20 units

Damage:

3

Expected:

Quantity = 17

Movement:

DAMAGE

---

## TC-006 Positive Adjustment

Current:

20

Physical count discovers:

22

Adjustment:

+2

Expected:

Quantity = 22

Movement:

ADJUSTMENT_IN

Reason required.

---

## TC-007 Negative Adjustment

Current:

20

Physical count:

17

Adjustment:

-3

Expected:

Quantity = 17

Movement:

ADJUSTMENT_OUT

Reason required.

---

## TC-008 Zero Quantity

Attempt:

Purchase 0

Expected:

Failure

No inventory state change.

---

## TC-009 Negative Quantity

Attempt:

Purchase -5

Expected:

Failure

No inventory state change.

---

## TC-010 Duplicate Operation

Submit the same purchase command twice using the same
idempotency identifier.

Expected:

Only one inventory operation is committed.

---

## TC-011 Historical Price Change

Product selling price changes from:

Rp10,000

to:

Rp12,000

Expected:

Previous sales retain Rp10,000.

New sales use Rp12,000.

---

## TC-012 Historical Cost Integrity

Previous inventory movements must not be silently rewritten when
new purchase costs arrive.

The costing engine must preserve historical transaction integrity.

---

## TC-013 Atomic Failure

A transaction that fails validation must not partially modify:

- inventory quantity
- inventory value
- stock movement history

---

## TC-014 Multiple Purchases

Purchases:

10 × Rp10,000
20 × Rp12,000
30 × Rp15,000

Expected average cost must be calculated from total quantity
and total cost according to the defined weighted-average rules.

---

## TC-015 Full Stock Sale

Current:

30 units

Sale:

30 units

Expected:

Quantity = 0

Inventory value = 0

No invalid negative quantity.

---

## TC-016 Sale After Replenishment

Inventory reaches:

0

Then:

Purchase 10 × Rp20,000

Expected:

Quantity = 10

Average Cost = Rp20,000

---

## TC-017 Return

A valid customer return must:

- increase inventory when the returned item is eligible for resale
- create the appropriate stock movement
- apply the correct costing/accounting rules

Return behavior for damaged/non-resalable goods must be handled
by an explicit business rule.

---

## TC-018 Rounding

Weighted average calculations must be deterministic.

The same input data must always produce the same result.

Rounding must not cause unexplained inventory value discrepancies.

