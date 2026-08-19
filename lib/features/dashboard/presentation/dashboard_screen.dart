import 'package:fl_chart/fl_chart.dart';
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Penjualan 7 Hari Terakhir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                DropdownButton<String>(
                  value: '7 Hari',
                  isDense: true,
                  items: const [DropdownMenuItem(value: '7 Hari', child: Text('7 Hari'))],
                  onChanged: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 500),
                        FlSpot(1, 750),
                        FlSpot(2, 550),
                        FlSpot(3, 700),
                        FlSpot(4, 720),
                        FlSpot(5, 950),
                        FlSpot(6, 1240),
                      ],
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonutChartCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Penjualan per Kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(color: Colors.blue, value: 60, title: '60%', radius: 25),
                    PieChartSectionData(color: Colors.purple, value: 25, title: '25%', radius: 25),
                    PieChartSectionData(color: Colors.orange, value: 10, title: '10%', radius: 25),
                    PieChartSectionData(color: Colors.teal, value: 5, title: '5%', radius: 25),
                  ],
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
                TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
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
      {'label': 'Buat Pesanan', 'icon': Icons.add_shopping_cart, 'color': Colors.green},
      {'label': 'Produksi Bumbu', 'icon': Icons.blender, 'color': Colors.purple},
      {'label': 'Stok Masuk', 'icon': Icons.input, 'color': Colors.blue},
      {'label': 'Laporan', 'icon': Icons.bar_chart, 'color': Colors.orange},
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
                  onTap: () {},
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
