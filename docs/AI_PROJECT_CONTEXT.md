# APLIKASI KASIR — AI PROJECT CONTEXT

## 1. PROJECT IDENTITY

Nama proyek: Aplikasi Kasir

Nama internal/target produk: Warung Pintar

Warung Pintar adalah aplikasi Android local-first untuk membantu
warung dan toko kecil hingga menengah mengelola operasional,
penjualan, stok, keuangan, perencanaan, dan analisis bisnis.

Aplikasi ini BUKAN hanya aplikasi kasir.

Target jangka panjang mencakup:

- Point of Sale (POS)
- Inventory Management
- Product Management
- Purchasing
- Supplier Management
- Customer Management
- Accounting
- Financial Management
- Budgeting
- Business Planning
- Analytics
- Reporting
- Forecasting
- Business Intelligence
- Backup & Recovery
- Security
- AI-assisted business analysis
- Optional cloud synchronization
- Optional payment integration
- Optional barcode integration
- Optional printer integration

Prinsip utama:

> Complex inside, simple outside.

Sistem internal harus kuat dan akurat.

UI harus sederhana, modern, cepat, dan mudah dipahami oleh
pemilik warung yang tidak memiliki latar belakang teknis atau
akuntansi.

---

## 2. PRODUCT VISION

Aplikasi dimulai sebagai:

- Android
- Local-first
- Offline-capable
- Single-business capable

Arsitektur harus memungkinkan perkembangan menjadi:

- Multiple users
- Multiple devices
- Cloud synchronization
- Multiple branches
- Advanced analytics
- AI assistance

Core business operation tidak boleh bergantung pada internet.

Internet hanya diperlukan untuk fitur yang memang membutuhkan
internet, seperti:

- AI API
- Cloud backup
- Synchronization
- Payment gateway
- External APIs
- Application updates

---

## 3. TARGET SCALE

Jangan membangun sistem sebagai disposable prototype.

Arsitektur harus mampu berkembang dari:

1 warung
→ 1 perangkat
→ banyak transaksi
→ banyak pengguna
→ banyak perangkat
→ cloud synchronization
→ multi-branch

Target akhir secara kualitas adalah gabungan:

POS + Inventory + Accounting + Finance + Planning +
Analytics + Business Intelligence.

Sistem harus tetap mudah digunakan meskipun internalnya kompleks.

---

## 4. TECHNOLOGY DIRECTION

Target platform:

- Android

Primary framework:

- Flutter
- Dart

Local database:

- SQLite-compatible database

Development environment:

- Termux
- Linux userspace jika diperlukan
- Git
- GitLab

CI/CD:

- GitLab CI/CD
- GitLab Runner

Heavy operations seperti full testing, Android build,
release build, dan security scanning sebaiknya dilakukan
oleh CI/CD, bukan mengandalkan RAM perangkat Android.

---

## 5. DEVELOPMENT PHILOSOPHY

Prioritas:

1. Correctness
2. Data integrity
3. Business logic
4. Testability
5. Security
6. Maintainability
7. Performance
8. UX
9. Visual polish

Jangan mengejar kecepatan coding dengan mengorbankan
integritas sistem.

Jangan membuat shortcut yang akan menyebabkan rewrite besar
di kemudian hari.

---

## 6. ARCHITECTURE DIRECTION

Gunakan modular layered architecture.

Target konsep:

Presentation
↓
Application
↓
Domain / Business Engine
↓
Repository
↓
Data
↓
Local Database

UI tidak boleh langsung mengakses database.

UI tidak boleh mengandung business logic penting.

Business calculations harus berada di domain/business layer.

Database access harus melalui repository/data abstraction.

---

## 7. MAJOR ENGINES

Target sistem akan memiliki:

### Core

- Configuration
- Database
- Migration
- Logging
- Error Handling
- Validation
- Security
- Backup
- Recovery
- Audit

### Business

- Product Engine
- Inventory Engine
- Sales Engine
- Purchasing Engine
- Supplier Engine
- Customer Engine
- Pricing Engine
- Accounting Engine
- Finance Engine
- Budget Engine
- Planning Engine
- Analytics Engine
- Forecasting Engine
- Reporting Engine

### Intelligence

- Recommendation
- Anomaly Detection
- AI Assistant

### Infrastructure

- Import / Export
- Backup
- Cloud Sync
- Barcode
- Printer
- Payment Integration

---

## 8. FINANCIAL DATA RULE

Financial calculations are critical.

