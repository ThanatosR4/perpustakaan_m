class Peminjaman {
  final int id;
  final String bukuJudul;
  final String bukuPengarang;
  final DateTime? tanggalPinjam;
  final int lamaPinjam;
  final DateTime? tanggalKembali;
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
    final buku = json['buku'] ?? {};

    return Peminjaman(
      // id aman → bisa int atau string
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,

      // data buku
      bukuJudul: buku['judul']?.toString() ?? 'Tanpa Judul',
      bukuPengarang: buku['pengarang']?.toString() ?? 'Tidak diketahui',

      // tanggal pinjam & kembali (nullable)
      tanggalPinjam: (json['tanggal_pinjam'] != null && json['tanggal_pinjam'].toString().isNotEmpty)
          ? DateTime.tryParse(json['tanggal_pinjam'].toString())
          : null,
      tanggalKembali: (json['tanggal_kembali'] != null && json['tanggal_kembali'].toString().isNotEmpty)
          ? DateTime.tryParse(json['tanggal_kembali'].toString())
          : null,

      // lama pinjam aman → bisa int/string
      lamaPinjam: int.tryParse(json['lama_pinjam']?.toString() ?? '') ?? 0,

      // status
      status: json['status']?.toString() ?? 'tidak diketahui',

      // gambar buku
      gambar: buku['gambar'] != null
          ? 'https://perpustakaansma1telker.web.id/storage/${buku['gambar']}'
          : 'https://via.placeholder.com/120',
    );
  }

  // hitung denda otomatis
  int get denda {
    final now = DateTime.now();
    if (status == 'dipinjam' && tanggalKembali != null && now.isAfter(tanggalKembali!)) {
      final terlambat = now.difference(tanggalKembali!).inDays;
      return terlambat * dendaPerHari;
    }
    return 0;
  }

  // format tanggal pinjam
  String get formattedTanggalPinjam =>
      tanggalPinjam != null
          ? "${tanggalPinjam!.year}-${tanggalPinjam!.month.toString().padLeft(2, '0')}-${tanggalPinjam!.day.toString().padLeft(2, '0')}"
          : '-';

  // format tanggal kembali
  String get formattedTanggalKembali =>
      tanggalKembali != null
          ? "${tanggalKembali!.year}-${tanggalKembali!.month.toString().padLeft(2, '0')}-${tanggalKembali!.day.toString().padLeft(2, '0')}"
          : '-';
}
