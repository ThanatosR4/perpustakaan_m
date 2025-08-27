import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/peminjaman_model.dart';

class PeminjamanService {
  static const String _baseUrl = 'https://perpustakaansma1telker.web.id';

  /// Ambil daftar peminjaman siswa
  static Future<List<Peminjaman>> fetchPeminjaman() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      throw Exception('Token tidak ditemukan. Harap login ulang.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/api/siswa/peminjaman'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Peminjaman.dendaPerHari = int.tryParse(data['denda_per_hari'].toString()) ?? 0;
      return List<Peminjaman>.from(
        data['data'].map((item) => Peminjaman.fromJson(item)),
      );
    } else {
      print('Fetch Error: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Gagal memuat data peminjaman');
    }
  }

  /// Kirim permintaan peminjaman buku
  static Future<void> pinjamBuku({
    required int bukuId,
    required DateTime tanggalPinjam,
    required int lamaPinjam,
    String keterangan = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      throw Exception('Token tidak ditemukan. Harap login ulang.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/api/siswa/peminjaman'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'buku_id': bukuId.toString(),
        'tanggal_pinjam': DateFormat('yyyy-MM-dd').format(tanggalPinjam),
        'lama_pinjam': lamaPinjam.toString(),
        'keterangan': keterangan,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] != true) {
        throw Exception(data['message'] ?? 'Gagal meminjam buku');
      }
    } else {
      print('POST Error: ${response.statusCode}');
      print('Response: ${response.body}');
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal meminjam buku');
    }
  }
}
