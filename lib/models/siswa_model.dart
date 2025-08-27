class Siswa {
  final int id;
  final String nama;
  final String email;
  final String nisn;
  final String? foto;
  final String? kelas;
  final String? telepon;
  final String? alamat;
  final String? jenisKelamin;
  final String? tempatLahir;
  final String? tanggalLahir;

  Siswa({
    required this.id,
    required this.nama,
    required this.email,
    required this.nisn,
    this.foto,
    this.kelas,
    this.telepon,
    this.alamat,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
  });

  String get fotoUrl {
    if (foto == null || foto!.isEmpty) return '';
    return 'https://perpustakaansma1telker.web.id/storage/$foto';
  }

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      nisn: json['kode'] ?? '',
      foto: json['foto'],
      kelas: json['kelas']?.toString(),
      telepon: json['telepon']?.toString(),
      alamat: json['alamat']?.toString(),
      jenisKelamin: json['jenis_kelamin']?.toString(),
      tempatLahir: json['tempat_lahir']?.toString(),
      tanggalLahir: json['tanggal_lahir']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Siswa(nama: $nama, email: $email, nisn: $nisn)';
  }
}
