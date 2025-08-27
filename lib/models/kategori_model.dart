class Kategori {
  final int id;
  final String kode;

  Kategori({
    required this.id,
    required this.kode,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: int.tryParse(json['id'].toString()) ?? 0,
      kode: json['kode'] ?? '',
    );
  }
}
