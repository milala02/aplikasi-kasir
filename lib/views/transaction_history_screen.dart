import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/pos_provider.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();

  void _applyFilter() {
    Provider.of<PosProvider>(context, listen: false).filterTransactions(
      date: _selectedDate, 
      query: _searchController.text
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: Column(
        children: [
          // Bar Pencarian & Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Cari ID Transaksi...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => _applyFilter(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context, initialDate: _selectedDate,
                      firstDate: DateTime(2023), lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                      _applyFilter();
                    }
                  },
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Consumer<PosProvider>(
              builder: (context, provider, child) {
                final transactions = provider.filteredTransactions;
                return transactions.isEmpty
                    ? const Center(child: Text('Tidak ada transaksi ditemukan'))
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final trx = transactions[index];
                          return ListTile(
                            title: Text('ID: ${trx.id}'),
                            subtitle: Text('${trx.paymentMethod} • ${DateFormat('HH:mm').format(trx.timestamp)}'),
                            trailing: Text('Rp ${trx.totalAmount.toInt()}'),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
