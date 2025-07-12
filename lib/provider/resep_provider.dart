import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/resep_model.dart';

class ResepProvider with ChangeNotifier {
  final List<ResepModel> _daftarResep = [];
  String? _userIdLogin; // Tambahkan untuk menyimpan ID user login

  // Setter untuk userId login
  void setUserLoginId(String userId) {
    _userIdLogin = userId;
    notifyListeners();
  }

  // Getter semua resep
  List<ResepModel> get semuaResep => _daftarResep;

  // Getter resep yang dipublikasikan
  List<ResepModel> get resepDipublikasikan =>
      _daftarResep.where((resep) => resep.isPublished == true).toList();

  // Getter koleksi resep milik user login
  List<ResepModel> get koleksiResep {
    if (_userIdLogin == null) return [];
    return _daftarResep
        .where((resep) => resep.isPublished == false && resep.userId == _userIdLogin)
        .toList();
  }

  // Ambil semua data resep dari Firestore
  Future<void> fetchResepDariFirestore() async {
    try {
      final resepSnapshot = await FirebaseFirestore.instance.collection('resep').get();

      _daftarResep.clear();

      for (var doc in resepSnapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id; // Tambahkan ID dokumen ke data

        final resep = ResepModel.fromMap(data);
        _daftarResep.add(resep);
      }

      notifyListeners();
    } catch (e) {
      print("Error fetch resep dari Firestore: $e");
    }
  }

  // Tambah resep ke Firestore
  Future<void> tambahResepKeFirestore(ResepModel resepBaru) async {
    try {
      await FirebaseFirestore.instance
          .collection('resep')
          .doc(resepBaru.id)
          .set(resepBaru.toJson());

      _daftarResep.add(resepBaru);
      notifyListeners();
    } catch (e) {
      print("Error tambah resep ke Firestore: $e");
    }
  }
  // Simpan resep orang lain ke koleksi user saat ini
Future<void> simpanResepDariOrangLain(ResepModel resepAsli, String userIdLogin) async {
  try {
    final resepBaru = ResepModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // id baru
      userId: userIdLogin,
      username: resepAsli.username,
      nama: resepAsli.nama,
      gambarUrl: resepAsli.gambarUrl,
      porsi: resepAsli.porsi,
      durasi: resepAsli.durasi,
      bahan: resepAsli.bahan,
      langkah: resepAsli.langkah,
      isPublished: false, // simpan sebagai koleksi (belum publish)
    );

    await tambahResepKeFirestore(resepBaru); // pakai method yang sudah ada
  } catch (e) {
    print("Gagal menyimpan resep dari orang lain: $e");
  }
}

  // Cari resep berdasarkan nama
  List<ResepModel> cariResep(String keyword) {
    return resepDipublikasikan
        .where((r) =>
            r.nama != null &&
            r.nama!.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}
