import 'package:flutter/material.dart';

import 'dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  final DashboardController controller;

  const DashboardScreen({super.key, required this.controller});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.init();
    widget.controller.addListener(_onStateChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.controller.summary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Executive Financial Dashboard'),
        actions: [
          PopupMenuButton<DateRangeFilter>(
            initialValue: widget.controller.selectedFilter,
            onSelected: (filter) => widget.controller.setFilter(filter),
            itemBuilder: (context) => [
              const PopupMenuItem(value: DateRangeFilter.today, child: Text('Hari Ini')),
              const PopupMenuItem(value: DateRangeFilter.last7Days, child: Text('7 Hari Terakhir')),
              const PopupMenuItem(value: DateRangeFilter.last30Days, child: Text('30 Hari Terakhir')),
              const PopupMenuItem(value: DateRangeFilter.allTime, child: Text('Semua Waktu')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row KPI Cards
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'TOTAL OMSET',
                    value: 'Rp ${summary.totalOmset.minorUnits ~/ 100}',
                    color: Colors.blue,
                    icon: Icons.payments_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'HPP FIFO',
                    value: 'Rp ${summary.totalHppFifo.minorUnits ~/ 100}',
                    color: Colors.orange,
                    icon: Icons.inventory_2_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    title: 'LABA BERSIH',
                    value: 'Rp ${summary.grossProfit.minorUnits ~/ 100}',
                    color: Colors.green,
                    icon: Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKpiCard(
                    title: 'MARGIN PROFIT',
                    value: '${summary.marginPercentage.toStringAsFixed(1)}%',
                    color: Colors.purple,
                    icon: Icons.pie_chart_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Aktivitas Transaksi Terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            widget.controller.recentSales.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: Text('Belum ada transaksi pada periode ini.')),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.controller.recentSales.length,
                    itemBuilder: (context, index) {
                      final sale = widget.controller.recentSales[index];
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.receipt_long, color: Colors.white),
                          ),
                          title: Text(sale.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(sale.createdAt.toString().split('.')[0]),
                          trailing: Text(
                            'Rp ${sale.items.fold(0, (acc, item) => acc + item.subtotal.minorUnits) ~/ 100}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15),
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

  Widget _buildKpiCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
