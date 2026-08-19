import 'package:flutter/material.dart';

class BahanBaku {
  final String id;
  final String nama;
  double jumlah;
  final String satuan; // kg, gram, liter, pcs
  final double batasMinimum;

  BahanBaku({
    required this.id,
    required this.nama,
    required this.jumlah,
    required this.satuan,
    required this.batasMinimum,
  });

  bool get isStokKritis => jumlah <= batasMinimum;
}

class StokBahanPage extends StatefulWidget {
  const StokBahanPage({super.key});

  @override
  State<StokBahanPage> createState() => _StokBahanPageState();
}

class _StokBahanPageState extends State<StokBahanPage> {
  // Mock data awal bahan baku produksi
  final List<BahanBaku> _listBahan = [
    BahanBaku(id: '1', nama: 'Cabai Merah Segar', jumlah: 15.0, satuan: 'kg', batasMinimum: 5.0),
    BahanBaku(id: '2', nama: 'Bawang Merah', jumlah: 3.5, satuan: 'kg', batasMinimum: 5.0),
    BahanBaku(id: '3', nama: 'Minyak Goreng', jumlah: 20.0, satuan: 'liter', batasMinimum: 10.0),
    BahanBaku(id: '4', nama: 'Garam Halus', jumlah: 2.0, satuan: 'kg', batasMinimum: 3.0),
  ];

  void _tambahAtauEditBahan({BahanBaku? bahan}) {
    final namaController = TextEditingController(text: bahan?.nama ?? '');
    final jumlahController = TextEditingController(text: bahan?.jumlah.toString() ?? '');
    final satuanController = TextEditingController(text: bahan?.satuan ?? 'kg');
    final minController = TextEditingController(text: bahan?.batasMinimum.toString() ?? '5.0');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 16, left: 16, right: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              bahan == null ? 'Tambah Bahan Baku' : 'Update Stok Bahan',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama Bahan Baku', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Jumlah Stok', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: satuanController,
                    decoration: const InputDecoration(labelText: 'Satuan (kg/gr/L)', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: minController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Batas Minimum Warning', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () {
                if (namaController.text.isEmpty) return;
                setState(() {
                  if (bahan == null) {
                    _listBahan.add(BahanBaku(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      nama: namaController.text,
                      jumlah: double.tryParse(jumlahController.text) ?? 0,
                      satuan: satuanController.text,
                      batasMinimum: double.tryParse(minController.text) ?? 0,
                    ));
                  } else {
                    bahan.jumlah = double.tryParse(jumlahController.text) ?? bahan.jumlah;
                  }
                });
                Navigator.pop(ctx);
              },
              child: Text(bahan == null ? 'Simpan Bahan' : 'Update Jumlah'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Bahan Baku Produksi'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _listBahan.length,
        itemBuilder: (context, index) {
          final item = _listBahan[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item.isStokKritis ? Colors.red[100] : Colors.green[100],
                child: Icon(
                  item.isStokKritis ? Icons.warning_amber_rounded : Icons.inventory_2,
                  color: item.isStokKritis ? Colors.red : Colors.green[800],
                ),
              ),
              title: Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Stok: ${item.jumlah} ${item.satuan} (Min: ${item.batasMinimum} ${item.satuan})',
                style: TextStyle(color: item.isStokKritis ? Colors.red : Colors.grey[700]),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _tambahAtauEditBahan(bahan: item),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        onPressed: () => _tambahAtauEditBahan(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
