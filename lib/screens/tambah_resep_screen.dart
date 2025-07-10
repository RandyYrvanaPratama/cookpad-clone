import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/resep_model.dart';
import '../provider/resep_provider.dart';

class TambahResepScreen extends StatefulWidget {
  const TambahResepScreen({super.key});

  @override
  State<TambahResepScreen> createState() => _TambahResepScreenState();
}

class _TambahResepScreenState extends State<TambahResepScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _ceritaController = TextEditingController();
  final TextEditingController _porsiController = TextEditingController();
  final TextEditingController _durasiController = TextEditingController();
  final List<TextEditingController> _bahanControllers = [];
  final List<TextEditingController> _langkahControllers = [];

  @override
  void initState() {
    super.initState();
    _bahanControllers.add(TextEditingController());
    _langkahControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    _judulController.dispose();
    _ceritaController.dispose();
    _porsiController.dispose();
    _durasiController.dispose();
    for (var c in _bahanControllers) c.dispose();
    for (var c in _langkahControllers) c.dispose();
    super.dispose();
  }

  void _tambahBahan() {
    setState(() {
      _bahanControllers.add(TextEditingController());
    });
  }

  void _tambahLangkah() {
    setState(() {
      _langkahControllers.add(TextEditingController());
    });
  }

  void _simpanResep(bool publish) {
    final resepBaru = ResepModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: _judulController.text,
      gambarUrl: '', // bisa diisi fitur upload gambar nanti
      porsi: _porsiController.text,
      durasi: _durasiController.text,
      bahan: _bahanControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
      langkah: _langkahControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList(),
      isPublished: publish,
    );

    if (_judulController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul resep wajib diisi")),
      );
      return;
    }

    Provider.of<ResepProvider>(context, listen: false).tambahResep(resepBaru);

    Navigator.pushReplacementNamed(context, publish ? '/home' : '/koleksi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => _simpanResep(false),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => _simpanResep(true),
            child: const Text("Terbitkan", style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text("[Opsional] Foto Resep")
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: "[Wajib] Judul: Sup Ayam Favorit",
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _ceritaController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "[Opsional] Cerita di balik masakan ini...",
              ),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _porsiController,
                    decoration: const InputDecoration(labelText: "Porsi"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _durasiController,
                    decoration: const InputDecoration(labelText: "Lama memasak"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text("Bahan-bahan", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._bahanControllers.map((controller) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Contoh: ½ ekor ayam",
                ),
              ),
            )),
            TextButton.icon(
              onPressed: _tambahBahan,
              icon: const Icon(Icons.add),
              label: const Text("Bahan"),
            ),

            const SizedBox(height: 20),
            const Text("Langkah", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._langkahControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey.shade800,
                        child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "Langkah memasak...",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                  const SizedBox(height: 12),
                ],
              );
            }),
            TextButton.icon(
              onPressed: _tambahLangkah,
              icon: const Icon(Icons.add),
              label: const Text("Langkah"),
            ),
          ],
        ),
      ),
    );
  }
}