Jangan menggunakan floating point secara sembarangan untuk
nilai uang.

Gunakan representasi uang yang deterministik dan konsisten.

Semua financial calculation harus memiliki:

- clear formula
- defined rounding rules
- deterministic result
- unit tests
- edge-case tests

Contoh konsep:

Cost
+
related cost
=
Cost Basis

Selling Price
-
Cost Basis
=
Gross Profit

---

## 9. ACCOUNTING REQUIREMENTS

Accounting engine harus dirancang dengan benar.

Target:

- Chart of Accounts
- Double-entry bookkeeping
- Journal Entries
- General Ledger
- Accounts Payable
- Accounts Receivable
- Cash
- Bank
- Inventory
- Revenue
- COGS / HPP
- Expenses
- Assets
- Liabilities
- Equity
- Profit & Loss
- Balance Sheet
- Cash Flow

Transaksi bisnis harus dapat menghasilkan accounting
entries secara konsisten.

Accounting logic tidak boleh ditulis langsung di UI.

---

## 10. INVENTORY REQUIREMENTS

Target:

- Products
- Categories
- Units
- Variants
- Stock
- Stock Movements
- Stock Adjustments
- Stock Opname
- Minimum Stock
- Safety Stock
- Reorder Point
- Batch
- Expiration
- Damaged Stock
- Stock Valuation
- Cost History
- Inventory History

Sistem harus mampu menjawab:

- Berapa stok saat ini?
- Berapa nilai stok?
- Berapa HPP?
- Produk mana yang cepat terjual?
- Produk mana yang lambat?
- Kapan harus restock?

---

## 11. POS REQUIREMENTS

Target:

- Product search
- Barcode
- Cart
- Quantity
- Discount
- Tax
- Payment methods
- Cash
- Transfer
- Customer credit
- Refund
- Return
- Receipt
- Transaction history

Conceptual transaction flow:

Sale
↓
Inventory Movement
↓
COGS
↓
Revenue
↓
Payment
↓
Accounting
↓
Analytics

---

## 12. PURCHASING REQUIREMENTS

Target:

- Supplier
- Purchase Order
- Purchase Receiving
- Purchase Invoice
- Supplier Debt
- Supplier Payment
- Purchase History
- Price History
- Supplier Comparison

---

## 13. PRICING ENGINE

Target calculations:

- Cost
- HPP
- Markup
- Margin
- Recommended Price
- Wholesale Price
- Member Price
- Promotional Price
- Discount Impact
- Profit Simulation

Pricing formulas must be documented and tested.

---

## 14. BUDGETING

Target:

- Daily Budget
- Weekly Budget
- Monthly Budget
- Annual Budget
- Purchasing Budget
- Operational Budget
- Marketing Budget
- Payroll Budget
- Capital Expenditure Budget

Core comparison:

Budget
vs
Actual
vs
Variance

---

## 15. PLANNING

Target:

- Sales Targets
- Profit Targets
- Cash Targets
- Purchasing Plans
- Inventory Plans
- Expansion Plans
- Financial Goals
- Scenario Planning

Example scenario:

"If sales increase by 20%, how much additional working
capital may be required?"

---

## 16. ANALYTICS

Target metrics:

- Revenue
- Transactions
- Average Transaction Value
- Gross Profit
- Net Profit
- Gross Margin
- Expenses
- Cash Flow
- Inventory Value
- Inventory Turnover
- Stock Aging
- Fast-moving Products
- Slow-moving Products
- Dead Stock
- Best-selling Products
- Most Profitable Products
- Customer Metrics
- Supplier Metrics

Every metric must have a documented definition.

---

## 17. CALCULATION ENGINE

Important calculations must be isolated from UI.

Examples:

- Margin Calculator
- Markup Calculator
- HPP Calculator
- Profit Calculator
- Break-even Calculator
- Cash Flow Calculator
- Budget Variance
- Inventory Turnover
- Reorder Point
- Safety Stock
- Forecast Calculations

Every important calculation requires tests.

---

## 18. GRAPHICS AND REPORTING

The application should eventually provide:

- Revenue charts
- Profit charts
- Expense charts
- Cash flow charts
- Sales by category
- Sales by product
- Inventory movement
- Budget vs Actual
- Target vs Actual
- Customer growth
- Supplier spending

Charts should consume validated data from the analytics layer.

UI charts must not independently implement business calculations.

---

## 19. FORECASTING

Future capability:

