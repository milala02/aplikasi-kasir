import 'package:flutter/material.dart';

import '../../../core/money/money.dart';
import '../../../core/unit/unit.dart';
import '../application/product_use_cases.dart';
import '../domain/product.dart';

/// Kelola produk (owner). Pembuatan produk memakai ProductUseCases.create
/// yang menulis ke repository production (Drift, awaited).
class ProductScreen extends StatefulWidget {
  final ProductUseCases productUseCases;

  const ProductScreen({
    super.key,
    required this.productUseCases,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() => _products = widget.productUseCases.getAll());
  }

  Future<void> _openCreateDialog() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => _ProductFormDialog(
        onCreate: (name, sku, unit, purchaseRupiah, sellingRupiah) async {
          final product = Product(
            id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
            sku: sku,
            name: name,
            baseUnit: unit,
            purchasePrice: Money(
                minorUnits: purchaseRupiah * 100, currency: 'IDR'),
            sellingPrice:
                Money(minorUnits: sellingRupiah * 100, currency: 'IDR'),
          );
          await widget.productUseCases.create(product);
        },
      ),
    );

    if (created == true && mounted) {
      _reload();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil dibuat!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _products.isEmpty
          ? const Center(child: Text('Belum ada produk.'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    'SKU: ${product.sku} · ${product.baseUnit.name} · '
                    'Beli Rp ${product.purchasePrice.minorUnits ~/ 100} · '
                    'Jual Rp ${product.sellingPrice.minorUnits ~/ 100}'
                    '${product.active ? '' : ' (nonaktif)'}',
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        key: const Key('product_add_fab'),
        onPressed: _openCreateDialog,
        tooltip: 'Tambah Produk',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductFormDialog extends StatefulWidget {
  final Future<void> Function(
    String name,
    String sku,
    Unit unit,
    int purchaseRupiah,
    int sellingRupiah,
  ) onCreate;

  const _ProductFormDialog({required this.onCreate});

  @override
  State<_ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<_ProductFormDialog> {
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _purchaseController = TextEditingController();
  final _sellingController = TextEditingController();
  Unit _unit = Unit.kilogram;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _purchaseController.dispose();
    _sellingController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final sku = _skuController.text.trim();
    final purchase = int.tryParse(_purchaseController.text) ?? -1;
    final selling = int.tryParse(_sellingController.text) ?? -1;

    // Validasi input minimal; duplikasi ID/SKU tetap divalidasi use case.
    if (name.isEmpty || sku.isEmpty || purchase < 0 || selling < 0) {
      setState(() {
        _error = 'Nama dan SKU wajib diisi; harga harus angka >= 0.';
      });
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await widget.onCreate(name, sku, _unit, purchase, selling);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Gagal menyimpan produk: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Produk'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('product_name_field'),
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              key: const Key('product_sku_field'),
              controller: _skuController,
              decoration: const InputDecoration(labelText: 'SKU'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Unit>(
              key: const Key('product_unit_field'),
              initialValue: _unit,
              decoration: const InputDecoration(labelText: 'Satuan'),
              items: [
                for (final unit in Unit.values)
                  DropdownMenuItem(value: unit, child: Text(unit.name)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _unit = value);
              },
            ),
            TextField(
              key: const Key('product_purchase_field'),
              controller: _purchaseController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Harga Beli (Rp)'),
            ),
            TextField(
              key: const Key('product_selling_field'),
              controller: _sellingController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Harga Jual (Rp)'),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          key: const Key('product_save_button'),
          onPressed: _saving ? null : _submit,
          child: Text(_saving ? 'Menyimpan...' : 'Simpan'),
        ),
      ],
    );
  }
}
