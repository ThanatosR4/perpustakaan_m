import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/buku_model.dart';

class BukuService {
  static const String baseUrl = 'https://perpustakaansma1telker.web.id';

  // Ambil semua buku
  static Future<List<Buku>> fetchBuku() async {
    final url = Uri.parse('$baseUrl/api/buku');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> bukuList = data['data'];

        return bukuList.map((json) => Buku.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data buku (Status ${response.statusCode})');
      }
    } on TimeoutException {
      throw Exception('Waktu permintaan habis. Coba lagi nanti.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat buku: $e');
    }
  }

  // Jika kamu ingin fitur lain seperti detail buku (by ID), kamu bisa tambahkan seperti ini:
  static Future<Buku> fetchBukuById(int id) async {
    final url = Uri.parse('$baseUrl/api/buku/$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Buku.fromJson(data['data']);
      } else {
        throw Exception('Gagal memuat detail buku');
      }
    } on TimeoutException {
      throw Exception('Permintaan waktu habis.');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