- Sales Forecast
- Inventory Forecast
- Cash Forecast
- Profit Forecast
- Restocking Forecast

Forecast output must distinguish:

- historical facts
- calculated metrics
- assumptions
- predictions

Predictions must never be presented as guaranteed facts.

---

## 20. AI ASSISTANT

AI is NOT the source of truth.

AI must not directly manipulate accounting or critical financial
data without validated application commands.

Preferred flow:

Database
↓
Business Engine
↓
Validated Metrics
↓
AI
↓
Recommendation / Explanation

Possible AI features:

- Business analysis
- Metric explanation
- Trend analysis
- Restock suggestions
- Budget variance explanation
- Report summaries
- Business recommendations
- Natural-language business questions

---

## 21. SECURITY

Target:

- Authentication
- PIN/password
- Role-based access
- Permissions
- Session management
- Audit logs
- Secure storage
- Sensitive data protection
- Backup protection

Potential roles:

- Owner
- Admin
- Manager
- Cashier
- Inventory Staff

---

## 22. BACKUP AND RECOVERY

Target:

- Manual backup
- Automatic backup
- Restore
- Backup validation
- Database integrity checking
- Import
- Export

Never report a backup as successful unless the operation
has been verified.

---

## 23. UI / UX

UI must be:

- Modern
- Clean
- Intuitive
- Fast
- Responsive
- Accessible
- Mobile-first

Principle:

> Complex inside, simple outside.

Advanced accounting and analytics should not overwhelm ordinary
users.

Use progressive disclosure.

Example:

Instead of immediately showing only:

"Inventory Turnover: 8.2x"

The UI may show:

"Perputaran Stok
8.2x
Stok berputar cukup cepat."

Advanced details remain available.

---

## 24. TESTING

Testing is a first-class requirement.

### Unit Tests

Required for:

- Calculations
- Financial logic
- Inventory logic
- Pricing
- Budgeting
- Forecasting
- Accounting

### Integration Tests

Required for critical flows:

- Database
- Repository
- Services
- Sales → Inventory
- Purchase → Inventory
- Sales → Accounting
- Purchase → Accounting

### UI Tests

Required for critical user flows.

### Regression Tests

Every important bug must receive a regression test.

---

## 25. CI/CD STRATEGY

The Android device should not be the primary heavy build machine.

Local device:

- Coding
- Git
- Formatting
- Lightweight analysis
- Lightweight unit tests

GitLab CI/CD:

- Full tests
- Integration tests
- Database tests
- Security checks
- Flutter build
- APK build
- AAB build
- Release validation

Pipeline should be optimized to conserve CI compute minutes.

Do not perform expensive release builds for every small commit.

---

## 26. AI COLLABORATION

### ChatGPT

Primary:

- Architecture
- System design
- Domain modeling
- Business rules
- Accounting design
- Database design
- Task decomposition
- Difficult debugging
- Architectural review
- Cross-module consistency

### Gemini

Primary:

- Implementation
- Boilerplate
- Repetitive coding
- Unit tests
- Refactoring
- Documentation
- Localized debugging

### GitLab Duo

Primary:

- Repository-aware development
- Issue planning
- Merge requests
- CI/CD
- Code review
- Security analysis
- Agent workflows

All AI systems must follow this project context.

No AI may silently redesign architecture.

---

## 27. SOURCE OF TRUTH

The GitLab repository is the project source of truth.

Chat conversations are not the permanent source of truth.

Important architectural decisions must be documented.

Before making a major change, AI must check:

- AI_PROJECT_CONTEXT.md
- ARCHITECTURE.md
- DATABASE.md
- BUSINESS_RULES.md
- CODING_RULES.md
- TESTING_RULES.md
- ROADMAP.md

If information is missing:

DO NOT GUESS.

Identify the ambiguity before making an architectural decision.

---

## 28. CURRENT PHASE

CURRENT PHASE:

PHASE 0 — FOUNDATION

Current objectives:

1. Repository setup
2. Project documentation
3. AI collaboration rules
4. Git workflow
5. CI/CD foundation
6. Development environment
7. Flutter verification
8. Android toolchain verification

After Phase 0:

PHASE 1 — CORE ENGINE

Only after the foundation is verified should major application
development begin.

---

## 29. GOLDEN RULE

Build small.

Test everything.

Integrate carefully.

Never compromise data integrity.

Never guess when an architectural decision is unclear.

Never remove tests to hide failures.

Never make unrelated changes.

The long-term objective is a production-quality business system,
not merely an application that compiles.
