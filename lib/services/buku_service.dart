import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/buku_model.dart';

class BukuService {
  // Ganti dengan URL Laravel kamu
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<List<Buku>> fetchBuku() async {
    final url = Uri.parse('$baseUrl/buku');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> bukuList = data['data'];

        return bukuList.map((json) => Buku.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data buku');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
