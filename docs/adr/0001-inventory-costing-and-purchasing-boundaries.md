# ADR-0001: Inventory Costing and Purchasing Boundaries

- Status: Accepted
- Date: 2026-08-18

## Context

The application currently contains purchasing and inventory domains with
separate repositories and domain services.

CostLayer and CostLayerService currently live under Purchasing, even though
their responsibility is inventory valuation and cost consumption.

The purchasing model also currently represents purchasing as a single
Purchase aggregate. Future architecture must distinguish the commercial
supplier document from the physical receipt of inventory.

A purchase invoice may contain the same product more than once. Therefore,
productId alone must not be used as the domain identity of a purchase line.

## Decisions

### 1. Costing belongs to Inventory

CostLayer, CostLayerRepository, and CostLayerService belong to the
Inventory/Costing boundary rather than Purchasing.

Purchasing may provide acquisition/receipt information, but it does not own
inventory valuation.

### 2. Duplicate products are allowed on one invoice

A purchase document may contain multiple lines referring to the same
product.

Purchase line identity must therefore include a stable lineNumber in
addition to its technical identifier.

The invariant is:

- lineNumber is unique within one purchase document;
- lineNumber preserves the physical invoice order;
- productId may repeat across different lines.

### 3. Purchasing and physical receiving are separate concepts

The future purchasing model will distinguish:

- Purchase Order (PO)
- Goods Receipt (GR/GRN)
- Purchase Invoice

A supplier invoice does not automatically imply that all invoiced goods
were physically received.

### 4. Inventory receipt creates physical stock

Goods Receipt will be the business operation responsible for recognizing
physically received inventory.

Receipt processing will eventually create stock movements and cost layers.

### 5. Historical inventory records are append-oriented

Historical StockMovement records and acquisition-cost history must not be
silently rewritten.

Corrections will use reversal, adjustment, or return operations.

### 6. Cross-domain atomicity is a future application concern

Operations involving multiple repositories or bounded contexts will
eventually execute through a Unit of Work / transaction boundary.

This ADR does not implement Unit of Work.

## Consequences

Positive:

- Purchasing no longer owns inventory valuation.
- Inventory costing can evolve independently.
- Duplicate invoice lines remain representable without merging unrelated
  business facts.
- Partial deliveries can be represented correctly in the future.
- The architecture can later support 3-way matching between PO, Goods Receipt,
  and Purchase Invoice.

Negative:

- Some existing files must move.
- Import paths must change.
- The future purchasing model will require additional domain objects.
- Unit of Work and persistence transactions remain future work.

## Implementation Strategy

The first implementation step is intentionally behavior-preserving:

1. Move CostLayer and its repository/service into Inventory/Costing.
2. Move the related tests.
3. Update imports only.
4. Run Dart analysis and the existing Dart test suite.
5. Commit the refactor separately.

No PurchaseUseCases, GoodsReceipt, SQLite/Drift, UI, or Unit of Work
implementation is included in this step.

## Explicitly Deferred

- PurchaseUseCases
- GoodsReceipt implementation
- PurchaseInvoice implementation
- Unit of Work
- SQLite/Drift persistence
- synchronization
- accounting journal
- UI
