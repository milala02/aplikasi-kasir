import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardAnalitikPage extends StatefulWidget {
  const DashboardAnalitikPage({super.key});

  @override
  State<DashboardAnalitikPage> createState() => _DashboardAnalitikPageState();
}

class _DashboardAnalitikPageState extends State<DashboardAnalitikPage> {
  int _selectedFilter = 7; // Default 7 Hari Terakhir

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analitik & Laporan Penjualan'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Ringkasan KPI Cards
            Row(
              children: [
                _buildKpiCard('Total Omzet', 'Rp 4.250.000', Icons.payments, Colors.green),
                const SizedBox(width: 12),
                _buildKpiCard('Total Transaksi', '128 Nota', Icons.receipt_long, Colors.blue),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildKpiCard('Est. Laba Bersih', 'Rp 1.850.000', Icons.trending_up, Colors.orange),
                const SizedBox(width: 12),
                _buildKpiCard('Produk Terlaris', 'Bumbu Rendang', Icons.star, Colors.purple),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Header Grafik Penjualan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tren Omzet Harian',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: _selectedFilter,
                  items: const [
                    DropdownMenuItem(value: 7, child: Text('7 Hari Terakhir')),
                    DropdownMenuItem(value: 30, child: Text('30 Hari Terakhir')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedFilter = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. Visualisasi BarChart fl_chart
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.15),
                    spreadRadius: 2,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1000,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
                          if (value.toInt() >= 0 && value.toInt() < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(days[value.toInt()], style: const TextStyle(fontSize: 12)),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _makeBarGroup(0, 450), // Senin (dalam ribuan Rp)
                    _makeBarGroup(1, 600), // Selasa
                    _makeBarGroup(2, 520), // Rabu
                    _makeBarGroup(3, 780), // Kamis
                    _makeBarGroup(4, 900), // Jumat
                    _makeBarGroup(5, 850), // Sabtu
                    _makeBarGroup(6, 650), // Minggu
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, MaterialColor color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color[800], size: 28),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: color[900], fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: color[900], fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.green[700],
          width: 18,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
