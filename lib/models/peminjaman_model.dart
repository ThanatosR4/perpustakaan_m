class Peminjaman {
  final int id;
  final String bukuJudul;
  final String bukuPengarang;
  final DateTime tanggalPinjam;
  final int lamaPinjam;
  final DateTime tanggalKembali;
  final String status;
  final String gambar;
  static int dendaPerHari = 0;


  Peminjaman({
    required this.id,
    required this.bukuJudul,
    required this.bukuPengarang,
    required this.tanggalPinjam,
    required this.lamaPinjam,
    required this.tanggalKembali,
    required this.status,
    required this.gambar,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: json['id'],
      bukuJudul: json['buku']['judul'] ?? 'Tanpa Judul',
      bukuPengarang: json['buku']['pengarang'] ?? 'Tidak diketahui',
      tanggalPinjam: DateTime.parse(json['tanggal_pinjam']),
      lamaPinjam: json['lama_pinjam'],
      tanggalKembali: DateTime.parse(json['tanggal_kembali']),
      status: json['status'],
      gambar: json['buku']['gambar'] ?? 'https://via.placeholder.com/120',
    );
  }

    int get denda {
    final now = DateTime.now();
    if (status == 'dipinjam' && now.isAfter(tanggalKembali)) {
      final terlambat = now.difference(tanggalKembali).inDays;
      return terlambat * dendaPerHari;
    }
    return 0;
    }

}
