// screens/detail_resep_screen.dart
import 'package:flutter/material.dart';
import '../models/resep_model.dart';

class DetailResepScreen extends StatelessWidget {
  final ResepModel resep;

  const DetailResepScreen({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(resep.nama),
        backgroundColor: Color(0xFFF8AE0C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            resep.gambarUrl.isNotEmpty
                ? Image.network(resep.gambarUrl, height: 200, fit: BoxFit.cover)
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 100),
                  ),
            const SizedBox(height: 16),
            Text(
              resep.nama,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('${resep.porsi} • ${resep.durasi}', style: TextStyle(fontSize: 16)),
            const Divider(height: 32),
            Text("Bahan:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...resep.bahan.map((b) => Text('- $b')),
            const Divider(height: 32),
            Text("Langkah:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...resep.langkah.map((l) => Text('- $l')),
          ],
        ),
      ),
    );
  }
}
