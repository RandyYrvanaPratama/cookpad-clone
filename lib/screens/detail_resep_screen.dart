import 'dart:convert';
import 'package:cookpad_clone/models/resep_model.dart';
import 'package:cookpad_clone/provider/resep_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailResepScreen extends StatelessWidget {
  final ResepModel resep;

  const DetailResepScreen({super.key, required this.resep});

  Future<void> _simpanResep(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan resep. User belum login.')),
      );
      return;
    }

    Provider.of<ResepProvider>(context, listen: false)
        .simpanResepDariOrangLain(resep, userId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resep disimpan ke koleksi!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8),
      appBar: AppBar(
  title: Text(resep.nama ?? 'Detail Resep'),
  backgroundColor: const Color(0xFFF8AE0C),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 12), // Jarak dari tepi kanan
      child: IconButton(
        icon: const Icon(Icons.bookmark_border),
        onPressed: () => _simpanResep(context),
      ),
    ),
  ],
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            if (resep.gambarUrl != null && resep.gambarUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: resep.gambarUrl!.startsWith('http')
                    ? Image.network(
                        resep.gambarUrl!,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      )
                    : Image.memory(
                        base64Decode(resep.gambarUrl!),
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
              ),

            const SizedBox(height: 20),

            // Judul Resep
            Text(
              resep.nama ?? '-',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // Info Porsi & Durasi
            Row(
              children: [
                const Icon(Icons.timer, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${resep.durasi ?? '-'} menit'),
                const SizedBox(width: 16),
                const Icon(Icons.restaurant, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${resep.porsi ?? '-'} orang'),
              ],
            ),

            const SizedBox(height: 8),

            // Username
            if (resep.username != null)
              Text(
                'Dibagikan oleh: ${resep.username}',
                style: const TextStyle(color: Colors.grey),
              ),

            const Divider(height: 32),

            // Bahan-bahan
            const Text(
              'Bahan-bahan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...?resep.bahan?.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('• $item'),
              ),
            ),

            const Divider(height: 32),

            // Langkah-langkah
            const Text(
              'Langkah-langkah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...?resep.langkah?.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color(0xFFF8AE0C),
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
