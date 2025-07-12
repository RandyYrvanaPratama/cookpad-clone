import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/resep_model.dart';
import '../provider/resep_provider.dart';

class TambahResepScreen extends StatefulWidget {
  const TambahResepScreen({super.key});

  @override
  State<TambahResepScreen> createState() => _TambahResepScreenState();
}

class _TambahResepScreenState extends State<TambahResepScreen> {
  final _judulController = TextEditingController();
  final _ceritaController = TextEditingController();
  final _porsiController = TextEditingController();
  final _durasiController = TextEditingController();
  final List<TextEditingController> _bahanControllers = [TextEditingController()];
  final List<TextEditingController> _langkahControllers = [TextEditingController()];

  Uint8List? _previewImageBytes;
  String? _gambarBase64;

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _previewImageBytes = bytes;
        _gambarBase64 = base64Encode(bytes);
      });
    }
  }

  Future<void> _simpanResep(bool publish) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? 'anonymous';
    final username = prefs.getString('username') ?? 'Anonim';

    if (_judulController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul wajib diisi')),
      );
      return;
    }

    final resep = ResepModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      nama: _judulController.text,
      gambarUrl: _gambarBase64 ?? '',
      porsi: _porsiController.text,
      durasi: _durasiController.text,
      bahan: _bahanControllers.map((c) => c.text).where((e) => e.isNotEmpty).toList(),
      langkah: _langkahControllers.map((c) => c.text).where((e) => e.isNotEmpty).toList(),
      isPublished: publish,
      username: username,
    );

    try {
      await Provider.of<ResepProvider>(context, listen: false)
          .tambahResepKeFirestore(resep);
      Navigator.pushReplacementNamed(context, publish ? '/home' : '/koleksi');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  void _tambahBahan() {
    setState(() => _bahanControllers.add(TextEditingController()));
  }

  void _tambahLangkah() {
    setState(() => _langkahControllers.add(TextEditingController()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Resep"),
        backgroundColor: Colors.orange.shade700,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
},
        ),
        actions: [
          TextButton(
            onPressed: () => _simpanResep(false),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => _simpanResep(true),
            child: const Text("Terbitkan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Preview
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: _previewImageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(_previewImageBytes!, fit: BoxFit.cover),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Tambahkan Foto Masakan"),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Judul
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: "Judul Resep",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Cerita
            TextField(
              controller: _ceritaController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Cerita di balik masakan ini",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _porsiController,
                    decoration: const InputDecoration(
                      labelText: "Porsi",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _durasiController,
                    decoration: const InputDecoration(
                      labelText: "Durasi (menit)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),
            const Text("Bahan-bahan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ..._bahanControllers.map((controller) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Contoh: 2 siung bawang putih",
                      border: OutlineInputBorder(),
                    ),
                  ),
                )),
            TextButton.icon(
              onPressed: _tambahBahan,
              icon: const Icon(Icons.add),
              label: const Text("Tambah Bahan"),
            ),

            const SizedBox(height: 20),
            const Text("Langkah-langkah", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ..._langkahControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.orange,
                      child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Tulis langkah memasak...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: _tambahLangkah,
              icon: const Icon(Icons.add),
              label: const Text("Tambah Langkah"),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
