import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../products/domain/product.dart';
import '../../products/domain/product_repository.dart';
import '../domain/purchase.dart';
import '../domain/purchase_item.dart';
import '../domain/purchase_repository.dart';

class PurchasingScreen extends StatefulWidget {
  final PurchaseRepository purchaseRepository;
  final ProductRepository productRepository;

  const PurchasingScreen({
    super.key,
    required this.purchaseRepository,
    required this.productRepository,
  });

  @override
  State<PurchasingScreen> createState() => _PurchasingScreenState();
}

class _PurchasingScreenState extends State<PurchasingScreen> {
  List<Purchase> _purchases = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final purchases = await widget.purchaseRepository.getAll()
        ..sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));

      if (!mounted) return;

      setState(() {
        _purchases = purchases;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat pesanan pembelian: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _purchases.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 12),
                      const Text('Belum ada pesanan pembelian.',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _openCreateDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Buat Pesanan Baru'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _purchases.length,
                  itemBuilder: (context, index) {
                    final p = _purchases[index];
                    final total = p.totalCost;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: const Icon(Icons.receipt, color: Colors.blue),
                        ),
                        title: Text(p.referenceNumber ?? p.id,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${p.items.length} item · ${DateFormat('d MMM yyyy').format(p.purchasedAt)}'),
                        trailing: Text(
                          'Rp ${NumberFormat('#,###').format(total.minorUnits ~/ 100)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,
        tooltip: 'Buat Pesanan Pembelian',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openCreateDialog() {
    final products = widget.productRepository.getAll();
    showDialog(
      context: context,
      builder: (ctx) => _CreatePurchaseDialog(
        products: products,
        onSave: (purchase) async {
          await widget.purchaseRepository.save(purchase);
          await _refresh();
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dialog: Buat Pesanan Pembelian
// ---------------------------------------------------------------------------
class _CreatePurchaseDialog extends StatefulWidget {
  final List<Product> products;
  final Future<void> Function(Purchase) onSave;

  const _CreatePurchaseDialog({required this.products, required this.onSave});

  @override
  State<_CreatePurchaseDialog> createState() => _CreatePurchaseDialogState();
}

class _CreatePurchaseDialogState extends State<_CreatePurchaseDialog> {
  final _refController = TextEditingController();
  Product? _selectedProduct;
  final _qtyController = TextEditingController(text: '1');
  final _priceController = TextEditingController();

  final List<PurchaseItem> _items = [];

  @override
  void dispose() {
    _refController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_selectedProduct == null) return;
    final qty = int.tryParse(_qtyController.text) ?? 0;
    final price = int.tryParse(_priceController.text) ?? 0;
    if (qty <= 0 || price < 0) return;

    setState(() {
      _items.add(PurchaseItem(
        id: 'pi_${DateTime.now().microsecondsSinceEpoch}',
        productId: _selectedProduct!.id,
        quantity: Quantity(value: qty, scale: 0),
        unit: _selectedProduct!.baseUnit,
        unitCost: Money(
            minorUnits: price * 100, // Rp → minor units (persen)
            currency: 'IDR'),
      ));
      _selectedProduct = null;
      _qtyController.text = '1';
      _priceController.clear();
    });
  }

  Future<void> _save() async {
    if (_items.isEmpty) return;

    final purchase = Purchase(
      id: 'po_${DateTime.now().millisecondsSinceEpoch}',
      purchasedAt: DateTime.now(),
      referenceNumber: _refController.text.trim().isEmpty
          ? null
          : _refController.text.trim(),
      items: _items,
    );

    try {
      await widget.onSave(purchase);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal menyimpan pesanan pembelian: $e'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Buat Pesanan Pembelian'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nomor referensi
            TextField(
              controller: _refController,
              decoration: const InputDecoration(
                labelText: 'No. Referensi / Invoice Supplier (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tambah Item:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Pilih produk
            DropdownButtonFormField<Product>(
              key: ValueKey(_selectedProduct),
              initialValue: _selectedProduct,
              hint: const Text('Pilih Produk'),
              items: widget.products.map((p) {
                return DropdownMenuItem(value: p, child: Text(p.name));
              }).toList(),
              onChanged: (p) => setState(() => _selectedProduct = p),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Jumlah', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Harga/Satuan (Rp)',
                        border: OutlineInputBorder()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue),
                  onPressed: _addItem,
                  tooltip: 'Tambah ke Daftar',
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_items.isNotEmpty) ...[
              const Divider(),
              const Text('Daftar Item:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...(_items.map((item) => ListTile(
                    dense: true,
                    title: Text(item.productId),
                    subtitle: Text(
                        '${item.quantity.value} × Rp ${item.unitCost.minorUnits ~/ 100}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => setState(() => _items.remove(item)),
                    ),
                  ))),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _items.isEmpty ? null : _save,
          child: const Text('Simpan Pesanan'),
        ),
      ],
    );
  }
}
