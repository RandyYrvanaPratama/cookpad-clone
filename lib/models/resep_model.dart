class ResepModel {
  String? id;
  String? userId;
  String? username;
  String? nama;
  String? gambarUrl;
  String? porsi;
  String? durasi;
  List<String>? bahan;
  List<String>? langkah;
  bool? isPublished;

  ResepModel({
    this.id,
    this.userId,
    this.username,
    this.nama,
    this.gambarUrl,
    this.porsi,
    this.durasi,
    this.bahan,
    this.langkah,
    this.isPublished,
  });

  factory ResepModel.fromMap(Map<String, dynamic> map) {
    return ResepModel(
      id: map['id'],
      userId: map['userId'],
      username: map['username'] ?? 'Anonim',
      nama: map['nama'],
      gambarUrl: map['gambarUrl'],
      porsi: map['porsi'],
      durasi: map['durasi'],
      bahan: List<String>.from(map['bahan'] ?? []),
      langkah: List<String>.from(map['langkah'] ?? []),
      isPublished: map['isPublished'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['username'] = username;
    data['nama'] = nama;
    data['gambarUrl'] = gambarUrl;
    data['porsi'] = porsi;
    data['durasi'] = durasi;
    data['bahan'] = bahan;
    data['langkah'] = langkah;
    data['isPublished'] = isPublished;
    return data;
  }

  ResepModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? nama,
    String? gambarUrl,
    String? porsi,
    String? durasi,
    List<String>? bahan,
    List<String>? langkah,
    bool? isPublished,
  }) {
    return ResepModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      nama: nama ?? this.nama,
      gambarUrl: gambarUrl ?? this.gambarUrl,
      porsi: porsi ?? this.porsi,
      durasi: durasi ?? this.durasi,
      bahan: bahan ?? this.bahan,
      langkah: langkah ?? this.langkah,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}
