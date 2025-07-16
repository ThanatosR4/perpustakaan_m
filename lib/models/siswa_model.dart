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
    if (foto == null || foto!.isEmpty) {
      return ''; 
    }
    return 'http://10.0.2.2:8000/storage/$foto';
  }

  factory Siswa.fromJson(Map<String, dynamic> json) {
    return Siswa(
      id: json['id'],
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      nisn: json['kode'] ?? '',
      foto: json['foto'],
      kelas: json['kelas'],
      telepon: json['telepon'],
      alamat: json['alamat'],
      jenisKelamin: json['jenis_kelamin'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
    );
  }

  @override
  String toString() {
    return 'Siswa(nama: $nama, email: $email, nisn: $nisn)';
  }
}
