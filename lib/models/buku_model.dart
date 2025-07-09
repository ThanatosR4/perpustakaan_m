class Buku {
  final int id;
  final String judul;
  final String pengarang;
  final String sinopsis;
  final String gambar;
  final String kategoriKode;

  Buku({
    required this.id,
    required this.judul,
    required this.pengarang,
    required this.sinopsis,
    required this.gambar,
    required this.kategoriKode,
  });

  String get gambarUrl => "http://127.0.0.1:8000/$gambar";

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'],
      judul: json['judul'] ?? '',
      pengarang: json['pengarang'] ?? '',
      sinopsis: json['sinopsis'] ?? '',
      gambar: json['gambar'] ?? '',
      kategoriKode: json['kategori'] != null ? json['kategori']['kode'] ?? '' : '',
    );
  }
}
