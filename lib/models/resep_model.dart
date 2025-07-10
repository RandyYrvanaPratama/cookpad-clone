class ResepModel {
  final String id;
  final String nama;
  final String gambarUrl;
  final String porsi;
  final String durasi;
  final List<String> bahan;
  final List<String> langkah;
  final bool isPublished;

  ResepModel({
    required this.id,
    required this.nama,
    required this.gambarUrl,
    required this.porsi,
    required this.durasi,
    required this.bahan,
    required this.langkah,
    this.isPublished = false,
  });
}
