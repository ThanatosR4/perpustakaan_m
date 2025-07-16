import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/buku_model.dart';

class BukuService {
  
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<List<Buku>> fetchBuku() async {
    final url = Uri.parse('$baseUrl/api/buku');

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
