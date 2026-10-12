import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  final DashboardController controller;
  final ValueChanged<String>? onNavigate;

  const DashboardScreen({
    super.key,
    required this.controller,
    this.onNavigate,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _showThirtyDays = false;

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
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final summary = widget.controller.summary;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris Kartu KPI Utama
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = isDesktop ? 4 : 2;
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  childAspectRatio: isDesktop ? 2.1 : 1.5,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildKpiCard(
                      title: 'Penjualan Hari Ini',
                      value: 'Rp ${summary.totalOmset.minorUnits ~/ 100}',
                      growth: '▲ 18,6% dibanding kemarin',
                      icon: Icons.shopping_bag,
                      iconBgColor: Colors.green.shade100,
                      iconColor: Colors.green,
                    ),
                    _buildKpiCard(
                      title: 'Laba Kotor Hari Ini',
                      value: 'Rp ${summary.grossProfit.minorUnits ~/ 100}',
                      growth: '▲ 16,2% dibanding kemarin',
                      icon: Icons.show_chart,
                      iconBgColor: Colors.blue.shade100,
                      iconColor: Colors.blue,
                    ),
                    _buildKpiCard(
                      title: 'HPP Hari Ini',
                      value: 'Rp ${summary.totalHppFifo.minorUnits ~/ 100}',
                      growth: '▲ 14,3% dibanding kemarin',
                      icon: Icons.layers,
                      iconBgColor: Colors.purple.shade100,
                      iconColor: Colors.purple,
                    ),
                    _buildKpiCard(
                      title: 'Produksi Hari Ini',
                      value: '3 Batch',
                      growth: '▲ 1 Batch dibanding kemarin',
                      icon: Icons.soup_kitchen,
                      iconBgColor: Colors.orange.shade100,
                      iconColor: Colors.orange,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // Section Chart & Analytics
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildLineChartCard()),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: _buildDonutChartCard()),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: _buildStockAlertCard()),
                ],
              )
            else ...[
              _buildLineChartCard(),
              const SizedBox(height: 16),
              _buildDonutChartCard(),
              const SizedBox(height: 16),
              _buildStockAlertCard(),
            ],

            const SizedBox(height: 20),

            // Section Quick Actions (Aksi Cepat)
            _buildQuickActions(context),

            const SizedBox(height: 20),

            // Section Produksi & Margin Produk
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildRecentProductionCard()),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: _buildLowMarginProductsCard()),
                ],
              )
            else ...[
              _buildRecentProductionCard(),
              const SizedBox(height: 16),
              _buildLowMarginProductsCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String growth,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
              ],
            ),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(growth, style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChartCard() {
    final dayCount = _showThirtyDays ? 30 : 7;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDay = today.subtract(Duration(days: dayCount - 1));
    final dailySales = List<double>.filled(dayCount, 0);

    for (final sale in widget.controller.recentSales) {
      final saleDay = DateTime(
        sale.createdAt.year,
        sale.createdAt.month,
        sale.createdAt.day,
      );
      final index = saleDay.difference(firstDay).inDays;
      if (index >= 0 && index < dayCount) {
        for (final item in sale.items) {
          dailySales[index] += item.subtotal.minorUnits / 100.0;
        }
      }
    }
    final spots = [
      for (var index = 0; index < dayCount; index++)
        FlSpot(index.toDouble(), dailySales[index]),
    ];
    final chartTitle = _showThirtyDays ? 'Penjualan 30 Hari Terakhir' : 'Penjualan 7 Hari Terakhir';
    final interval = _showThirtyDays ? 5.0 : 1.0;
    final dayLabels = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(chartTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                DropdownButton<bool>(
                  value: _showThirtyDays,
                  isDense: true,
                  items: const [
                    DropdownMenuItem(value: false, child: Text('7 Hari')),
                    DropdownMenuItem(value: true, child: Text('30 Hari')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _showThirtyDays = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= dayCount || value != index) {
                            return const SizedBox.shrink();
                          }
                          final date = firstDay.add(Duration(days: index));
                          final label = _showThirtyDays
                              ? '${date.day}/${date.month}'
                              : dayLabels[date.weekday % 7];
                          return Text(label, style: const TextStyle(fontSize: 10));
                        },
                        interval: interval,
                        reservedSize: 24,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${(value / 1000).toStringAsFixed(0)}k', style: const TextStyle(fontSize: 10));
                        },
                        reservedSize: 36,
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blueAccent.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  minY: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonutChartCard() {
    final summary = widget.controller.summary;
    final recentSales = widget.controller.recentSales;
    
    // Calculate category distribution from recent sales
    final productSales = <String, double>{};
    for (final sale in recentSales) {
      for (final item in sale.items) {
        final subtotal = item.subtotal.minorUnits / 100.0;
        if (subtotal > 0) {
          productSales[item.productName] =
              (productSales[item.productName] ?? 0) + subtotal;
        }
      }
    }
    
    final sections = <PieChartSectionData>[];
    final colors = [Colors.blue, Colors.purple, Colors.orange, Colors.teal, Colors.green, Colors.red];
    
    if (productSales.isNotEmpty) {
      final entries = productSales.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final visibleEntries = entries.take(colors.length).toList();
      final otherSales = entries.skip(colors.length).fold<double>(
        0,
        (total, entry) => total + entry.value,
      );
      if (otherSales > 0) {
        visibleEntries.add(MapEntry('Lainnya', otherSales));
      }
      final total = visibleEntries.fold<double>(
        0,
        (sum, entry) => sum + entry.value,
      );
      for (var index = 0; index < visibleEntries.length; index++) {
        final entry = visibleEntries[index];
        sections.add(PieChartSectionData(
          color: colors[index % colors.length],
          value: entry.value,
          title: '${(entry.value / total * 100).round()}%',
          radius: 25,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));
      }
    } else {
      final total = summary.totalOmset.minorUnits;
      if (total > 0) {
        if (summary.grossProfit.minorUnits > 0) {
          sections.add(PieChartSectionData(
            color: Colors.green,
            value: summary.grossProfit.minorUnits.toDouble(),
            title: '${(summary.grossProfit.minorUnits * 100 / total).round()}%',
            radius: 25,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ));
        }
        if (summary.totalHppFifo.minorUnits > 0) {
          sections.add(PieChartSectionData(
            color: Colors.red,
            value: summary.totalHppFifo.minorUnits.toDouble(),
            title: '${(summary.totalHppFifo.minorUnits * 100 / total).round()}%',
            radius: 25,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ));
        }
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Penjualan per Produk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: sections.isEmpty 
                      ? [
                          PieChartSectionData(color: Colors.grey, value: 1, title: 'No Data', radius: 25),
                        ]
                      : sections,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStockAlertCard() {
    final alerts = [
      {'name': 'Cabai Merah Keriting', 'qty': 'Sisa 0,8 kg', 'status': 'Kritis', 'color': Colors.red},
      {'name': 'Bawang Putih', 'qty': 'Sisa 1,2 kg', 'status': 'Rendah', 'color': Colors.orange},
      {'name': 'Sereh', 'qty': 'Sisa 0,5 kg', 'status': 'Kritis', 'color': Colors.red},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Stock Alert', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                TextButton(
                  onPressed: () => widget.onNavigate?.call('Inventory'),
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final item = alerts[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.circle, size: 10, color: Colors.grey),
                  title: Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(item['qty'] as String),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['status'] as String,
                      style: TextStyle(color: item['color'] as Color, fontWeight: FontWeight.bold, fontSize: 11),
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

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'label': 'Buat Pesanan', 'icon': Icons.add_shopping_cart, 'color': Colors.green, 'destination': 'Pembelian'},
      {'label': 'Produksi Bumbu', 'icon': Icons.blender, 'color': Colors.purple, 'destination': 'Produksi'},
      {'label': 'Stok Masuk', 'icon': Icons.input, 'color': Colors.blue, 'destination': 'Penerimaan'},
      {'label': 'Laporan', 'icon': Icons.bar_chart, 'color': Colors.orange, 'destination': 'Penjualan'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Aksi Cepat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          children: actions.map((act) {
            return Expanded(
              child: Card(
                child: InkWell(
                  onTap: () => widget.onNavigate?.call(act['destination'] as String),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: (act['color'] as Color).withValues(alpha: 0.1),
                          child: Icon(act['icon'] as IconData, color: act['color'] as Color),
                        ),
                        const SizedBox(height: 8),
                        Text(act['label'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentProductionCard() {
    final list = [
      {'batch': 'BMB-023', 'name': 'Bumbu Merah', 'date': '18 Ags 2026', 'status': 'Selesai'},
      {'batch': 'BMB-022', 'name': 'Bumbu Putih', 'date': '18 Ags 2026', 'status': 'Selesai'},
      {'batch': 'BMB-021', 'name': 'Bumbu Kuning', 'date': '17 Ags 2026', 'status': 'Selesai'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Produksi Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text('${item['batch']} - ${item['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['date'] as String),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text(item['status'] as String, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowMarginProductsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Margin Produk Terendah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            _buildMarginProgress('Sambal Merah', 0.115, '11,5%'),
            const SizedBox(height: 8),
            _buildMarginProgress('Bumbu Kuning', 0.132, '13,2%'),
            const SizedBox(height: 8),
            _buildMarginProgress('Bumbu Putih', 0.148, '14,8%'),
          ],
        ),
      ),
    );
  }

  Widget _buildMarginProgress(String name, double val, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(value: val * 3, color: Colors.orange, backgroundColor: Colors.orange.shade50),
      ],
    );
  }
}
