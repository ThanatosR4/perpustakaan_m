class Buku {
  final int id;
  final String judul;
  final String pengarang;
  final String sinopsis;
  final String gambar;
  final String kategoriKode;
  final String isbn;
  final int stok;
  final int tahunTerbit;

  Buku({
    required this.id,
    required this.judul,
    required this.pengarang,
    required this.sinopsis,
    required this.gambar,
    required this.kategoriKode,
    required this.isbn,
    required this.stok,
    required this.tahunTerbit,
  });

  String get gambarUrl => "http://10.0.2.2:8000/storage/$gambar";

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'],
      judul: json['judul'] ?? '',
      pengarang: json['pengarang'] ?? '',
      sinopsis: json['sinopsis'] ?? '',
      gambar: json['gambar'] ?? '',
      kategoriKode: json['kategori'] != null ? json['kategori']['kode'] ?? '' : '',
      isbn: json['isbn'] ?? '',
      stok: json['stok'] ?? 0,
      tahunTerbit: json['tahun_terbit'] ?? 0,
    );
  }
}
