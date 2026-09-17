import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/errors/domain_error.dart';
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../../core/result/result.dart';
import '../../products/domain/product.dart';
import '../../products/domain/product_repository.dart';
import '../../purchasing/domain/purchase.dart';
import '../../purchasing/domain/purchase_repository.dart';
import '../application/receive_goods_use_case.dart';
import '../domain/receiving.dart';
import '../domain/receiving_repository.dart';

class ReceivingScreen extends StatefulWidget {
  final ReceivingRepository receivingRepository;
  final PurchaseRepository purchaseRepository;
  final ProductRepository productRepository;
  final ReceiveGoodsUseCase receiveGoodsUseCase;

  const ReceivingScreen({
    super.key,
    required this.receivingRepository,
    required this.purchaseRepository,
    required this.productRepository,
    required this.receiveGoodsUseCase,
  });

  @override
  State<ReceivingScreen> createState() => _ReceivingScreenState();
}

class _ReceivingScreenState extends State<ReceivingScreen> {
  List<Receiving> _receivings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final receivings = await widget.receivingRepository.getAll()
        ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));

      if (!mounted) return;

      setState(() {
        _receivings = receivings;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat penerimaan barang: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _receivings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inventory_outlined,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 12),
                      const Text('Belum ada penerimaan barang.',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _openReceiveDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Catat Penerimaan Baru'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _receivings.length,
                  itemBuilder: (context, index) {
                    final r = _receivings[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade50,
                          child: const Icon(Icons.move_to_inbox,
                              color: Colors.green),
                        ),
                        title: Text(
                            'Penerimaan #${r.id.substring(r.id.length > 8 ? r.id.length - 8 : 0)}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${r.items.length} item · ${DateFormat('d MMM yyyy').format(r.receivedAt)}\nDari PO: ${r.purchaseId}'),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openReceiveDialog,
        tooltip: 'Catat Penerimaan Barang',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openReceiveDialog() async {
    final List<Purchase> purchases;
    try {
      purchases = await widget.purchaseRepository.getAll();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat daftar PO: $e')),
      );
      return;
    }

    final products = widget.productRepository.getAll();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => _ReceiveGoodsDialog(
        purchases: purchases,
        products: products,
        onSave: (receiving) async {
          final result = await widget.receiveGoodsUseCase.execute(receiving);

          if (!mounted) return;
          if (result is Failure) {
            final error = result.error;
            final message =
                error is DomainError ? error.message : error.toString();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ));
          } else {
            await _refresh();

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Penerimaan barang berhasil dicatat!'),
              backgroundColor: Colors.green,
            ));
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dialog: Catat Penerimaan Barang
// ---------------------------------------------------------------------------
class _ReceiveGoodsDialog extends StatefulWidget {
  final List<Purchase> purchases;
  final List<Product> products;
  final void Function(Receiving) onSave;

  const _ReceiveGoodsDialog(
      {required this.purchases, required this.products, required this.onSave});

  @override
  State<_ReceiveGoodsDialog> createState() => _ReceiveGoodsDialogState();
}

class _ReceiveGoodsDialogState extends State<_ReceiveGoodsDialog> {
  Purchase? _selectedPurchase;
  Product? _selectedProduct;
  final _qtyController = TextEditingController(text: '1');
  final _priceController = TextEditingController();

  final List<ReceivingItem> _items = [];

  @override
  void dispose() {
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
      _items.add(ReceivingItem(
        id: 'ri_${DateTime.now().microsecondsSinceEpoch}',
        productId: _selectedProduct!.id,
        quantityReceived: Quantity(value: qty, scale: 0),
        unit: _selectedProduct!.baseUnit,
        unitCost: Money(minorUnits: price * 100, currency: 'IDR'),
      ));
      _selectedProduct = null;
      _qtyController.text = '1';
      _priceController.clear();
    });
  }

  void _save() {
    if (_items.isEmpty || _selectedPurchase == null) return;

    final receiving = Receiving(
      id: 'recv_${DateTime.now().millisecondsSinceEpoch}',
      purchaseId: _selectedPurchase!.id,
      items: _items,
      receivedAt: DateTime.now(),
    );
    widget.onSave(receiving);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Catat Penerimaan Barang'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pilih PO terkait
            if (widget.purchases.isEmpty)
              const Text(
                'Belum ada Pesanan Pembelian. Buat PO terlebih dahulu.',
                style: TextStyle(color: Colors.red),
              )
            else
              DropdownButtonFormField<Purchase>(
                value: _selectedPurchase,
                hint: const Text('Pilih Pesanan Pembelian (PO)'),
                items: widget.purchases.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(p.referenceNumber ?? p.id),
                  );
                }).toList(),
                onChanged: (p) => setState(() => _selectedPurchase = p),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            const SizedBox(height: 16),
            const Text('Tambah Item Diterima:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<Product>(
              value: _selectedProduct,
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
                        labelText: 'Harga Beli/Satuan (Rp)',
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
              const Text('Item yang Diterima:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...(_items.map((item) => ListTile(
                    dense: true,
                    title: Text(item.productId),
                    subtitle: Text(
                        '${item.quantityReceived.value} × Rp ${item.unitCost.minorUnits ~/ 100}'),
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
          onPressed:
              (_items.isEmpty || _selectedPurchase == null) ? null : _save,
          child: const Text('Simpan Penerimaan'),
        ),
      ],
    );
  }
}
