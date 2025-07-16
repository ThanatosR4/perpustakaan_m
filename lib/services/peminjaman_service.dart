import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/peminjaman_model.dart';

class PeminjamanService {
  // Ambil daftar peminjaman siswa
  static Future<List<Peminjaman>> fetchPeminjaman() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/siswa/peminjaman'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Peminjaman.dendaPerHari = data['denda_per_hari'] ?? 0; 
      return List<Peminjaman>.from(
        data['data'].map((item) => Peminjaman.fromJson(item)),
      );
    } else {
      throw Exception('Gagal memuat data peminjaman');
    }
  }

  // Kirim permintaan peminjaman buku
  static Future<void> pinjamBuku({
    required int bukuId,
    required DateTime tanggalPinjam,
    required int lamaPinjam,
    String keterangan = '', 
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/siswa/peminjaman'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {
        'buku_id': bukuId.toString(),
        'tanggal_pinjam': DateFormat('yyyy-MM-dd').format(tanggalPinjam),
        'lama_pinjam': lamaPinjam.toString(),
        'keterangan': keterangan,
      },
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw error['message'] ?? 'Gagal meminjam buku';
    }
  }

}
