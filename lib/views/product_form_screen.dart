import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _barcodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _basePriceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController(text: 'Umum');

  bool _isSaving = false;

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _basePriceController.dispose();
    _costPriceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final provider = Provider.of<PosProvider>(context, listen: false);
    final String generatedId = 'PRD_${DateTime.now().millisecondsSinceEpoch}';

    bool success = await provider.addNewProduct(
      id: generatedId,
      barcode: _barcodeController.text.trim(),
      name: _nameController.text.trim(),
      basePrice: double.parse(_basePriceController.text),
      costPrice: double.parse(_costPriceController.text),
      stock: int.parse(_stockController.text),
      category: _categoryController.text.trim(),
    );

    setState(() => _isSaving = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil ditambahkan ke Katalog!')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan produk. Cek duplikasi Barcode.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Barcode / SKU',
                  prefixIcon: Icon(Icons.qr_code_scanner),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Barcode wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  prefixIcon: Icon(Icons.shopping_bag),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Nama produk wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _basePriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga Jual (Rp)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || double.tryParse(val) == null ? 'Harga jual tidak valid' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _costPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga Modal (Rp)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || double.tryParse(val) == null ? 'Harga modal tidak valid' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stok Awal',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || int.tryParse(val) == null ? 'Stok tidak valid' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveProduct,
                icon: _isSaving ? const CircularProgressIndicator() : const Icon(Icons.save),
                label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Produk'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
