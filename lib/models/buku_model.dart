class Buku {
  final int id;
  final String judul;
  final String pengarang;
  final int stok;
  final int tahunTerbit;
  final String gambarUrl;
  final String kategoriKode;
  final String sinopsis;
  final String isbn;

  Buku({
    required this.id,
    required this.judul,
    required this.pengarang,
    required this.stok,
    required this.tahunTerbit,
    required this.gambarUrl,
    required this.kategoriKode,
    required this.sinopsis,
    required this.isbn,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: int.tryParse(json['id'].toString()) ?? 0,
      judul: json['judul'] ?? '',
      pengarang: json['pengarang'] ?? '',
      stok: int.tryParse(json['stok'].toString()) ?? 0,
      tahunTerbit: int.tryParse(json['tahun_terbit'].toString()) ?? 0,
      gambarUrl: json['gambar'] != null
          ? 'https://perpustakaansma1telker.web.id/storage/${json['gambar']}'
          : 'https://via.placeholder.com/150',
      kategoriKode: json['kategori_id'].toString(),
      sinopsis: json['sinopsis'] ?? '',
      isbn: json['isbn'] ?? '-',
    );
  }
}
