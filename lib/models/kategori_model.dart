class Kategori {
  final String kode;

  Kategori({required this.kode});

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      kode: json['kode'] ?? '',
    );
  }
}
