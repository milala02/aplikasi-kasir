import 'package:flutter/material.dart';

import '../../../core/errors/domain_error.dart';
import '../../../core/money/money.dart';
import '../../../core/result/result.dart';
import '../../inventory/domain/cost_layer_repository.dart';
import '../../portioning/application/calculate_portion_use_case.dart';
import '../../products/domain/product.dart';
import '../../products/domain/product_repository.dart';
import '../../recipes/domain/recipe.dart';
import '../../recipes/domain/recipe_repository.dart';
import '../application/execute_production_use_case.dart';
import '../domain/production_batch.dart';

class ProductionAndPortioningScreen extends StatefulWidget {
  final CostLayerRepository costLayerRepository;
  final ExecuteProductionUseCase executeProductionUseCase;
  final RecipeRepository recipeRepository;
  final ProductRepository productRepository;

  const ProductionAndPortioningScreen({
    super.key,
    required this.costLayerRepository,
    required this.executeProductionUseCase,
    required this.recipeRepository,
    required this.productRepository,
  });

  @override
  State<ProductionAndPortioningScreen> createState() =>
      _ProductionAndPortioningScreenState();
}

class _ProductionAndPortioningScreenState
    extends State<ProductionAndPortioningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Produksi
  List<Recipe> _recipes = [];
  Recipe? _selectedRecipe;
  final _batchNumberController = TextEditingController();
  final _operationalCostController = TextEditingController(text: '0');
  bool _busy = false;
  String? _productionResultText;
  String? _productionErrorText;

  // Portioning Calculator State
  String? _portionProductId;
  final _priceController = TextEditingController(text: '5000');
  final _marginController = TextEditingController(text: '30');
  final _pkgCostController = TextEditingController(text: '300');

  String _calcResultText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRecipes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _batchNumberController.dispose();
    _operationalCostController.dispose();
    _priceController.dispose();
    _marginController.dispose();
    _pkgCostController.dispose();
    super.dispose();
  }

  void _loadRecipes() {
    setState(() {
      _recipes = widget.recipeRepository.getAll();
      _selectedRecipe = null;
      _productionResultText = null;
      _productionErrorText = null;
    });
  }

  Product? get _outputProduct {
    final outputProductId = _selectedRecipe?.outputProductId;
    if (outputProductId == null) return null;
    return widget.productRepository.getById(outputProductId);
  }

  bool get _canProduce {
    return !_busy &&
        _selectedRecipe != null &&
        _selectedRecipe!.outputProductId != null &&
        _outputProduct != null;
  }

  /// Satu submission = satu batch. _busy mencegah double-tap membuat batch
  /// kedua; tidak ada retry otomatis.
  Future<void> _executeProduction() async {
    final recipe = _selectedRecipe;
    if (recipe == null || !_canProduce) return;

    final batchNumber = _batchNumberController.text.trim().isEmpty
        ? 'BATCH-${DateTime.now().millisecondsSinceEpoch}'
        : _batchNumberController.text.trim();
    final operationalCost = int.tryParse(_operationalCostController.text) ?? 0;

    setState(() {
      _busy = true;
      _productionErrorText = null;
      _productionResultText = null;
    });

    try {
      final result = await widget.executeProductionUseCase.execute(
        recipe: recipe,
        batchNumber: batchNumber,
        additionalProductionCost: operationalCost > 0
            ? Money(minorUnits: operationalCost * 100, currency: 'IDR')
            : null,
      );

      if (!mounted) return;

      if (result is Success<ProductionBatch>) {
        final batch = result.value;
        setState(() {
          _busy = false;
          _productionResultText = '✅ PRODUKSI BERHASIL\n\n'
              '• Batch: ${batch.batchNumber}\n'
              '• HPP Material: Rp ${batch.totalMaterialCost.minorUnits ~/ 100}\n'
              '• Total HPP Batch: Rp ${batch.totalBatchCost.minorUnits ~/ 100}\n'
              '• HPP per unit: Rp ${batch.unitCost.minorUnits ~/ 100}\n'
              '• Output: ${batch.actualOutputQuantity.value} '
              '(scale ${batch.actualOutputQuantity.scale})\n'
              '• Produk hasil: ${_outputProduct?.name} — stok FIFO tercatat.';
        });
      } else {
        final error = (result as Failure<ProductionBatch>).error;
        final message =
            error is DomainError ? error.message : error.toString();
        setState(() {
          _busy = false;
          _productionErrorText = message;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _productionErrorText = 'Gagal memproses produksi: $e';
      });
    }
  }

  Future<void> _calculateKetengan() async {
    final productId = _portionProductId;
    if (productId == null || productId.isEmpty) {
      setState(() {
        _calcResultText = '⚠️ Pilih produk terlebih dahulu.';
      });
      return;
    }

    try {
      final priceInt = (int.tryParse(_priceController.text) ?? 0) * 100;
      final marginDouble = (double.tryParse(_marginController.text) ?? 0) / 100;
      final pkgCostInt = (int.tryParse(_pkgCostController.text) ?? 0) * 100;

      final useCase = CalculatePortionUseCase(
          costLayerRepository: widget.costLayerRepository);

      final result = await useCase.execute(
        productId: productId,
        targetSellingPrice: Money(minorUnits: priceInt, currency: 'IDR'),
        targetMarginPercentage: marginDouble,
        packagingCostPerUnit: Money(minorUnits: pkgCostInt, currency: 'IDR'),
      );

      setState(() {
        _calcResultText = '💡 HASIL REKOMENDASI TAKARAN:\n\n'
            '• Berat per Bungkus: ${result.recommendedWeightPerPortionInGrams.value} Gram\n'
            '• Estimasi Hasil per Kg: ${result.totalPortionsPerKg} Bungkus\n'
            '• Untung Bersih per Bungkus: Rp ${result.profitPerPortion.minorUnits ~/ 100}';
      });
    } on StateError {
      setState(() {
        _calcResultText =
            '⚠️ Produk belum punya stok/cost layer — catat penerimaan dulu.';
      });
    } catch (e) {
      setState(() {
        _calcResultText = '⚠️ Gagal Menghitung: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dapur Produksi & Repacking'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.blender), text: 'Produksi Bumbu Utama'),
            Tab(icon: Icon(Icons.scale), text: 'Kalkulator Ketengan Lada'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBumbuProductionTab(),
          _buildKetenganCalculatorTab(),
        ],
      ),
    );
  }

  Widget _buildBumbuProductionTab() {
    final recipe = _selectedRecipe;
    final outputProduct = _outputProduct;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Produksi dari Resep Tersimpan (FIFO Cost Layer)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          DropdownButtonFormField<Recipe>(
            key: const Key('production_recipe_field'),
            value: recipe,
            decoration: const InputDecoration(
              labelText: 'Pilih Resep',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final r in _recipes)
                DropdownMenuItem(value: r, child: Text(r.name)),
            ],
            onChanged: (value) {
              setState(() {
                _selectedRecipe = value;
                _productionResultText = null;
                _productionErrorText = null;
              });
            },
          ),
          const SizedBox(height: 12),
          if (recipe != null) ...[
            Text('Bahan (${recipe.items.length}):',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            for (final item in recipe.items)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Text(
                    '• ${item.productId}: ${item.quantityRequired.value} '
                    '(scale ${item.quantityRequired.scale})'),
              ),
            const SizedBox(height: 8),
            Text(
              'Expected output: ${recipe.expectedOutputQuantity.value} '
              '(scale ${recipe.expectedOutputQuantity.scale})',
            ),
            Text(
              outputProduct != null
                  ? 'Produk hasil: ${outputProduct.name}'
                  : '⚠️ Resep tidak punya produk hasil — produksi '
                      'tidak dapat dijalankan.',
              style: TextStyle(
                color: outputProduct != null ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            key: const Key('production_batch_number_field'),
            controller: _batchNumberController,
            decoration: const InputDecoration(
              labelText: 'Nama Batch Produksi (opsional)',
              hintText: 'Otomatis BATCH-<timestamp> jika kosong',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('production_operational_cost_field'),
            controller: _operationalCostController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Biaya Gas & Operasional (Rp)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              key: const Key('production_execute_button'),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.orange),
              icon: const Icon(Icons.precision_manufacturing,
                  color: Colors.white),
              label: Text(
                  _busy
                      ? 'MEMPROSES...'
                      : 'PROSES PRODUKSI & POTONG STOK FIFO',
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: _canProduce ? _executeProduction : null,
            ),
          ),
          const SizedBox(height: 12),
          if (_productionResultText != null)
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_productionResultText!),
              ),
            ),
          if (_productionErrorText != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_productionErrorText!,
                    style: const TextStyle(color: Colors.red)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKetenganCalculatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kalkulator Repacking Ketengan (Bumbu / Lada)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: const Key('portion_product_field'),
            value: _portionProductId,
            decoration: const InputDecoration(
              labelText: 'Pilih Produk (Bahan)',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final product in widget.productRepository.getAll())
                DropdownMenuItem(
                  value: product.id,
                  child: Text(product.name,
                      overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (value) {
              setState(() {
                _portionProductId = value;
                _calcResultText = '';
              });
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Harga Jual Ketengan Target (Rp)',
              hintText: '5000 atau 10000',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _marginController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Target Margin Profit (%)',
              hintText: 'Misal 30',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pkgCostController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Biaya Plastik / Kemasan per Bungkus (Rp)',
              hintText: '300',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent),
              icon: const Icon(Icons.calculate, color: Colors.white),
              label: const Text('HITUNG TAKARAN GRAM OTOMATIS',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: _calculateKetengan,
            ),
          ),
          const SizedBox(height: 20),
          if (_calcResultText.isNotEmpty)
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_calcResultText,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ),
            ),
        ],
      ),
    );
  }
}
