import 'widgets/barcode_scanner_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import 'product_form_screen.dart';
import 'widgets/supervisor_pin_dialog.dart';

class PosDashboardScreen extends StatefulWidget {
  const PosDashboardScreen({super.key});

  @override
  State<PosDashboardScreen> createState() => _PosDashboardScreenState();
}

class _PosDashboardScreenState extends State<PosDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PosProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Aksi Tambah Produk Dilindungi PIN Supervisor
  Future<void> _navigateToAddProduct() async {
    final bool? isAuthorized = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const SupervisorPinDialog(
        title: 'Otorisasi Tambah Produk',
      ),
    );

    if (isAuthorized == true && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ProductFormScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PosProvider>(
      builder: (context, provider, child) {
        final filteredProducts = provider.products.where((prod) {
          final name = (prod['name'] as String).toLowerCase();
          final barcode = (prod['barcode'] as String).toLowerCase();
          final q = _searchQuery.toLowerCase();
          return name.contains(q) || barcode.contains(q);
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('POS Kasir Production'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_box),
                tooltip: 'Tambah Produk Baru (Supervisor)',
                onPressed: _navigateToAddProduct,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => provider.loadProducts(),
              ),
            ],
          ),
          body: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nama produk / scan barcode...',
                    prefixIcon: const Icon(Icons.search),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner, color: Colors.blue),
                    onPressed: () async {
                      final scannedCode = await showDialog<String>(
                        context: context,
                        builder: (context) => const BarcodeScannerDialog(),
                      );
                      if (scannedCode != null && scannedCode.isNotEmpty) {
                        setState(() {
                          _searchController.text = scannedCode;
                        });
                      }
                    },
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    ),
                ],
              ),
                    
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              // Catalog Grid / Loader / Empty State
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredProducts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                                const SizedBox(height: 12),
                                Text(
                                  _searchQuery.isEmpty
                                      ? 'Belum ada produk di database.\nTekan tombol (+) di atas untuk menambah.'
                                      : 'Produk tidak ditemukan.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (ctx, index) {
                              final item = filteredProducts[index];
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                  onTap: () => provider.addToCart(item),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['category'] ?? 'Umum',
                                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['name'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Stok: ${item['stock']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: item['stock'] > 0 ? Colors.green : Colors.red,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Rp ${(item['base_price'] as num).toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            const CircleAvatar(
                                              radius: 12,
                                              child: Icon(Icons.add, size: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),

              // Bottom Sheet Ringkasan Keranjang
              if (provider.cart.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${provider.cart.length} Item di Keranjang', style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () => provider.clearCart(),
                            child: const Text('Kosongkan', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Grand Total (inc. PPN 11%):'),
                          Text(
                            'Rp ${provider.grandTotal.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            final success = await provider.processCheckout(paymentMethod: 'cash');
                            if (!mounted) return;
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(success ? 'Pembayaran berhasil!' : 'Pembayaran gagal'),
                                backgroundColor: success ? Colors.green : Colors.red,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Proses Pembayaran', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
