import 'package:flutter/material.dart';

import '../../../core/quantity/quantity.dart';
import '../../products/domain/product.dart';
import '../../products/domain/product_repository.dart';
import '../application/recipe_use_cases.dart';
import '../domain/recipe.dart';

/// Kelola resep produksi (owner). Resep menyimpan komposisi bahan
/// (productId + quantity) dan expected output — TANPA harga.
class RecipeScreen extends StatefulWidget {
  final RecipeUseCases recipeUseCases;
  final ProductRepository productRepository;

  const RecipeScreen({
    super.key,
    required this.recipeUseCases,
    required this.productRepository,
  });

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() => _recipes = widget.recipeUseCases.getAll());
  }

  Future<void> _openDialog({Recipe? existing}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _RecipeFormDialog(
        existing: existing,
        products: widget.productRepository.getAll(),
        onSave: (recipe) async {
          if (existing == null) {
            await widget.recipeUseCases.create(recipe);
          } else {
            await widget.recipeUseCases.update(recipe);
          }
        },
      ),
    );

    if (saved == true && mounted) {
      _reload();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(existing == null
                ? 'Resep berhasil dibuat!'
                : 'Resep berhasil diperbarui!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _recipes.isEmpty
          ? const Center(child: Text('Belum ada resep.'))
          : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                return ListTile(
                  title: Text(recipe.name),
                  subtitle: Text(
                    '${recipe.items.length} bahan · Output '
                    '${recipe.expectedOutputQuantity.value} '
                    '(scale ${recipe.expectedOutputQuantity.scale})',
                  ),
                  onTap: () => _openDialog(existing: recipe),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        key: const Key('recipe_add_fab'),
        onPressed: () => _openDialog(),
        tooltip: 'Tambah Resep',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Skala quantity yang dipakai UI resep.
const _scaleOptions = <int, String>{
  0: 'kg',
  1: '100 g',
  3: 'g',
};

class _RecipeFormDialog extends StatefulWidget {
  final Recipe? existing;
  final List<Product> products;
  final Future<void> Function(Recipe recipe) onSave;

  const _RecipeFormDialog({
    required this.existing,
    required this.products,
    required this.onSave,
  });

  @override
  State<_RecipeFormDialog> createState() => _RecipeFormDialogState();
}

class _RecipeFormDialogState extends State<_RecipeFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _outputValueController;
  int _outputScale = 1;
  String? _outputProductId;

  /// Baris bahan: (productId, qtyController, scale).
  final List<({String? productId, TextEditingController qty, int scale})>
      _items = [];

  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController =
        TextEditingController(text: existing?.name ?? '');
    _outputValueController = TextEditingController(
        text: existing == null
            ? ''
            : '${existing.expectedOutputQuantity.value}');
    _outputScale = existing?.expectedOutputQuantity.scale ?? 1;
    _outputProductId = existing?.outputProductId;

    for (final item in existing?.items ?? const <RecipeItem>[]) {
      _items.add((
        productId: item.productId,
        qty: TextEditingController(text: '${item.quantityRequired.value}'),
        scale: item.quantityRequired.scale,
      ));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _outputValueController.dispose();
    for (final row in _items) {
      row.qty.dispose();
    }
    super.dispose();
  }

  void _addItemRow() {
    setState(() {
      _items.add((productId: null, qty: TextEditingController(), scale: 0));
    });
  }

  void _removeItemRow(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final outputValue = int.tryParse(_outputValueController.text) ?? 0;

    if (name.isEmpty || outputValue <= 0) {
      setState(() {
        _error = 'Nama resep dan output harus diisi (nilai > 0).';
      });
      return;
    }

    if (_items.isEmpty) {
      setState(() {
        _error = 'Resep minimal memiliki satu bahan.';
      });
      return;
    }

    final items = <RecipeItem>[];
    for (var i = 0; i < _items.length; i++) {
      final row = _items[i];
      final qty = int.tryParse(row.qty.text) ?? 0;
      if (row.productId == null || row.productId!.isEmpty || qty <= 0) {
        setState(() {
          _error = 'Bahan ${i + 1}: pilih produk dan isi quantity > 0.';
        });
        return;
      }
      items.add(
        RecipeItem(
          productId: row.productId!,
          quantityRequired: Quantity(value: qty, scale: row.scale),
        ),
      );
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      // Konstruksi di dalam try: error domain (mis. bahan duplikat)
      // ditampilkan sebagai pesan, bukan exception.
      final recipe = Recipe(
        id: widget.existing?.id ??
            'rec_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        items: items,
        expectedOutputQuantity:
            Quantity(value: outputValue, scale: _outputScale),
        outputProductId: _outputProductId,
      );

      await widget.onSave(recipe);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Gagal menyimpan resep: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Tambah Resep' : 'Edit Resep'),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('recipe_name_field'),
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Resep'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('recipe_output_value_field'),
                      controller: _outputValueController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Output (nilai)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      key: const Key('recipe_output_scale_field'),
                      initialValue: _outputScale,
                      decoration:
                          const InputDecoration(labelText: 'Satuan output'),
                      items: [
                        for (final entry in _scaleOptions.entries)
                          DropdownMenuItem(
                              value: entry.key, child: Text(entry.value)),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _outputScale = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                key: const Key('recipe_output_product_field'),
                initialValue: _outputProductId,
                decoration: const InputDecoration(
                  labelText: 'Produk hasil (opsional)',
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('— Tanpa produk hasil —'),
                  ),
                  for (final product in widget.products)
                    DropdownMenuItem<String?>(
                      value: product.id,
                      child: Text(product.name,
                          overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (value) {
                  setState(() => _outputProductId = value);
                },
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Bahan:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              for (var i = 0; i < _items.length; i++)
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        key: Key('recipe_item_product_field_$i'),
                        initialValue: _items[i].productId,
                        decoration:
                            const InputDecoration(labelText: 'Produk'),
                        items: [
                          for (final product in widget.products)
                            DropdownMenuItem(
                              value: product.id,
                              child: Text(product.name,
                                  overflow: TextOverflow.ellipsis),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _items[i] = (
                              productId: value,
                              qty: _items[i].qty,
                              scale: _items[i].scale,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        key: Key('recipe_item_qty_field_$i'),
                        controller: _items[i].qty,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Qty'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        key: Key('recipe_item_scale_field_$i'),
                        initialValue: _items[i].scale,
                        decoration: const InputDecoration(labelText: 'Satuan'),
                        items: [
                          for (final entry in _scaleOptions.entries)
                            DropdownMenuItem(
                                value: entry.key, child: Text(entry.value)),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _items[i] = (
                                productId: _items[i].productId,
                                qty: _items[i].qty,
                                scale: value,
                              );
                            });
                          }
                        },
                      ),
                    ),
                    IconButton(
                      key: Key('recipe_item_remove_$i'),
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _removeItemRow(i),
                    ),
                  ],
                ),
              TextButton.icon(
                key: const Key('recipe_add_item_button'),
                onPressed: _addItemRow,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Bahan'),
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
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          key: const Key('recipe_save_button'),
          onPressed: _saving ? null : _submit,
          child: Text(_saving ? 'Menyimpan...' : 'Simpan'),
        ),
      ],
    );
  }
}
