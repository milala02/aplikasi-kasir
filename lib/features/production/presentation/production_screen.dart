import 'package:flutter/material.dart';

import '../../../core/money/money.dart';
import '../../inventory/domain/cost_layer_repository.dart';
import '../../portioning/application/calculate_portion_use_case.dart';

class ProductionAndPortioningScreen extends StatefulWidget {
  final CostLayerRepository costLayerRepository;

  const ProductionAndPortioningScreen({
    super.key,
    required this.costLayerRepository,
  });

  @override
  State<ProductionAndPortioningScreen> createState() =>
      _ProductionAndPortioningScreenState();
}

class _ProductionAndPortioningScreenState
    extends State<ProductionAndPortioningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Portioning Calculator State
  final _priceController = TextEditingController(text: '5000');
  final _marginController = TextEditingController(text: '30');
  final _pkgCostController = TextEditingController(text: '300');

  String _calcResultText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _priceController.dispose();
    _marginController.dispose();
    _pkgCostController.dispose();
    super.dispose();
  }

  Future<void> _calculateKetengan() async {
    try {
      final priceInt = (int.tryParse(_priceController.text) ?? 0) * 100;
      final marginDouble = (double.tryParse(_marginController.text) ?? 0) / 100;
      final pkgCostInt = (int.tryParse(_pkgCostController.text) ?? 0) * 100;

      final useCase = CalculatePortionUseCase(
          costLayerRepository: widget.costLayerRepository);

      final result = await useCase.execute(
        productId: 'lada_biji',
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Form Racik Bumbu Utama (FIFO Cost Layer)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Nama Batch Produksi',
              hintText: 'Misal: Bumbu Utama Batch #024',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Total Hasil Jadi (Kg)',
              hintText: 'Misal: 10',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Biaya Gas & Operasional (Rp)',
              hintText: 'Misal: 15000',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.orange),
              icon: const Icon(Icons.precision_manufacturing,
                  color: Colors.white),
              label: const Text('PROSES PRODUKSI & POTONG STOK FIFO',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Simulasi Produksi Bumbu Berhasil! HPP FIFO Dihitung.')),
                );
              },
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
