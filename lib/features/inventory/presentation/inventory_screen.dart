import 'package:flutter/material.dart';

import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../domain/cost_layer.dart';
import '../domain/cost_layer_repository.dart';

class InventoryScreen extends StatefulWidget {
  final CostLayerRepository costLayerRepository;

  const InventoryScreen({
    super.key,
    required this.costLayerRepository,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<CostLayer> _activeLayers = [];
  final _productIdController = TextEditingController(text: 'lada_biji');
  final _qtyController = TextEditingController(text: '10');
  final _costController = TextEditingController(text: '160000');

  @override
  void initState() {
    super.initState();
    _loadActiveLayers();
  }

  Future<void> _loadActiveLayers() async {
    if (!mounted) return;

    try {
      final productId = _productIdController.text.trim().isEmpty
          ? 'lada_biji'
          : _productIdController.text.trim();

      final layers =
          await widget.costLayerRepository.getAvailableByProductId(productId);

      if (!mounted) return;

      setState(() {
        _activeLayers = layers;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _activeLayers = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat cost layer: $e')),
      );
    }
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _qtyController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _addCostLayer() async {
    try {
      final productId = _productIdController.text.trim();
      final qtyVal = int.tryParse(_qtyController.text) ?? 0;
      final costVal = (int.tryParse(_costController.text) ?? 0) * 100;

      if (productId.isEmpty || qtyVal <= 0 || costVal <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Isi semua field input dengan benar.')),
        );
        return;
      }

      final newLayer = CostLayer(
        id: 'layer_${DateTime.now().millisecondsSinceEpoch}',
        productId: productId,
        originalQuantity: Quantity(value: qtyVal, scale: 0),
        remainingQuantity: Quantity(value: qtyVal, scale: 0),
        unitCost: Money(minorUnits: costVal, currency: 'IDR'),
        acquiredAt: DateTime.now(),
      );

      await widget.costLayerRepository.save(newLayer);
      await _loadActiveLayers();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Stok FIFO Layer baru ($qtyVal unit @ Rp ${_costController.text}) berhasil ditambahkan!')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah stok: $e')),
      );
    }
  }

  void _showAddStockDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tambah Stok Barang',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nama Barang',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.black26,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Jumlah Stok',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.black26,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Simulasi: Barang ditambahkan ke Database!')));
                },
                child: const Text('Simpan Data',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentProductId = _productIdController.text.trim().isEmpty
        ? 'lada_biji'
        : _productIdController.text.trim();
    final activeLayers = _activeLayers;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddStockDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Stok', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orangeAccent,
      ),
      appBar: AppBar(
        title: const Text('Gudang & Stok FIFO Layer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadActiveLayers,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📥 Penerimaan Barang Masuk (New FIFO Cost Layer)',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _productIdController,
                      decoration: const InputDecoration(
                        labelText: 'Product ID / Kode Barang',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _qtyController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Jumlah Kuantitas',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _costController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Harga Beli Modal per Unit (Rp)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.teal,
                        ),
                        icon: const Icon(Icons.add_box, color: Colors.white),
                        label: const Text(
                          'TAMBAH STOK LAYER BARU',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        onPressed: _addCostLayer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '📊 Cost Layer FIFO Aktif untuk "$currentProductId"',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            activeLayers.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                          child: Text(
                              'Belum ada stok layer aktif untuk produk ini.')),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeLayers.length,
                    itemBuilder: (context, index) {
                      final layer = activeLayers[index];
                      final isExhausted = layer.remainingQuantity.value == 0;

                      return Card(
                        color:
                            isExhausted ? Colors.grey.shade100 : Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                isExhausted ? Colors.grey : Colors.teal,
                            child: Icon(
                              isExhausted
                                  ? Icons.inventory_2_outlined
                                  : Icons.inventory_2,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            '${layer.productId} - Batch ID: ${layer.id}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: isExhausted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            'Sisa: ${layer.remainingQuantity.value} / ${layer.originalQuantity.value} | '
                            'Tgl Masuk: ${layer.acquiredAt.toString().split('.')[0]}',
                          ),
                          trailing: Text(
                            'Rp ${layer.unitCost.minorUnits ~/ 100} / unit',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
