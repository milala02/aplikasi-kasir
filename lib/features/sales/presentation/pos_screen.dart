import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../products/domain/product.dart';
import 'pos_controller.dart';

class POSScreen extends StatefulWidget {
  final POSController controller;

  const POSScreen({super.key, required this.controller});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.init();
    widget.controller.addListener(_onStateChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onStateChange);
    _searchController.dispose();
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir POS Warung'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => widget.controller.init(),
          ),
        ],
      ),
      body: isDesktop
          ? Row(
              children: [
                Expanded(flex: 3, child: _buildCatalogSection()),
                const VerticalDivider(width: 1),
                Expanded(flex: 2, child: _buildCartSection()),
              ],
            )
          : Column(
              children: [
                Expanded(child: _buildCatalogSection()),
                const Divider(height: 1),
                SizedBox(height: 300, child: _buildCartSection()),
              ],
            ),
    );
  }

  Widget _buildCatalogSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Cari Produk / SKU',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => widget.controller.searchProduct(val),
          ),
        ),
        Expanded(
          child: widget.controller.products.isEmpty
              ? const Center(child: Text('Produk tidak ditemukan.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: widget.controller.products.length,
                  itemBuilder: (context, index) {
                    final product = widget.controller.products[index];
                    return _buildProductCard(product);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => widget.controller.addToCart(product),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text('Rp ${product.sellingPrice.minorUnits ~/ 100}'),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () => widget.controller.addToCart(product),
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartSection() {
    final cart = widget.controller.cart;
    final subtotalMinor = cart.subtotal?.minorUnits ?? 0;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.blueGrey.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Keranjang Belanja',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('${cart.items.length} Item'),
            ],
          ),
        ),
        Expanded(
          child: cart.items.isEmpty
              ? const Center(child: Text('Keranjang masih kosong.'))
              : ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      title: Text(item.product.name),
                      subtitle: Text(
                          'Rp ${item.product.sellingPrice.minorUnits ~/ 100} x ${item.quantity.value}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => widget.controller
                                .updateCartQuantity(
                                    item.product.id, item.quantity.value - 1),
                          ),
                          Text('${item.quantity.value}'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => widget.controller
                                .updateCartQuantity(
                                    item.product.id, item.quantity.value + 1),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    'Rp ${subtotalMinor ~/ 100}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.green),
                  onPressed: cart.items.isEmpty
                      ? null
                      : () async {
                          final inv =
                              'INV-${DateTime.now().millisecondsSinceEpoch}';
                          final success = await widget.controller.checkout(
                            invoiceNumber: inv,
                          );

                          if (!mounted) return;

                          if (success) {
                            _showReceiptDialog(context, widget.controller);
                          }
                        },
                  child: const Text('BAYAR / CHECKOUT',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showReceiptDialog(BuildContext context, POSController controller) {
    final sale = controller.lastCompletedSale;
    if (sale == null) return;

    final receiptText = controller.generateWhatsAppReceipt();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: Colors.green),
            const SizedBox(width: 8),
            Text('Transaksi ${sale.invoiceNumber} Berhasil!'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Preview Struk:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  receiptText ?? '',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          if (receiptText != null)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text('Kirim via WhatsApp',
                  style: TextStyle(color: Colors.white)),
              onPressed: () async {
                final encoded = Uri.encodeComponent(receiptText);
                final url = Uri.parse('https://wa.me/?text=$encoded');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
        ],
      ),
    );
  }
}
