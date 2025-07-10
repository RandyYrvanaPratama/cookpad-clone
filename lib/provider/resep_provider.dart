import 'package:flutter/foundation.dart';
import '../models/resep_model.dart';

class ResepProvider with ChangeNotifier {
  final List<ResepModel> _daftarResep = [
    ResepModel(
      id: '1',
      nama: 'Nasi Goreng Spesial',
      gambarUrl: 'https://via.placeholder.com/150',
      porsi: '2 orang',
      durasi: '30 menit',
      bahan: ['Nasi', 'Telur', 'Kecap', 'Bawang'],
      langkah: ['Tumis bawang', 'Masukkan telur', 'Tambahkan nasi dan kecap', 'Aduk rata'],
      isPublished: true,
    ),
    ResepModel(
      id: '2',
      nama: 'Jus Mangga',
      gambarUrl: 'https://via.placeholder.com/150',
      porsi: '1 gelas',
      durasi: '10 menit',
      bahan: ['Mangga', 'Air', 'Gula'],
      langkah: ['Kupas mangga', 'Masukkan ke blender', 'Tambahkan gula & air', 'Blender hingga halus'],
      isPublished: false,
    ),
  ];

  List<ResepModel> get semuaResep => _daftarResep;

  List<ResepModel> get resepDipublikasikan =>
      _daftarResep.where((resep) => resep.isPublished).toList();

  List<ResepModel> get koleksiResep =>
      _daftarResep.where((resep) => !resep.isPublished).toList();

  List<ResepModel> get resepDisimpan =>
      _daftarResep.where((resep) => !resep.isPublished).toList();

  void tambahResep(ResepModel resepBaru) {
    _daftarResep.add(resepBaru);
    notifyListeners();
  }

  List<ResepModel> cariResep(String keyword) {
    return resepDipublikasikan
        .where((r) => r.nama.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}
