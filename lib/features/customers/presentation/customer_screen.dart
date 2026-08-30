import 'package:flutter/material.dart';

import '../../sync/application/sync_enqueue_service.dart';
import '../domain/customer.dart';
import '../domain/customer_repository.dart';

class CustomerScreen extends StatefulWidget {
  final CustomerRepository customerRepository;
  final SyncEnqueueService? syncEnqueueService;

  const CustomerScreen({
    super.key,
    required this.customerRepository,
    this.syncEnqueueService,
  });

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _addCustomer() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Nomor Telepon wajib diisi.')),
      );
      return;
    }

    final newCustomer = Customer(
      id: 'cust_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phoneNumber: phone,
      address: address.isNotEmpty ? address : null,
      createdAt: DateTime.now(),
    );

    try {
      await widget.customerRepository.save(newCustomer);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan pelanggan: $e')),
      );
      return;
    }

    await widget.syncEnqueueService?.enqueue(
      referenceId: newCustomer.id,
      endpoint: '/api/v1/sync/push',
      sourceTable: 'customer',
      payload: SyncEnqueueService.customerPayload(newCustomer),
    );

    _nameController.clear();
    _phoneController.clear();
    _addressController.clear();

    setState(() {});

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pelanggan $name berhasil ditambahkan!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customers = widget.customerRepository.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelanggan & WA CRM'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
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
                    const Text('👤 Tambah Pelanggan Baru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap Pelanggan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Nomor WhatsApp (Contoh: 081234567890)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Alamat (Opsional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.purple,
                        ),
                        icon: const Icon(Icons.person_add, color: Colors.white),
                        label: const Text('SIMPAN PELANGGAN', style: TextStyle(color: Colors.white, fontSize: 15)),
                        onPressed: _addCustomer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('📋 Daftar Pelanggan Terdaftar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            customers.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: Text('Belum ada pelanggan terdaftar.')),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final cust = customers[index];
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(cust.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('WA: ${cust.formattedWhatsAppNumber}\n${cust.address ?? 'Tanpa Alamat'}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.chat, color: Colors.green),
                            onPressed: () {
                              final waUrl = cust.generateWhatsAppUrl('Halo ${cust.name}, terima kasih telah berbelanja di warung kami!');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Aksi Kirim WA: $waUrl')),
                              );
                            },
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
